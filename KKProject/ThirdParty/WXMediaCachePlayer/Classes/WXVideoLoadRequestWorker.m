//
//  WXVideoLoadRequest.m
//  -
//
//  Created by zk on 2021/8/25.
//

#import "WXVideoLoadRequestWorker.h"
#import "WXVideoCacheAction.h"
#import "WXVideoResourceLoader.h"
#import "WXVideoResourceLog.h"

@interface WXVideoLoadRequestWorker () <WXVideoDownloaderDelegate>

@property (nonatomic, strong) WXVideoDownloader *downloaer;
@property (nonatomic, weak) WXVideoCacheWorker *cacheWorker;
@property (nonatomic, strong, readwrite) AVAssetResourceLoadingRequest *loadRequest;

@property (nonatomic, strong) NSMutableArray<WXVideoCacheAction*> *requestActions;
@property (nonatomic, getter=isCancelled) BOOL cancelled;
@property (nonatomic, strong) WXVideoContentInfo *info;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (atomic, assign) int64_t startOffset;

@end

@implementation WXVideoLoadRequestWorker

- (instancetype)initWithDownloer:(WXVideoDownloader *)downloader cacheWorker:(WXVideoCacheWorker *)cacheWorker loadingRequest:(AVAssetResourceLoadingRequest *)loadRequest {
    self = [super init];
    if (self) {
        self.queue = dispatch_queue_create("xes.videoloader.queue", DISPATCH_QUEUE_SERIAL);
        _downloaer = downloader;
        _downloaer.delegate = self;
        _cacheWorker = cacheWorker;
        _loadRequest = loadRequest;
        
        _info = _cacheWorker.cacheConfig.contentInfo;
    }
    return self;
}

- (void)start {
    [self runInSafeThread:^{
        long long offset = self.loadRequest.dataRequest.requestedOffset;
        long long length = self.loadRequest.dataRequest.requestedLength;
        
        NSRange range = NSMakeRange(offset, length);
        
        /*
         当 requestsAllDataToEndOfResource 的值为 YES 时，您应该忽略requestedLength 的值，并从requestedOffset 开始逐步提供资源包含的尽可能多的数据，直到您成功提供了所有可用数据并调用了-finishLoading，直到遇到 失败并调用 -finishLoadingWithError:，或者直到您收到 -resourceLoader:didCancelLoadingRequest: 对于从中获取 AVAssetResourceLoadingDataRequest 的 AVAssetResourceLoadingRequest。
         */
        if (self.loadRequest.dataRequest.requestsAllDataToEndOfResource == YES) {
            
            if (self.info) {
                range.length = self.info.contentLength - range.location;
            }
        }
        
        self.requestActions = [[self.cacheWorker dataActionsForRange:range] mutableCopy];
        
        [self processActions];
    }];
}

- (void)cancel {
    [self runInSafeThread:^{
        self.cancelled = YES;
        [self.downloaer cancelDownloadingTask];
        
//        if (!self.loadRequest.isFinished) {
//            NSError *error = [[NSError alloc] initWithDomain:@"com.resourceloader"
//                                                        code:NSURLErrorCancelled
//                                                    userInfo:@{NSLocalizedDescriptionKey:@"Resource loader cancelled"}];
//            [self.loadRequest finishLoadingWithError:error];
//
//            if ([self.delegate respondsToSelector:@selector(requestWorker:didCompleteWithError:)]) {
//                [self.delegate requestWorker:self didCompleteWithError:error];
//            }
//        }
    }];
}

- (void)dealloc {
    [self.downloaer invalidate];
}


#pragma mark - private

- (void)runInSafeThread:(dispatch_block_t)block {

    if (!block) {
        return;
    }

    if (!self.queue) {
        block();
    }
    
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(self.queue)) {
        block();
    } else {
        dispatch_async(self.queue, block);
    }
    
}

