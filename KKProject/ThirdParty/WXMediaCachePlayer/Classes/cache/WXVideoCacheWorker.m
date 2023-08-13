//
//  WXVideoCacheWorker.m
//  -
//
//  Created by zk on 2021/7/22.
//

#import "WXVideoCacheWorker.h"
#import "NSString+resMd5.h"
#import "WXVideoCacheManager.h"
#import "WXVideoResourceLog.h"

@interface WXVideoCacheWorker ()
//https://www.cnblogs.com/blogoflzh/p/4712888.html
@property (nonatomic, strong) NSFileHandle *writeHandler;
@property (nonatomic, strong) NSFileHandle *readHandler;

@property (nonatomic, strong, readwrite) WXVideoCacheConfig *cacheConfig;

@end

@implementation WXVideoCacheWorker

- (instancetype)initWithResourceUrl:(NSString *)url {
    if (self = [super init]) {
        
        NSString *path = [WXVideoCacheWorker cachedFilePathForURL:url];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        NSString *cacheFolder = [path stringByDeletingLastPathComponent];
        if (![fileManager fileExistsAtPath:cacheFolder]) {
            [fileManager createDirectoryAtPath:cacheFolder
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:&error];
        } else {
            
            [[NSURL fileURLWithPath:cacheFolder] setResourceValue:NSDate.date forKey:NSURLContentModificationDateKey error:nil];
        }
        
        
        if (!error) {
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
            } else {
                [[NSURL fileURLWithPath:path] setResourceValue:NSDate.date forKey:NSURLContentModificationDateKey error:nil];
            }
            
            NSURL *fileURL = [NSURL fileURLWithPath:path];
            
            self.readHandler = [NSFileHandle fileHandleForReadingFromURL:fileURL error:&error];
            
            self.writeHandler = [NSFileHandle fileHandleForWritingToURL:fileURL error:&error];
            
            
            self.cacheConfig = [WXVideoCacheConfig configurationForFilePath:path];
        }
        
    }
    
    return self;
}

- (void)setContentInfo:(WXVideoContentInfo *)contentInfo error:(NSError **)error {
    
    self.cacheConfig.contentInfo = contentInfo;
    
    @synchronized (self.writeHandler) {
        @try {
            [self.writeHandler truncateFileAtOffset:contentInfo.contentLength];
            [self.writeHandler synchronizeFile];
        } @catch (NSException *exception) {
            
            [WXVideoResourceLog log:[NSString stringWithFormat:@"异常1： %@",exception]];
            *error = [NSError errorWithDomain:exception.name code:123 userInfo:@{NSLocalizedDescriptionKey: exception.reason, @"exception": exception}];
        }
        
    }
}

- (void)cacheData:(NSData *)data forRange:(NSRange)range error:(NSError **)error {
    @synchronized (self.writeHandler) {
        @try {
            [self.writeHandler seekToFileOffset:range.location ];
            [self.writeHandler writeData:data];
            [self.cacheConfig addCacheFragment:range];
        } @catch (NSException *exception) {
            
            [WXVideoResourceLog log:[NSString stringWithFormat:@"异常2： %@",exception]];
            *error = [NSError errorWithDomain:exception.name code:123 userInfo:@{NSLocalizedDescriptionKey: exception.reason, @"exception": exception}];
        }
    }
}

- (NSData *)cachedDataForRange:(NSRange)range error:(NSError **)error {
    @synchronized (self.readHandler) {
        
        @try {
            [self.readHandler seekToFileOffset:range.location];
            NSData *data = [self.readHandler readDataOfLength:range.length];
            
            return data;
        } @catch (NSException *exception) {
        
            [WXVideoResourceLog log:[NSString stringWithFormat:@"read cached data error %@",exception]];
            *error = [NSError errorWithDomain:exception.name code:123 userInfo:@{NSLocalizedDescriptionKey: exception.reason, @"exception": exception}];
        }
        
    }
    
    return nil;
}

