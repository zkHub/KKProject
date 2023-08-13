//
//  WXVideoLoadRequest.h
//  -
//
//  Created by zk on 2021/8/25.
//

#import <Foundation/Foundation.h>
#import "WXVideoDownloader.h"
#import "WXVideoCacheWorker.h"

@import AVFoundation;
@class WXVideoLoadRequestWorker;
@protocol WXVideoLoadRequestWorkerDelegate <NSObject>

- (void)requestWorker:(WXVideoLoadRequestWorker *)requestWoker didCompleteWithError:(NSError *)error;

@end

@interface WXVideoLoadRequestWorker : NSObject

@property (nonatomic, strong, readonly) AVAssetResourceLoadingRequest *loadRequest;
@property (nonatomic, weak) id<WXVideoLoadRequestWorkerDelegate> delegate;

- (instancetype)initWithDownloer:(WXVideoDownloader *)downloader cacheWorker:(WXVideoCacheWorker *)cacheWorker loadingRequest:(AVAssetResourceLoadingRequest*)loadRequest;

- (void)start;
- (void)cancel;

@end


