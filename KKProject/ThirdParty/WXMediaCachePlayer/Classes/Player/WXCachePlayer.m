//
//  WXCachePlayer.m
//  -
//
//  Created by zk on 2021/8/3.
//

#import "WXCachePlayer.h"
#import "WXVideoResourceLog.h"

@interface WXCachePlayer ()

@property (nonatomic, readwrite) BOOL isPlaying;
@property (nonatomic, readwrite) BOOL isBuffering;
@property (nonatomic, readwrite) BOOL isSeeking;
@property (nonatomic, assign) float seekTarget;
@property (nonatomic, copy) dispatch_block_t seekCallback;

@property (nonatomic, strong) NSTimer *playTimer;

@property (nonatomic, assign) float playRate;
@end

@implementation WXCachePlayer

-(void)dealloc
{
    if (self.willDealloc)
    {
        self.willDealloc();
    }
    //AVPlayer释放时最好先把AVPlayerItem置空，否则会有解码线程残留着
    [self replaceCurrentItemWithPlayerItem:nil];
    [self removeObserver:self forKeyPath:@"rate"];
//    [self removeObserver:self forKeyPath:@"status"];
    [self removeObserver:self forKeyPath:@"timeControlStatus"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.playTimer invalidate];
    self.playTimer = nil;
    
    [WXVideoResourceLog log:[NSString stringWithFormat:@"播放器被释放"]];
    
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.playerRate = 1;
        [self addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
//        [self addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newErrorLog:) name:AVPlayerItemNewErrorLogEntryNotification object:nil];
        
        [self addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
        
        self.actionAtItemEnd = AVPlayerActionAtItemEndPause;

        if (@available(iOS 10.0, *)) {
            self.automaticallyWaitsToMinimizeStalling = NO;
           /*
            当该值为 YES 时，AVPlayer 会努力尝试延迟开始播放，加载足够的数据来保证整个播放过程中尽量卡顿最少
            */
        }
//
        __weak typeof(self) weakSelf = self;

        [self addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            __strong typeof(weakSelf) self = weakSelf;
            
            if (self.currentItem.status != AVPlayerItemStatusReadyToPlay) {
                return;
            }
            
            if (self.timeChanged) {
                self.timeChanged(self.currentTime, self.duration);
            }

        }];
        
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf timerAction];
        }];
    }
    return self;
}

- (void)timerAction {
    if (self.isPlaying&&!self.isBuffering)
    {
        [super play];
    }
    else
    {
        [super pause];
    }
}

- (void)setPlayerRate:(CGFloat)rate {
    
    if (rate < 0 || rate > 2) {
        return;
    }
    
    self.playRate = rate;
    
    [self setRate:self.playRate];
}

- (void)setRate:(float)rate {

    if (rate > 0) { //防止AVPlayer 调用play自动设置为1倍速
        [super setRate:self.playRate];
    } else {
        [super setRate:rate];
    }
}

#pragma mark - notification
-(void)itemPlayToEnd:(NSNotification*)notification
{
    [self pause];
    if (self.currentItem&&self.didPlayToEnd)
    {
        self.didPlayToEnd();
    }
    
}


-(void)newErrorLog:(NSNotification*)notification
{
    if (self.newErrorLog)
    {
        self.newErrorLog(self.currentItem.errorLog.events.lastObject);
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"rate"])
    {
        if (self.rate == 0 && self.isPlaying) {
            self.loadingStateChanged ? self.loadingStateChanged(YES) : nil;
        } else if(self.rate > 0) {
            self.loadingStateChanged ? self.loadingStateChanged(NO) : nil;
        }
    
    }
    else if ([keyPath isEqualToString:@"status"] && object == self.currentItem)
    {
        if (self.seekTarget>=0&&self.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.currentItem seekToTime:CMTimeMakeWithSeconds(self.seekTarget, 1000) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                
                if (self.seekCallback)
                {
                    self.seekCallback();
                    self.seekCallback = nil;
                }
                
                self.seekTarget = -1;
                self.seekCallback = nil;
                
                self.isSeeking = NO;
                if (self.isPlaying)
                {
                    if (self.willPlay)
                    {
                        self.willPlay();
                    }
                    [super play];
                }
                
            }];
        }
        
        if (self.statusChange)
        {
            self.statusChange(self.currentItem.status);
        }
    }
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"])
    {
        AVPlayerItem *item = object;
        if (item.playbackLikelyToKeepUp)
        {
            if (self.isPlaying)
            {
                [super play];
            }
        }
        else
        {
            [super pause];
        }
        
        
        if (self.playbackLikelyToKeepUpChange)
        {
            if (self.playbackLikelyToKeepUpChange)
            {
                self.playbackLikelyToKeepUpChange(self.currentItem.playbackLikelyToKeepUp);
            }
            
            if (self.isPlaying&&self.currentItem.playbackLikelyToKeepUp)
            {
                [super play];
            }
            
        }
        if (self.currentItem.playbackLikelyToKeepUp)
        {
            self.isBuffering = NO;
        }
        else
        {
            self.isBuffering = YES;
        }
    }
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        if (self.playbackBufferEmptyChange)
        {
            if(self.currentItem)
            {
                if (self.playbackBufferEmptyChange)
                {
                    self.playbackBufferEmptyChange(self.currentItem.playbackBufferEmpty);
                }
                
            }
            
        }
        
        if (self.currentItem.playbackBufferEmpty)
        {
            self.isBuffering = YES;
        }
        else
        {
            
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 计算缓冲进度
        
        NSArray *loadedTimeRanges = [[self currentItem] loadedTimeRanges];
        CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float startSeconds        = CMTimeGetSeconds(timeRange.start);
        float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
        
        CMTime duration = self.currentItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        
        if (totalDuration <= 0) {
            return;
        }
        
        CGFloat progress = result/totalDuration;
        //TODO:
        if (self.bufferProgressChanged) {
            self.bufferProgressChanged(progress);
        }
    } else if ([keyPath isEqualToString:@"timeControlStatus"]) {
        AVPlayerTimeControlStatus status = [[change objectForKey:NSKeyValueChangeNewKey]integerValue];
        if (status == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
            //loading
//            NSLog(@"loading YES");
        } else {
//            NSLog(@"loading NO");
        }
    }
}


