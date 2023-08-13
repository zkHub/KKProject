//
//  WXVideoResourceLoadManager.h
//  -
//
//  Created by zk on 2021/7/15.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kCacheScheme @"__kCacheScheme__"

@interface WXVideoResourceLoader : NSObject

- (instancetype)initWithResourceUrl:(NSString *)url;

- (void)addResourceLoaderRequest:(AVAssetResourceLoadingRequest *)request;
- (void)cancelResourceLoadReqeust:(AVAssetResourceLoadingRequest *)request;

- (void)cancelAllRequest;

@end

NS_ASSUME_NONNULL_END
