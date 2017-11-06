//
//  ViewController.m
//  KKProject
//
//  Created by zhangke on 2017/7/13.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TestViewController.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayer.h"
#import "XFFollowButton.h"


#define urlString @"http://mp3.henduoge.com/s/2017-10-10/1507614801.mp3"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) AVPlayer *player;
@property(nonatomic,strong)AudioPlayer *audioPlayer;

@end

@implementation ViewController

- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}


//观察者回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //注意这里查看的是self.player.status属性
//    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus staute = [change[@"new"] integerValue];
        switch (staute) {
            case AVPlayerStatusReadyToPlay:
                NSLog(@"加载成功,可以播放了");
                [self.player play];
                break;
            case AVPlayerStatusFailed:
                NSLog(@"加载失败");
                break;
            case AVPlayerStatusUnknown:
                NSLog(@"资源找不到");
                break;
                
                
            default:
                break;
        }
        
        NSLog(@"change:%@",change);
//    }
    
    
//    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//
//        NSArray * timeRanges = self.player.currentItem.loadedTimeRanges;
//        //本次缓冲的时间范围
//        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
//        //缓冲总长度
//        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
//        //音乐的总时间
//        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
//        //计算缓冲百分比例
//        NSTimeInterval scale = totalLoadTime/duration;
//
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [_audioPlayer setPrepareMusicUrl:urlString];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [UtilityHandler showIvarPropertyMethodForClass:[UIAlertAction class]];
    CGFloat height = 142 + SCREEN_WIDTH/5;
    UIView *followView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT -64-height, SCREEN_WIDTH, height)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, SCREEN_WIDTH, 24)];
    label.text = @"跟进";
    label.textAlignment = NSTextAlignmentCenter;
    [followView addSubview:label];
    for (int i = 0; i < 5; i++) {
        XFFollowButton *button = [[XFFollowButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/5, 300, SCREEN_WIDTH/5, SCREEN_WIDTH/5)];
        [followView addSubview:button];
    }

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(0, height-48, SCREEN_WIDTH, 48);
    [followView addSubview:cancelBtn];
    
    [self.view addSubview:followView];
//    if (self.player.currentItem) {
//        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
//    }

    //创建一个item资源
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
//    _audioPlayer = [AudioPlayer sharePlayer];

    
    NSString *str1 = nil;
    NSString *str = str1 ?: @"2";
    NSLog(@"%@",str);
    
    NSString *string = @"翟让";

    [string transformToPinyin];
    
    NSString * result = [string SHA1String];
    NSLog(@"%@",result);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNull null] forKey:@"key"];
    
    
    RAC(self.loginBtn,enabled) = [RACSignal combineLatest:@[self.nameText.rac_textSignal,self.passwordText.rac_textSignal] reduce:^(NSString *name,NSString *password){
        return @(name.length>0 && password.length>0);
    }];
    
    [[self.nameText.rac_textSignal
      filter:^BOOL(NSString * _Nullable value) {//筛选
        return value.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [[[self.nameText.rac_textSignal
       map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length);
    }]
        filter:^BOOL(id  _Nullable value) {
        return [value integerValue] > 3;
    }]
        subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     map:^id _Nullable(__kindof UIControl * _Nullable value) {//map返回的是一个信号，订阅打印的是信号
         return [self signInSignal];
     }]
     subscribeNext:^(id  _Nullable x) {
         NSLog(@"login:%@",x);
     }];
    
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
      flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
          return [self signInSignal];
      }]
     subscribeNext:^(id  _Nullable x) {
         NSLog(@"login:%@",x);
     }];
    
    [[[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        self.loginBtn.enabled = NO;
        NSLog(@"sendNext之前会执行这个block");
    }] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
        return [self signInSignal];
    }] subscribeNext:^(id  _Nullable x) {
        self.loginBtn.enabled = YES;
        NSLog(@"login:%@",x);
    }];
    
    KKPHTextView *textView = [[KKPHTextView alloc]initWithFrame:CGRectMake(20, 64, 100, 100)];
    textView.placeholder = @"sdfdsfsfwrwrwrhhtwfsdfsfs";
    textView.font = [UIFont systemFontOfSize:15];
    textView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:textView];

}


- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        
         [subscriber sendNext:@(YES)];
         [subscriber sendCompleted];
        return nil;
    }];
}


- (IBAction)loginClick:(UIButton *)sender {
    [self test];
}

- (void)test
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [subscriber sendNext:@"A"];
        });
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"B"];
        [subscriber sendNext:@"Another B"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(doA:withB:) withSignals:signalA, signalB, nil];
}

- (void)doA:(NSString *)A withB:(NSString *)B
{
    NSLog(@"A:%@ and B:%@", A, B);
    TestViewController *testvc = [[TestViewController alloc]init];
    [self.navigationController pushViewController:testvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
