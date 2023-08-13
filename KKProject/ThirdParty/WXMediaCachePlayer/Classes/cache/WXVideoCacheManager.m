//
//  WXVideoCacheManager.m
//  -
//
//  Created by zk on 2021/8/17.
//

#import "WXVideoCacheManager.h"
#import "WXVideoDownloader.h"
#import "WXVideoResourceLog.h"

//预加载每个资源的百分比0-1
#define kVideoPreloadRatio 1.0

@interface WXVideoCacheManager ()

@property (nonatomic, strong) WXVideoDownloader *downloader;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSMutableDictionary *cacheWorkers;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) NSMutableSet *cachedUrls; //记录缓存过得
@property (nonatomic, strong) dispatch_queue_t queue;


@property (nonatomic, strong) NSString *curResUrl;
@property (nonatomic, weak) WXVideoCacheWorker *curCacheWorker;
@property (atomic, assign) int64_t startOffset;

@property (nonatomic, assign) unsigned long long maxCacheSize;// 单位bytes  默认209715200  200M
@property (nonatomic, assign) int expireDay;  //缓存多少天过期  默认7天

@end

@implementation WXVideoCacheManager

+ (instancetype)shareInstance {
    static WXVideoCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WXVideoCacheManager alloc] init];
    });
    
    return manager;
}

+ (NSString *)getCacheDirectory {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"wxMediaCache"];
    return dir;
}

+ (BOOL)supportPreloadVideoForUrl:(NSString *)url {
    
    if ([url.pathExtension.lowercaseString containsString:@"mp4"]) {
        return YES;
    }
    
    return NO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downloader = [[WXVideoDownloader alloc] init];
        self.downloader.delegate = self;
        self.cacheWorkers = [NSMutableDictionary dictionary];
        self.cachedUrls = [NSMutableSet set];
        self.urls = [NSMutableArray array];
        self.lock = [[NSLock alloc] init];
        self.queue = dispatch_queue_create("com.videoCacheManager", DISPATCH_QUEUE_SERIAL);
        self.maxCacheSize = 524288000;// 默认500M
        self.expireDay = 7;
        [self cleanDiskIfNeeded];
    }
    return self;
}

- (WXVideoCacheWorker *)cacheWorkForUrl:(NSString *)url {
    [self.lock lock];
    WXVideoCacheWorker *worker = [self workerForKey:url];
    if (!worker) {
        worker = [[WXVideoCacheWorker alloc] initWithResourceUrl:url];
        [self setWorker:worker ForKey:url];
    }
    [self.lock unlock];
    return worker;;
}

- (void)addPreloadTaskWithUrl:(NSString *)url {
    
    if (![self.class supportPreloadVideoForUrl:url]) {
        return;
    }
    
    [self runInSafeThread:^{
        
        [self.cachedUrls addObject:url];
        
        if ([self.urls containsObject:url]) {
            return;
        }
        
        
        [self.urls addObject:url];
        
        
        if (self.urls.count == 1) {
            [self scheduledDownloadTask];
        }
    }];
}


- (void)removePreloadTaskWithUrl:(NSString *)url {
    
    [self runInSafeThread:^{
        if (![self.urls containsObject:url]) {
            return;
        }
        
        [WXVideoResourceLog log:[NSString stringWithFormat:@"-----取消预加载%@",url]];
        if ([self.curResUrl isEqualToString:url]) { //当前在执行
            [self.curCacheWorker save];
            self.curResUrl = nil;
            self.curCacheWorker = nil;
            [self.downloader cancelDownloadingTask];
            
            if (self.urls.count) {
                [self.urls removeObjectAtIndex:0]; //移除当前的
                [self scheduledDownloadTask];   //继续后面的任务
            }
            
        } else {
            [self.urls removeObject:url];
        }
    }];
    
}

+ (void)cleanCache {
    [[WXVideoCacheManager shareInstance] removeAllCache];
}

- (void)removeAllCache {
    [self runInSafeThread:^{
        
        [self cancelAllPreloadTask];
        
        NSString *basepath = [self.class getCacheDirectory];
        [[NSFileManager defaultManager] removeItemAtPath:basepath error:nil];
    }];
}