- (void)downloadRemoteResourceFor:(NSRange)range loadRequest:(AVAssetResourceLoadingRequest *)loadRequest {
    
    [self runInSafeThread:^{
        [WXVideoResourceLog log:[NSString stringWithFormat:@"开始下载资源 --- %@",NSStringFromRange(range)]];
        
        NSURL *URL = [self originURL:loadRequest.request.URL];
        
        NSURLSessionTask *task = [self.downloaer downLoadURL:URL range:range];

        self.startOffset = range.location;
        
        [task resume];
    }];
}

- (void)fillContentInfomation:(AVAssetResourceLoadingRequest *)loadRequest {
    [self runInSafeThread:^{
        if (!loadRequest.contentInformationRequest.contentType && self.info) {
            //填充信息
            AVAssetResourceLoadingContentInformationRequest *contentInfomation = loadRequest.contentInformationRequest;
            
            contentInfomation.contentType = self.info.contentType;
            contentInfomation.contentLength = self.info.contentLength;
            
            //http://wxnacy.com/2018/09/05/http-accept-ranges/
            contentInfomation.byteRangeAccessSupported = self.info.byteRangeAccessSupported;
        }
    }];
}

- (void)cancelProcess {
    [WXVideoResourceLog log:[NSString stringWithFormat:@"process cancel"]];
    
    NSError *error = [[NSError alloc] initWithDomain:@"com.resourceloader"
                                                code:NSURLErrorCancelled
                                            userInfo:@{NSLocalizedDescriptionKey:@"Resource loader cancelled"}];
    [self.loadRequest finishLoadingWithError:error];
    
    if ([self.delegate respondsToSelector:@selector(requestWorker:didCompleteWithError:)]) {
        [self.delegate requestWorker:self didCompleteWithError:error];
    }
}

- (void)processActions {
    
    
    if (self.isCancelled) {
        
        [self cancelProcess];
        return;
    }
    
    WXVideoCacheAction *action = self.requestActions.firstObject;
    
    if (!action) {
        
        //标记完成
        [self.loadRequest finishLoading];
        
        
        //TODO:
        if ([self.delegate respondsToSelector:@selector(requestWorker:didCompleteWithError:)]) {
            [self.delegate requestWorker:self didCompleteWithError:nil];
        }
        
        [WXVideoResourceLog log:[NSString stringWithFormat:@"当前request完成 --range: %@-%@",@(self.loadRequest.dataRequest.requestedOffset),@(self.loadRequest.dataRequest.requestedLength)]];
        return;
    }
    
    NSRange range = action.range;
    
    [self.requestActions removeObjectAtIndex:0];
    
    if (action.type == WXCacheActionTypeLocal) {
        
        //填充info
        [self fillContentInfomation:self.loadRequest];
        
        //查询本地资源
        NSError *error;
        NSData *data = [self.cacheWorker cachedDataForRange:range error:&error];
        
        if (self.isCancelled) {
            
            [self cancelProcess];
            return;
        }
        
        
        if (data && !error) {
            [self.loadRequest.dataRequest respondWithData:data];
            [WXVideoResourceLog log:[NSString stringWithFormat:@"本地资源 %@",NSStringFromRange(range)]];
            
            [self processActions];
        } else {
            [WXVideoResourceLog log:[NSString stringWithFormat:@"本地资源出错"]];
            [self.loadRequest finishLoadingWithError:error];
            if ([self.delegate respondsToSelector:@selector(requestWorker:didCompleteWithError:)]) {
                [self.delegate requestWorker:self didCompleteWithError:error];
            }
        }
    } else if (action.type == WXCacheActionTypeRemote) {
        [WXVideoResourceLog log:[NSString stringWithFormat:@"网络资源 %@",NSStringFromRange(range)]];
        [self downloadRemoteResourceFor:range loadRequest:self.loadRequest];
    }
    
}


