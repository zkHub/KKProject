//
//  DragViewController.m
//  KKProject
//
//  Created by 张柯 on 2020/6/16.
//  Copyright © 2020 zhangke. All rights reserved.
//

#import "DragViewController.h"

@interface DragViewController ()
@property (nonatomic, assign) CGFloat pan_y; /**< 拖动手势的起始y */
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) UIView *bgView; /**<  */
@property (nonatomic, strong) UIView *dragView; /**<  */

@end

@implementation DragViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, self.view.bounds.size.height-300)];
    self.bgView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.bgView];
    self.dragView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.dragView.center = CGPointMake(CGRectGetMidX(self.bgView.frame), 15);
    self.dragView.backgroundColor = [UIColor redColor];
    [self.bgView addSubview:self.dragView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.dragView addGestureRecognizer:pan];
}

- (void)panGesture:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.pan_y = point.y;
            self.frame = self.bgView.frame;

        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat change_y = point.y - self.pan_y;

            CGRect frame = self.frame;
            CGFloat tempY = frame.origin.y;
            if (frame.origin.y+change_y > self.view.bounds.size.height-30) {
                frame.origin.y = self.view.bounds.size.height-30;
            } else if (frame.origin.y+change_y < 300) {
                frame.origin.y = 300;
            } else {
                frame.origin.y += change_y;
            }
            frame.size.height -= (frame.origin.y-tempY);
            self.bgView.frame = frame;
        }
            break;
        default:
        {
            self.pan_y = 0;
        }
            break;
    }
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
