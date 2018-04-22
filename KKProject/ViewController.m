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
#import "XFFollowButton.h"
#import "KKAdjustedButton.h"
#import <Masonry/Masonry.h>


#define urlString @"http://mp3.henduoge.com/s/2017-10-10/1507614801.mp3"


@interface ViewController ()


@end

@implementation ViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


- (void)pushAction {
    Class class = NSClassFromString(@"DispatchViewController");
    UIViewController *vc = [[class alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [UtilityHandler showIvarPropertyMethodForClass:[UIButton class]];
    
    KKAdjustedButton *button = [KKAdjustedButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(90, 90, 200, 200);
    [button setTitle:@"123" forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:@"mainpage_客户管理"] forState:(UIControlStateNormal)];
    button.titleRect = CGRectMake(50, 50, 50, 50);
    button.imageRect = CGRectMake(150, 150, 50, 50);
    [button addTarget:self action:@selector(pushAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
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

    
    NSString *string = @"翟让";

    [string transformToPinyin];
    
    NSString * result = [string SHA1String];
    NSLog(@"%@",result);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNull null] forKey:@"key"];
    [dict setSafeObject:[NSNull null] forKey:@"null"];
    
    
    
    KKPHTextView *textView = [[KKPHTextView alloc]initWithFrame:CGRectMake(20, 64, 100, 100)];
    textView.placeholder = @"sdfdsfsfwrwrwrhhtwfsdfsfs";
    textView.font = [UIFont systemFontOfSize:15];
    textView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:textView];

    
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        MASViewAttribute *masTop = self.view.mas_top;

        if (@available(iOS 11.0, *)) {
            masTop = self.view.mas_safeAreaLayoutGuideTop;
        }
        make.top.mas_equalTo(masTop).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
