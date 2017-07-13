//
//  PrefixHeader.h
//  WebForJS
//
//  Created by zhangke on 2017/7/4.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

#import "NSString+KKHandle.h"

//shceme为realese时define，而debug时ndef
#ifndef __OPTIMIZE__
#warning NSLogs will be shown
#else
#define NSLog(...) {}
#endif

#define SFLog(fmt, ...) NSLog((@"%s, " "line:%d, \n" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__); //带函数名和行数
#define SLLog(fmt, ...) NSLog((@"line:%d, \n" fmt), __LINE__, ##__VA_ARGS__);  //带行数
#define SCLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__); //不带函数名和行数



//屏幕宽度
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//屏幕高度
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

//RGB色值
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//16进制颜色
#define HEXCOLOR(hexString) [UIColor colorWithRed:((float)((hexString & 0xFF0000) >> 16))/255.0 green:((float)((hexString & 0xFF00) >> 8))/255.0 blue:((float)(hexString & 0xFF))/255.0 alpha:1.0]



#endif /* PrefixHeader_h */
