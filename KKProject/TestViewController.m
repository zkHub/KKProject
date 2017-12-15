//
//  TestViewController.m
//  KKProject
//
//  Created by zhangke on 2017/8/4.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(10, 90, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(pushAction) forControlEvents:(UIControlEventTouchUpInside)];

    [self.view addSubview:button];
}
- (void)pushAction {
    TestViewController *vc = [[TestViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
