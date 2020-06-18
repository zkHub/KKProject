//
//  UIScreen+WXUtility.h
//  CommonFramework
//
//  Created by leev on 2017/10/26.
//  Copyright © 2017年 XES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (WXUtility)

+ (CGFloat)currentScreenWidth;

+ (CGFloat)currentScreenHeight;

/**
 * @desc 由于ui涉及会在一些情况下对大于iPhone5的屏幕和小于iPhone5的屏幕设计两套ui,所以该方法用于判断设备是否是iPhone5及以下屏幕
 */
+ (BOOL)currentScreenIsNarrow;

/**
 * @desc 判断当前屏幕是否是iPhoneX(根据屏幕高度)
 */
+ (BOOL)currentScreenIsIphoneX;

@end
