//
//  ShadowViewController.m
//  KKProject
//
//  Created by 张柯 on 2020/6/8.
//  Copyright © 2020 zhangke. All rights reserved.
//

#import "ShadowViewController.h"
#import <YYKit/YYKit.h>

@interface ShadowViewController ()

@end

@implementation ShadowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 1)];
//    view.backgroundColor = [UIColor whiteColor];
//    view.layer.shadowColor = [UIColor blackColor].CGColor;
//    view.layer.shadowOpacity = 0.3;
//    view.layer.shadowOffset = CGSizeMake(0, 12);
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:150 startAngle:M_PI/5*2 endAngle:M_PI/5*3 clockwise:YES];
//    view.layer.shadowPath = path.CGPath;
////    view.layer.shadowRadius = 6;
//    [self.view addSubview:view];
    UIImage *image = [self getCenterGradientWithRect:self.view.bounds startColor:[UIColor colorWithHexString:@"#3B3C4C"] endColor:[UIColor colorWithHexString:@"#1F1F2B"]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imgView];

    
    
}


- (UIImage *)getCenterGradientWithRect:(CGRect)rect
                            startColor:(UIColor *)startColor
                              endColor:(UIColor *)endColor {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    //绘制渐变
    [self drawRadialGradient:gc path:path.CGPath startColor:startColor.CGColor endColor:endColor.CGColor];
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)drawRadialGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = hypot(pathRect.size.width, pathRect.size.height)/2; // 半径
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
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
