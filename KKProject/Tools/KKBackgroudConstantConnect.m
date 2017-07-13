//
//  BackgroudConstantConnect.m
//  WebForJS
//
//  Created by zhangke on 2017/7/6.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import "KKBackgroudConstantConnect.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


@interface KKBackgroudConstantConnect ()
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskId;

@end


@implementation KKBackgroudConstantConnect



+ (instancetype)shareInstance {
    static KKBackgroudConstantConnect *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[KKBackgroudConstantConnect alloc]init];
    });
    return _shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepAudio];
    }
    return self;
}



- (void)openBackgroundModel
{
    // 每隔一分钟去检查剩余的时间
    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(tik) userInfo:nil repeats:YES];
    }
}
- (void)closeBackgroundModel{

    if ([_player isPlaying]){
        [_player stop];
    }
    
}

- (void)tik
{
    // 这个是定时检查后台剩余时间
    NSTimeInterval  time = [[UIApplication sharedApplication] backgroundTimeRemaining];
    //NSLog(@"%f",time);
    if (time < 60.00)
    {
        // 此处是播放一段空的音乐，声音为零时间很短循环播放的特点
        [self playAudio];
//        __weak BackgroudConstantConnect *weakSelf = self;
        self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            //结束申请
//            __strong BackgroudConstantConnect *strongSelf = weakSelf;
//            [[UIApplication sharedApplication] endBackgroundTask:strongSelf.backgroundTaskId];
//            strongSelf.backgroundTaskId = UIBackgroundTaskInvalid;
        }];
    }
}

- (void)playAudio
{
    if ([_player isPlaying]) {
        [_player stop];
    }
    [_player play];
}

- (BOOL)prepAudio
{
    NSError *outError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&outError];     //播放模式
    
    if (self.player) {
        return YES;
    } else {
        return NO;
    }
}

- (AVAudioPlayer *)player {
    if (!_player) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"soufunimbackground" ofType:@"m4r"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return nil;
        } else {
            NSURL *url = [NSURL fileURLWithPath:path];
            NSError *error;
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            if (!_player) {
                NSLog(@"Error: %@", [error localizedDescription]);
                return nil;
            } else {
                [_player prepareToPlay];
                [_player setVolume:0.0f];   //无声
                [_player setNumberOfLoops:0];   //循环
            }
        }
    }
    return _player;
}



- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(tik) userInfo:nil repeats:YES];
    }
    return _timer;
}


- (void)dealloc {
    [_timer invalidate];
}

@end