- (void)cancelAllPreloadTask {
    [self runInSafeThread:^{
        [self.curCacheWorker save];
        
        self.curResUrl = nil;
        self.curCacheWorker = nil;
        
        [self.downloader cancelDownloadingTask];
        [self.urls removeAllObjects];
        [self.cacheWorkers removeAllObjects];
        [self.cachedUrls removeAllObjects];
    }];
}

- (unsigned long long)cacheSize {
    NSString *folderPath = [self.class getCacheDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
        NSString *fileName;
        long long folderSize = 0;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        return folderSize;
}

- (BOOL)hasPreloadUrl:(NSString *)url {
    BOOL ret = NO;
    
    for (NSString *str in self.cachedUrls) {
        if ([str containsString:url]) {
            ret = YES;
            break;;
        }
    }
    return ret;
}

- (void)runInSafeThread:(dispatch_block_t)block {

    if (!block) {
        return;
    }

//    dispatch_async(self.queue, block);
    
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(self.queue)) {
        block();
    } else {
        dispatch_async(self.queue, block);
    }
    
}

- (void)cleanDiskIfNeeded {
    
    [self runInSafeThread:^{
       
        unsigned long long cacheSize = [self cacheSize];
        NSString *baseDir = [self.class getCacheDirectory];
        
        
        
        // 这两个变量主要是为了下面生成NSDirectoryEnumerator准备的
        // 一个是记录遍历的文件目录，一个是记录遍历需要预先获取文件的哪些属性
        NSURL *diskCacheURL = [NSURL fileURLWithPath:baseDir isDirectory:YES];
        
        /*
         NSURLCreationDateKey //创建时间

         NSURLContentAccessDateKey //最后一次访问时间

         NSURLContentModificationDateKey //最后修改时间
         */
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        // 递归地遍历diskCachePath这个文件夹中的所有目录，此处不是直接使用diskCachePath，而是使用其生成的NSURL
        // 此处使用includingPropertiesForKeys:resourceKeys，这样每个file的resourceKeys对应的属性也会在遍历时预先获取到
        // NSDirectoryEnumerationSkipsHiddenFiles表示不遍历隐藏文件
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:resourceKeys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-(self.expireDay*24*3600)];//7天过期
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        
        NSLog(@"%@",NSDate.date);
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            BOOL isDirectory = [resourceValues[NSURLIsDirectoryKey] boolValue];
            if (!isDirectory) { //不是目录就跳过
                continue;
            }
//            NSLog(@"%@ /n %@",resourceValues,fileURL);
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileURL];
                continue;
            }
        }
        
        for (NSURL *fileURL in urlsToDelete) {
            // 根据需要移除文件的url来移除对应file
            [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
        }
        
        //移除7天未访问的资源后如果还是超过最大缓存 清空
        if (self.maxCacheSize && cacheSize > self.maxCacheSize) { //超过最大缓存 全删除
            [self removeAllCache];
            return;
        }
        
    }];
    
}

- (void)scheduledDownloadTask {
    [self runInSafeThread:^{
        NSString *url = self.urls.firstObject;
        if (!url) {
        
            [WXVideoResourceLog log:[NSString stringWithFormat:@"-----预加载任务完成 没有任务了"]];
            self.curResUrl = nil;
            self.curCacheWorker = nil;
            return;
        }
        
        self.curResUrl = url;
        WXVideoCacheWorker *worker = [self cacheWorkForUrl:url];
        self.curCacheWorker = worker;
        
        NSArray<NSValue*> *arr = worker.cacheConfig.allFragments;
        unsigned long long totalSize = worker.cacheConfig.contentInfo.contentLength;
        unsigned long long downloadedSize = 0;
        for (NSValue* value in arr) {
            downloadedSize += value.rangeValue.length;
        }
        
        [WXVideoResourceLog log:[NSString stringWithFormat:@"-----准备预加载资源%@",url]];
        
        if (totalSize<= 0 || (totalSize > 0 && downloadedSize*1.0/totalSize < kVideoPreloadRatio)) {
            
            [WXVideoResourceLog log:[NSString stringWithFormat:@"-----开始下载资源%@",url]];
            int64_t offset = 0;
                    
            if (arr.firstObject) {
                NSRange range = arr.firstObject.rangeValue;
                offset = range.location+range.length-1;
            }
            self.startOffset = offset;
            NSURLSessionTask *task = [self.downloader downLoadURL:[NSURL URLWithString:url] beginOffset:offset];
            [task resume];
        } else {
        
            [WXVideoResourceLog log:[NSString stringWithFormat:@"-----当前资源已经下载完成%@",url]];
            [self.urls removeObject:url];
            
            [self scheduledDownloadTask];
        }
    }];
}

