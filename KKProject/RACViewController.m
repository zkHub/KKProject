//
//  RACViewController.m
//  KKProject
//
//  Created by 张柯 on 2018/4/22.
//  Copyright © 2018年 zhangke. All rights reserved.
//

#import "RACViewController.h"
#import "ReactiveObjc.h"

@interface RACViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
