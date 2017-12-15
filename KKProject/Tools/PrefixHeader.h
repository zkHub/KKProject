//
//  PrefixHeader.h
//  WebForJS
//
//  Created by zhangke on 2017/7/4.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

#import "NSString+KKHandler.h"
#import "KKUtilityClass.h"
#import "UIColor+KKHandler.h"
#import "KKPHTextView.h"
#import "NSMutableDictionary+KKSetSafeObject.h"
#import "KKNavigationController.h"


//shceme为realese时define，而debug时ndef
#ifndef __OPTIMIZE__
#warning NSLogs will be shown
#else
#define NSLog(...) {}
#endif

#define SFLog(fmt, ...) NSLog((@"%s, " "line:%d, \n" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__); //带函数名和行数
#define SLLog(fmt, ...) NSLog((@"line:%d, \n" fmt), __LINE__, ##__VA_ARGS__);  //带行数
#define SCLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__); //不带函数名和行数

#define DeviceVersion ([UIDevice currentDevice].systemVersion.floatValue)
#define iOS(version) (([[[UIDevice currentDevice] systemVersion] intValue] >= version)?1:0)

//屏幕宽度
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//屏幕高度
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

//切图以375为宽的缩放倍数
#define WIDTH_SCALE SCREEN_WIDTH/375
#define HEIGHT_SCALE SCREEN_HEIGHT/567



#pragma mark -- 颜色初始化
/** 十六进制颜色 */
#define UIColorMake(hex) UIColorAlphaMake(hex, 1)
/** 十六进制颜色(alpha) */
#define UIColorAlphaMake(hex, alpha) UIColorRGBAMake((hex & 0xFF0000) >> 16, (hex & 0xFF00) >> 8, hex & 0xFF, alpha)
/** RGB颜色 */
#define UIColorRGBMake(r, g, b) UIColorRGBAMake(r, g, b, 1)
/** RGB颜色(alpha) */
#define UIColorRGBAMake(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1.0]

#pragma mark -- 字号初始化
#define UIFontMake(fontSize) [UIFont systemFontOfSize:fontSize]

#define UIFontWeightMake(fontSize, w) (iOS(9) ? [UIFont systemFontOfSize:fontSize weight:w] : UIFontMake(fontSize))

#define UIFontWeightRegularMake(fontSize) UIFontWeightMake(fontSize, UIFontWeightRegular)
#define UIFontWeightUltraLightMake(fontSize) UIFontWeightMake(fontSize, UIFontWeightUltraLight)
#define UIFontWeightThinMake(fontSize) UIFontWeightMake(fontSize, UIFontWeightThin)
#define UIFontWeightLightMake(fontSize) UIFontWeightMake(fontSize, UIFontWeightLight)
#define UIFontWeightMediumMake(fontSize) UIFontWeightMake(fontSize, UIFontWeightMedium)
#define UIFontWeightSemiboldMake(fontSize) UIFontWeightMake(fontSize, UIFontWeightSemibold)

#pragma mark -- 图片初始化
#define UIImageMake(img) [UIImage imageNamed:img]

#pragma mark -- 一像素
#define PixelOne 1 / [[UIScreen mainScreen] scale]



#endif /* PrefixHeader_h */