#pragma mark - downloader

- (void)downloader:(WXVideoDownloader *)downloader didReceiveResponse:(NSURLResponse *)response task:(NSURLSessionDataTask *)task {
    [self runInSafeThread:^{
        
        if (!self.curCacheWorker) {
            return;
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
            
            NSInteger statusCode = [HTTPURLResponse statusCode];
            
            // 成功
            if (statusCode >= 200 && statusCode < 300) {
                NSString *acceptRange = HTTPURLResponse.allHeaderFields[@"Accept-Ranges"];
                
                BOOL byteRangeAccessSupported = [acceptRange isEqualToString:@"bytes"];
                
                long long contentLength = [[[HTTPURLResponse.allHeaderFields[@"Content-Range"]
                                                      componentsSeparatedByString:@"/"] lastObject] longLongValue];
                
                /*
                 "Content-Length" = 2;
                 "Content-Range" = "bytes 0-1/11493061";
                 
                 这里Content-Length是请求range对应的大小，Content-Range斜杠后面的对应的是资源的总大小
                 */
                
                
                NSString *mimeType = response.MIMEType;
                CFStringRef cContentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType,
                                                                                (__bridge CFStringRef)(mimeType),
                                                                                NULL);

                NSString *contentType = CFBridgingRelease(cContentType);
                
                WXVideoContentInfo *info = self.curCacheWorker.cacheConfig.contentInfo;
                if (!info) {
                    
                    info = [WXVideoContentInfo new];
                    info.contentType = contentType;
                    info.contentLength = contentLength;
                    info.byteRangeAccessSupported = byteRangeAccessSupported;
                    
                    NSError *error = nil;
                    [self.curCacheWorker setContentInfo:info error:&error];
                    [self.curCacheWorker save];
                }
            }
        }
    }];
}

- (void)downloader:(WXVideoDownloader *)downloader didReceiveData:(NSData *)data task:(NSURLSessionDataTask *)task {
    [self runInSafeThread:^{
        
        if (!self.curCacheWorker) {
            return;
        }
        
        NSRange range = NSMakeRange(self.startOffset, data.length);
        [self.curCacheWorker cacheData:data forRange:range error:nil];
        self.startOffset += data.length;
        
        
//        NSArray<NSValue*> *arr = self.curCacheWorker.cacheConfig.allFragments;
//        unsigned long long totalSize = self.curCacheWorker.cacheConfig.contentInfo.contentLength;
//        unsigned long long downloadedSize = 0;
//        for (NSValue* value in arr) {
//            downloadedSize += value.rangeValue.length;
//        }
        
//        if (totalSize > 0 && downloadedSize*1.0/totalSize > kVideoPreloadRatio) { //下载超过30%就换下一个
//            [task cancel];
//        }
        
    }];
}

- (void)downloader:(WXVideoDownloader *)downloader didCompleteWithError:(NSError *)error task:(NSURLSessionTask *)task {
    [self runInSafeThread:^{
        
        if (![task.currentRequest.URL.absoluteString isEqualToString:self.curResUrl]) {
            return;
        }
        
        if (error.code == NSURLErrorCancelled) {
            return;
        }
        
        if (!self.curCacheWorker) {
            return;
        }
        
        if (error) {
            [WXVideoResourceLog log:[NSString stringWithFormat:@"-----当前资源下载出错%@ --- error:%@",self.curResUrl,error]];
        } else {
            [WXVideoResourceLog log:[NSString stringWithFormat:@"-----当前资源下载完成%@",self.curResUrl]];
        }
        
        [self.curCacheWorker save];
        
        if (self.urls.count) {
            [self.urls removeObjectAtIndex:0];
        }
        [self scheduledDownloadTask];
    }];
}

#pragma mark -- setter

- (void)setWorker:(WXVideoCacheWorker *)woker ForKey:(NSString *)key {
    [self.cacheWorkers setValue:woker forKey:key];
}

- (WXVideoCacheWorker *)workerForKey:(NSString *)key {
    return [self.cacheWorkers objectForKey:key];
}

//单个文件的大小(字节)
- (unsigned long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end
