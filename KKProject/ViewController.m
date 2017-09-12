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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //拷贝出成员变量列表
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &ivarCount);
    for (int i = 0; i < ivarCount; i++) {
        //获取成员变量并打印
        Ivar ivar = ivars[i];
        NSLog(@"%s",ivar_getName(ivar));
    }
    free(ivars);
    //拷贝出属性列表
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self class],&propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        //获取属性并打印
        objc_property_t property = propertys[i];
        NSLog(@"%s",property_getName(property));
    }
    free(propertys);
    //拷贝出方法列表
    unsigned int methodsCount = 0;
    Method *methods = class_copyMethodList([self class], &methodsCount);
    for (NSUInteger i = 0; i < methodsCount; i++) {
        // 获取方法名称
        SEL methodSEL = method_getName(methods[i]);
        const char *methodName = sel_getName(methodSEL);
        NSLog(@"%s",methodName);
    }
    free(methods);
    
    NSString *string = @"翟让";

    [string transformToPinyin];
    
    NSString * result = [string SHA1String];
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
    
    KKPHTextView *textView = [[KKPHTextView alloc]initWithFrame:CGRectMake(20, 120, 100, 100)];
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
