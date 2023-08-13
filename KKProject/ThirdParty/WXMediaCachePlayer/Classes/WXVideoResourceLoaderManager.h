//
//  WXVideoResourceLoader.h
//  -
//
//  Created by zk on 2021/7/14.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXVideoResourceLoaderManager : NSObject <AVAssetResourceLoaderDelegate>


- (AVPlayerItem *)playerItemWithURL:(NSURL *)url;

- (void)cancelAllRequest;

@end

NS_ASSUME_NONNULL_END
