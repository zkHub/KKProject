//
//  WXMediaCachePlayer.m
//  WXMediaCachePlayer
//
//  Created by zk on 2021/8/26.
//

#import "WXMediaCachePlayer.h"
#import "WXCachePlayer.h"
#import "WXVideoResourceLoaderManager.h"

@interface _VideoView : UIView
@property (nonatomic, strong) dispatch_block_t didLayoutSubviews;
@end

@implementation _VideoView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.didLayoutSubviews ? self.didLayoutSubviews():nil;
    
}


@end

@interface WXMediaCachePlayer ()

@property (nonatomic, strong) WXVideoResourceLoaderManager *resourceLoader;
@property (nonatomic, strong) WXCachePlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playLayer;
@property (nonatomic, strong, readwrite) _VideoView *videoView;

@end

@implementation WXMediaCachePlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enableCache = YES;
        self.resourceLoader = [[WXVideoResourceLoaderManager alloc] init];
        self.player = [[WXCachePlayer alloc] init];
        self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.videoView = [[_VideoView alloc] init];
        
        [self.videoView.layer insertSublayer:self.playLayer atIndex:0];
        
        [self bindBlocks];
    }
    return self;
}

- (void)bindBlocks {
    __weak typeof(self) weakSelf = self;
    self.videoView.didLayoutSubviews = ^{
        if (!CGRectEqualToRect(weakSelf.videoView.bounds, weakSelf.playLayer.frame)) {
            weakSelf.playLayer.frame = weakSelf.videoView.bounds;
        }
    };
    
    self.player.timeChanged = ^(int current, int duration) {
        if ([weakSelf.delegate respondsToSelector:@selector(mediaPlayer:currentPlayTime:)]) {
            [weakSelf.delegate mediaPlayer:weakSelf currentPlayTime:current];
        }
    };
    
    self.player.statusChange = ^(AVPlayerItemStatus status) {
        if ([weakSelf.delegate respondsToSelector:@selector(mediaPlayer:statusChanged:)]) {
            [weakSelf.delegate mediaPlayer:weakSelf statusChanged:status];
        }
    };
    
    self.player.bufferingStateChange = ^(BOOL isBuffering) {
        if ([weakSelf.delegate respondsToSelector:@selector(mediaPlayer:buffering:)]) {
            [weakSelf.delegate mediaPlayer:weakSelf buffering:isBuffering];
        }
    };
//
//    self.player.loadingStateChanged = ^(BOOL isLoading) {
//
//    };
    
    self.player.didPlayToEnd = ^{
        if ([weakSelf.delegate respondsToSelector:@selector(mediaPlayerDidPlayToEnd:)]) {
            [weakSelf.delegate mediaPlayerDidPlayToEnd:weakSelf];
        }
    };
    
}

- (void)playWithUrl:(NSString *)urlString {
    [self.resourceLoader cancelAllRequest];
    AVPlayerItem *item = [self.resourceLoader playerItemWithURL:[NSURL URLWithString:urlString]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}

- (void)playWithFilePath:(NSString *)filePath {
    NSURL *url = [NSURL fileURLWithPath:filePath];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}


- (UIView *)view{
    return self.videoView;
}

- (void)play {
    [self.player play];
}
- (void)pause {
    [self.player pause];
}

- (void)stop {
    [self.player pause];
    [self.playLayer removeFromSuperlayer];
    [self.videoView removeFromSuperview];
    self.player = nil;
    
    [self.resourceLoader cancelAllRequest];
}

- (void)setRate:(CGFloat)rate {
//    self.player.rate = rate;
    [self.player setPlayerRate:rate];
}
- (void)setVolume:(CGFloat)volume {
    self.player.volume = volume;
}

- (CGFloat)currentTime {
    return self.player.currentTime;
}

- (CGFloat)duration {
    return self.player.duration;
}

- (void)seekToTime:(float)time {
    [self.player seekToTime:time];
}

@end
