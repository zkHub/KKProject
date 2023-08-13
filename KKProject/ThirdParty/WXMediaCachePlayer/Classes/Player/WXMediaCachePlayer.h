//
//  WXMediaCachePlayer.h
//  WXMediaCachePlayer
//
//  Created by zk on 2021/8/26.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@class WXMediaCachePlayer;

@protocol WXMediaCachePlayerDelegate <NSObject>

- (void)mediaPlayerDidPlayToEnd:(WXMediaCachePlayer *)player;
- (void)mediaPlayer:(WXMediaCachePlayer *)player currentPlayTime:(CGFloat)time;
- (void)mediaPlayer:(WXMediaCachePlayer *)player buffering:(BOOL)buffering;
- (void)mediaPlayer:(WXMediaCachePlayer *)player statusChanged:(AVPlayerItemStatus)status;

@end

@interface WXMediaCachePlayer : NSObject

@property (nonatomic, weak) id<WXMediaCachePlayerDelegate> delegate;
@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, assign) BOOL enableCache; //default YES

- (void)playWithUrl:(NSString *)urlString;
- (void)playWithFilePath:(NSString *)filePath;
- (void)play;
- (void)pause;
- (void)stop;

- (void)setRate:(CGFloat)rate;
- (void)setVolume:(CGFloat)volume;

- (CGFloat)currentTime;
- (CGFloat)duration;

- (void)seekToTime:(float)time;


@end

NS_ASSUME_NONNULL_END
