//
//  WXVideoResourceLoadManager.m
//  -
//
//  Created by zk on 2021/7/15.
//

#import "WXVideoResourceLoader.h"
#import <objc/runtime.h>
#import "WXVideoDownloader.h"
#import "WXVideoCacheWorker.h"
#import "WXVideoContentInfo.h"
#import "WXVideoCacheManager.h"
#import "WXVideoLoadRequestWorker.h"
#import "WXVideoResourceLog.h"

@interface WXVideoResourceLoader () <WXVideoLoadRequestWorkerDelegate>

@property (nonatomic, strong) NSMutableArray<WXVideoLoadRequestWorker*> *pendingRequestWorkers;

@property (nonatomic, strong) WXVideoDownloader *downloader;
@property (nonatomic, strong) WXVideoCacheWorker *cacheWorker;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation WXVideoResourceLoader

- (instancetype)initWithResourceUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        
        self.pendingRequestWorkers = [NSMutableArray array];
        self.downloader = [[WXVideoDownloader alloc] init];
        self.queue = dispatch_queue_create("xes.resourceLoader.queue", DISPATCH_QUEUE_SERIAL);
        
//        self.cacheWorker = [[WXVideoCacheWorker alloc] initWithResourceUrl:url];
        self.cacheWorker = [[WXVideoCacheManager shareInstance] cacheWorkForUrl:url];
        
        //取消当前资源预加载
        [[WXVideoCacheManager shareInstance] removePreloadTaskWithUrl:url];
        
    }
    return self;
}

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

- (void)dealloc {
    [self.cacheWorker save];
}

- (void)addResourceLoaderRequest:(AVAssetResourceLoadingRequest *)request {
    
    [self runInSafeThread:^{
        [WXVideoResourceLog log:[NSString stringWithFormat:@"收到新的请求 --range: %@-%@",@(request.dataRequest.requestedOffset),@(request.dataRequest.requestedLength)]];
        if (self.pendingRequestWorkers > 0) {
            
            WXVideoDownloader *downloader = [[WXVideoDownloader alloc] init];
            WXVideoLoadRequestWorker *requestWorker = [[WXVideoLoadRequestWorker alloc] initWithDownloer:downloader cacheWorker:self.cacheWorker loadingRequest:request];
            requestWorker.delegate = self;
            [self.pendingRequestWorkers addObject:requestWorker];
            [requestWorker start];
        } else {
            
            WXVideoLoadRequestWorker *requestWorker = [[WXVideoLoadRequestWorker alloc] initWithDownloer:self.downloader cacheWorker:self.cacheWorker loadingRequest:request];
            requestWorker.delegate = self;
            [self.pendingRequestWorkers addObject:requestWorker];
            
            [requestWorker start];
        }
    }];
}

- (void)cancelResourceLoadReqeust:(AVAssetResourceLoadingRequest *)request {
    [self runInSafeThread:^{
        [WXVideoResourceLog log:[NSString stringWithFormat:@"取消任务 --range: %@-%@",@(request.dataRequest.requestedOffset),@(request.dataRequest.requestedLength)]];
//        [self removeResourceLoadReqeust:request];
        
        __block WXVideoLoadRequestWorker *worker;
        [self.pendingRequestWorkers enumerateObjectsUsingBlock:^(WXVideoLoadRequestWorker * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.loadRequest == request) {
                worker = obj;
                *stop = YES;
            }
        }];
        
        if (worker) {
            [worker cancel]; //不在这里从数据里移除，在cancel完成的回调里再从数组移除
            //[self.pendingRequestWorkers removeObject:worker];
        }
        
    }];
}

- (void)removeResourceLoadReqeust:(AVAssetResourceLoadingRequest *)request {
    
    [self runInSafeThread:^{
        __block WXVideoLoadRequestWorker *worker;
        [self.pendingRequestWorkers enumerateObjectsUsingBlock:^(WXVideoLoadRequestWorker * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.loadRequest == request) {
                worker = obj;
                *stop = YES;
            }
        }];
        
        if (worker) {
            [self.pendingRequestWorkers removeObject:worker];
        }
    }];
}

- (void)cancelAllRequest {
    [self runInSafeThread:^{
        [self.pendingRequestWorkers enumerateObjectsUsingBlock:^(WXVideoLoadRequestWorker * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [obj cancel];
           
        }];
        
        [self.pendingRequestWorkers removeAllObjects];
    }];
}


#pragma mark - delegate

- (void)requestWorker:(WXVideoLoadRequestWorker *)requestWoker didCompleteWithError:(NSError *)error {
        
    [self removeResourceLoadReqeust:requestWoker.loadRequest];
}
@end
