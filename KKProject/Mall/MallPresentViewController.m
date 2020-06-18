//
//  MallPresentViewController.m
//  KKProject
//
//  Created by zk on 2020/5/9.
//  Copyright © 2020 zhangke. All rights reserved.
//

#import "MallPresentViewController.h"
#import "MallCouponUsingPopoverView.h"




@interface MallPresentViewController ()



@end

@implementation MallPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}





- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MallCouponUsingPopoverView popCouponUsingView];

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