- (NSArray<WXVideoCacheAction*>*)dataActionsForRange:(NSRange)range {
    
    NSArray<NSValue*> *fragments = self.cacheConfig.allFragments;
    
    NSMutableArray *actions = [NSMutableArray array];
    if (range.location == NSNotFound) {
        return [actions copy];
    }
    
    //step1  先找出所有和目标range相交的本地片段
    NSInteger endOffset = range.location + range.length;
    [fragments enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSRange cacheRange = obj.rangeValue;
        
        NSRange intersectionRange = NSIntersectionRange(range, cacheRange);
        
        if (cacheRange.location >= endOffset) {
            *stop = YES;
        } else if (intersectionRange.length) { // 有相交部分
            WXVideoCacheAction *action = [[WXVideoCacheAction alloc] initWithActionType:WXCacheActionTypeLocal range:intersectionRange];
            [actions addObject:action];
        }
        
    }];
    
    
    //step2按顺序组装local和remote片段
    if (actions.count == 0) { //没有local片段
        WXVideoCacheAction *action = [[WXVideoCacheAction alloc] initWithActionType:WXCacheActionTypeRemote range:range];
        [actions addObject:action];
    } else {
        
        /*
            local片段: 2-5,8-3,13-2
         
            req:  0-20
            2-5本地,8-3本地,13-2本地
            0-2远端 2-5本地 7-1远端 8-3本地 11-2远端 13-2本地 15-5远端
         */
        NSMutableArray *localRemoteActions = [NSMutableArray array];
        [actions enumerateObjectsUsingBlock:^(WXVideoCacheAction  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSRange localRange = obj.range;
            
            if (idx == 0) { //计算左侧超出的remote片段
                if (localRange.location > range.location) {
                    NSRange remoteRange = NSMakeRange(range.location, localRange.location-range.location);
                    WXVideoCacheAction *action = [[WXVideoCacheAction alloc] initWithActionType:WXCacheActionTypeRemote range:remoteRange];
                    
                    [localRemoteActions addObject:action];
                }
                
                [localRemoteActions addObject:obj];
            } else {
                
                WXVideoCacheAction *lastAction = localRemoteActions.lastObject;
                NSInteger lastOffset = lastAction.range.location + lastAction.range.length;
                
                if (localRange.location > lastOffset) { //计算中间需要补上的remote片段
                    NSRange remoteRange = NSMakeRange(lastOffset, localRange.location-lastOffset);
                    WXVideoCacheAction *action = [[WXVideoCacheAction alloc] initWithActionType:WXCacheActionTypeRemote range:remoteRange];
                    [localRemoteActions addObject:action];
                }
                [localRemoteActions addObject:obj];
            }
            
            if (idx == actions.count - 1) { //计算右侧超出的remote片段
                NSInteger localEndOffset = localRange.location + localRange.length;
                if (endOffset > localEndOffset) {
                    NSRange remoteRange = NSMakeRange(localEndOffset, endOffset-localEndOffset);
                    WXVideoCacheAction *action = [[WXVideoCacheAction alloc] initWithActionType:WXCacheActionTypeRemote range:remoteRange];
                    [localRemoteActions addObject:action];
                }
            }
            
        }];
        actions = localRemoteActions;
    }
    
    return actions.copy;
    
}

- (void)save {
    @synchronized (self.writeHandler) {
        [self.writeHandler synchronizeFile];
        [self.cacheConfig save];
    }
}

- (void)dealloc {
    [self save];
    
    [_writeHandler closeFile];
    [_readHandler closeFile];
    
    
}

#pragma mark - getter

+ (NSString *)cachedFilePathForURL:(NSString *)url {
    NSString *pathComponent = nil;
    pathComponent = [url md5String];
    
    NSString *baseDir = [self cachedFileBaseDirectoryForURL:url];
    
    pathComponent = [pathComponent stringByAppendingPathExtension:url.pathExtension];
    
    return [baseDir stringByAppendingPathComponent:pathComponent];
}

+ (NSString *)cachedFileBaseDirectoryForURL:(NSString *)url  {
    NSString *pathComponent = nil;
    pathComponent = [url md5String];
    NSString *baseDir = [[self getCacheDirectory] stringByAppendingPathComponent:pathComponent];
    return baseDir;
}

+ (NSString *)getCacheDirectory {
    return [WXVideoCacheManager getCacheDirectory];
//    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"wxMediaCache"];
//    return dir;
}

/*
 //沙盒根目录
 NSString *homePath = NSHomeDirectory();
 //document目录
 NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
 //library目录
 NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
 //caches目录
 NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
 //application support目录
 NSString *applicationSupportPath = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject;
 //preference目录
 NSString *preferencePath = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject;
 //tem目录
 NSString *temPath = NSTemporaryDirectory();
 */

@end