#pragma mark - override


-(void)play
{
    if (self.willPlay)
    {
        self.willPlay();
    }
    self.isPlaying = YES;
    if (!self.currentItem)
    {
//        [self replaceCurrentItemWithPlayerItem:[QZPlayerItem playerItemWithAsset:self.asset]];
    }
    self.isBuffering = !self.currentItem.playbackLikelyToKeepUp;
    [super play];
}

-(void)pause
{
    if (self.willPause)
    {
        self.willPause();
    }
    self.isPlaying = NO;
    [super pause];
}


-(void)replaceCurrentItemWithPlayerItem:(AVPlayerItem *)item
{
    if (self.currentItem)
    {
        [self.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [self.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [self.currentItem removeObserver:self forKeyPath:@"status"];
        [self.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
    if (item)
    {
        [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [item addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [super replaceCurrentItemWithPlayerItem:item];
    }

}

-(void)seekToTime:(float)time complete:(void(^)(void))complete
{
    if (self.willPause)
    {
        self.willPause();
    }
    self.isSeeking = YES;
    [super pause];
    
    __weak typeof(self) weakSelf = self;
    
    [self.currentItem cancelPendingSeeks];
    if (self.status == AVPlayerItemStatusReadyToPlay)
    {
        [self.currentItem seekToTime:CMTimeMakeWithSeconds(time, 1000) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            __strong typeof(weakSelf) self = weakSelf;
            self.seekTarget = -1;
            self.seekCallback = nil;
            
            self.isSeeking = NO;
            if (self.isPlaying)
            {
                if (self.willPlay)
                {
                    self.willPlay();
                }
                [super play];
            }
            if (complete)
            {
                complete();
            }
            
        }];
    }
    else
    {
        self.seekTarget = time;
        self.seekCallback = complete;
    }
}

-(void)seekToTime:(float)time
{
    [self seekToTime:time complete:nil];
}


#pragma mark - setter

- (void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    if (self.playStatusChange)
    {
        self.playStatusChange();
    }
}

- (void)setIsBuffering:(BOOL)isBuffering
{
    if (_isBuffering!=isBuffering)
    {
        _isBuffering = isBuffering;
        if (self.bufferingStateChange)
        {
            self.bufferingStateChange(isBuffering);
        }
    }
    
    
    if (!self.isBuffering&&self.isPlaying)
    {
        [super play];
    }
    else
    {
        [super pause];
    }
}

- (void)setIsSeeking:(BOOL)isSeeking
{
    _isSeeking = isSeeking;
    if (isSeeking)
    {
        self.isBuffering = YES;
    }
    else
    {
        self.isBuffering = !self.currentItem.playbackLikelyToKeepUp;
    }
}


#pragma mark - property


- (float)duration
{
    if (self.currentItem.status != AVPlayerItemStatusReadyToPlay) {
        return 0;
    }
    
    if (CMTIME_IS_INVALID(self.currentItem.duration))
    {
        return 0;
    }
    double dur = CMTimeGetSeconds(self.currentItem.duration);
    if (isinf(dur)||isnan(dur))
    {
        dur = 0;
    }
    return dur;
}


- (float)currentTime
{
    if (self.currentItem.status != AVPlayerItemStatusReadyToPlay) {
        return 0;
    }
    
    if (CMTIME_IS_INVALID(self.currentItem.currentTime))
    {
        return 0;
    }
    return CMTimeGetSeconds(self.currentItem.currentTime);
}

@end
