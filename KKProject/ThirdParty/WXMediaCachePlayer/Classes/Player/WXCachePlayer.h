//
//  WXCachePlayer.h
//  -
//
//  Created by zk on 2021/8/3.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface WXCachePlayer : AVPlayer

@property (nonatomic,copy) void(^didPlayToEnd)(void);
@property (nonatomic,copy) void(^playbackLikelyToKeepUpChange)(BOOL playbackLikelyToKeepUp);
@property (nonatomic,copy) void(^playbackBufferEmptyChange)(BOOL playbackBufferEmpty);
@property (nonatomic,copy) void(^playStatusChange)(void);
@property (nonatomic,copy) void(^willPlay)(void);
@property (nonatomic,copy) void(^willPause)(void);
@property (nonatomic,copy) void(^willDealloc)(void);
@property (nonatomic,copy) void(^newErrorLog)(AVPlayerItemErrorLogEvent *errorEvent);
@property (nonatomic,copy) void(^bufferingStateChange)(BOOL isBuffering);
@property (nonatomic,copy) void(^statusChange)(AVPlayerItemStatus status);
@property (nonatomic,copy) void(^bufferProgressChanged)(CGFloat bufferProgress);
@property (nonatomic,copy) void(^timeChanged)(int current,int duration);
@property (nonatomic,copy) void(^loadingStateChanged)(BOOL isLoading);
@property (nonatomic,readonly) BOOL isPlaying;
@property (nonatomic,readonly) BOOL isBuffering;
@property (nonatomic,readonly) BOOL isSeeking;

//@property (nonatomic,readonly) NSURL* currentPlayingUrl;

- (void)setPlayerRate:(CGFloat)rate;

- (float)duration;
- (float)currentTime;

- (void)seekToTime:(float)time;
- (void)seekToTime:(float)time complete:(void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
