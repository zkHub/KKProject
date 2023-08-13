//
//  WXVideoResourceLoader.m
//  -
//
//  Created by zk on 2021/7/14.
//

#import "WXVideoResourceLoaderManager.h"
#import "WXVideoResourceLoader.h"


@interface WXVideoResourceLoaderManager ()

@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) NSMutableDictionary<NSString *,WXVideoResourceLoader*> *workers;

@end

@implementation WXVideoResourceLoaderManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.workers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequest];
}

/*
 [Symptoms] {
   "transportType" : "HTTP Progressive Download",
   "mediaType" : "HTTP Progressive Download",
   "BundleID" : "-",
   "name" : "MEDIA_PLAYBACK_STALL",
   "interfaceType" : "Other"
 }
 
 */

- (AVPlayerItem *)playerItemWithURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    NSURL *url1;
    BOOL setDelegate = NO;
    if ([url.absoluteString hasPrefix:@"http"] && [url.absoluteString.pathExtension.lowercaseString containsString:@"mp4"]) {
        //只处理MP4边下边播
        url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kCacheScheme,url.absoluteString]];
        setDelegate = YES;
    } else {
        url1 = url;
    }
    

    self.asset = [AVURLAsset URLAssetWithURL:url1 options:nil];
    if (setDelegate) {
        [self.asset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
    }
    
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:self.asset];
    if ([item respondsToSelector:@selector(setCanUseNetworkResourcesForLiveStreamingWhilePaused:)]) {
        item.canUseNetworkResourcesForLiveStreamingWhilePaused = YES;
    }
    return item;
}

- (void)cancelAllRequest {
    for (WXVideoResourceLoader *work in self.workers.allValues) {
        [work cancelAllRequest];
    }
    
    [self.workers removeAllObjects];
}

#pragma mark - delegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    NSURL *resourceURL = [loadingRequest.request URL];
    
    if ([resourceURL.absoluteString hasPrefix:kCacheScheme]) {
        
        NSString *strUrl = [self originURLString:resourceURL];
        
        WXVideoResourceLoader *loader = self.workers[strUrl];
        
        if (!loader) {
            loader = [[WXVideoResourceLoader alloc] initWithResourceUrl:strUrl];
            self.workers[strUrl] = loader;
        }
        
        [loader addResourceLoaderRequest:loadingRequest];
        
        return YES;
    }
    
    return NO;
}


- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSURL *resourceURL = [loadingRequest.request URL];
    NSString *strUrl = [self originURLString:resourceURL];
    //取消下载
    WXVideoResourceLoader *loader = self.workers[strUrl];
    [loader cancelResourceLoadReqeust:loadingRequest];
}




- (NSString *)originURLString:(NSURL *)URL {
    NSURL *originURL = nil;
    NSString *originStr = [URL absoluteString];
    originStr = [originStr stringByReplacingOccurrencesOfString:kCacheScheme withString:@""];
    originURL = [NSURL URLWithString:originStr];
    return originURL.absoluteString;
}

@end