#pragma mark - downloader
//开始接受数据
/*
 {
     "Access-Control-Allow-Methods" = "POST, GET, OPTIONS";
     "Access-Control-Allow-Origin" = "*";
     "Cache-Control" = "max-age=600";
     Connection = "keep-alive";
     "Content-Language" = "zh-CN";
     "Content-Length" = 2;
     "Content-Range" = "bytes 0-1/11493061";
     "Content-Type" = "video/mp4";
     Date = "Mon, 26 Jul 2021 00:12:33 GMT";
     Etag = b4a9956020d317e6c781a680d924437e;
     Expires = "Mon, 26 Jul 2021 00:22:33 GMT";
     "Last-Modified" = "Mon, 21 Jun 2021 16:07:44 GMT";
     Server = "NWS_TCloud_SOC1D";
     "X-Cache-Lookup" = "Cache Hit, Hit From Inner Cluster";
     "X-Daa-Tunnel" = "hop_count=2";
     "X-NWS-LOG-UUID" = 12552810342810159477;
     "x-cos-hash-crc64ecma" = 1020084886812821853;
     "x-cos-object-type" = normal;
     "x-cos-storage-class" = STANDARD;
 
 
 
 }
 */
//https://cizixs.com/2015/10/06/http-resume-download/
//https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Range_requests
//https://www.teaspect.com/detail/5940
- (void)downloader:(WXVideoDownloader *)downloader didReceiveResponse:(NSURLResponse *)response task:(NSURLSessionDataTask *)task {
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
            
            [self runInSafeThread:^{
                if (!self.info) {
                    WXVideoContentInfo *info = [WXVideoContentInfo new];
                    info.contentType = contentType;
                    info.contentLength = contentLength;
                    info.byteRangeAccessSupported = byteRangeAccessSupported;
                    self.info = info;
                    
                    NSError *error = nil;
                    
                    [self.cacheWorker setContentInfo:info error:&error];
                }
                
                [self fillContentInfomation:self.loadRequest];
            }];
        }
        
        
    }
}

- (void)downloader:(WXVideoDownloader *)downloader didReceiveData:(NSData *)data task:(NSURLSessionDataTask *)task {
    [self runInSafeThread:^{
        [self.loadRequest.dataRequest respondWithData:data];
        NSRange range = NSMakeRange(self.startOffset, data.length);
        [self.cacheWorker cacheData:data forRange:range error:nil];
        self.startOffset += data.length;
    }];
}

- (void)downloader:(WXVideoDownloader *)downloader didCompleteWithError:(NSError *)error task:(NSURLSessionTask *)task {
    
//    if (error.code == NSURLErrorCancelled) {
//        return;
//    }
    
    NSRange range = [self rangeOfTask:task];
    [WXVideoResourceLog log:[NSString stringWithFormat:@"下载完成 %@ | reason:%@",NSStringFromRange(range),error.code == NSURLErrorCancelled ? @"NSURLErrorCancelled" : error]];
    [self runInSafeThread:^{
        if (error) {
            [self.loadRequest finishLoadingWithError:error];
            
            if ([self.delegate respondsToSelector:@selector(requestWorker:didCompleteWithError:)]) {
                [self.delegate requestWorker:self didCompleteWithError:error];
            }
       
        } else {
            [self processActions];
        }
        
        [self.cacheWorker save];
    }];
    
}

#pragma mark - getter

- (NSURL *)originURL:(NSURL *)URL {
    NSURL *originURL = nil;
    NSString *originStr = [URL absoluteString];
    originStr = [originStr stringByReplacingOccurrencesOfString:kCacheScheme withString:@""];
    originURL = [NSURL URLWithString:originStr];
    return originURL;
}

- (NSRange)rangeOfTask:(NSURLSessionTask *)task {
    NSDictionary *header = task.currentRequest.allHTTPHeaderFields;
    NSString *rangeStr = [header objectForKey:@"Range"];
    if (rangeStr && [rangeStr containsString:@"bytes="]) {
        rangeStr = [rangeStr stringByReplacingOccurrencesOfString:@"bytes=" withString:@""];
        NSArray *arr = [rangeStr componentsSeparatedByString:@"-"];
        long long start = [arr[0] longLongValue];
        long long end = [arr[1] longLongValue];
        return NSMakeRange(start, end - start + 1);
    }else {
        return NSMakeRange(0, 0);
    }
}

@end
