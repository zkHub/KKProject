//
//  UIScreen+WXUtility.m
//  CommonFramework
//
//  Created by leev on 2017/10/26.
//  Copyright © 2017年 XES. All rights reserved.
//

#import "UIScreen+WXUtility.h"

@implementation UIScreen (WXUtility)

+ (CGFloat)currentScreenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)currentScreenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (BOOL)currentScreenIsNarrow
{
    CGFloat screenWidth = ceil([self currentScreenWidth]);
    if (screenWidth <= 320)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)currentScreenIsIphoneX
{
    CGFloat screenWidth = ceil([self currentScreenWidth]);
    CGFloat screenHeight = ceil([self currentScreenHeight]);
    if ((screenWidth == 375 && screenHeight == 812) || (screenWidth == 414 && screenHeight == 896))
    {
        return YES;
    }
    // 横屏
    if ((screenHeight == 375 && screenWidth == 812) || (screenHeight == 414 && screenWidth == 896)) {
        return YES;
    }
    
    if (@available(iOS 11.0, *)) {
        if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0 && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            return YES;
        }
    }
    return NO;
}

@end
