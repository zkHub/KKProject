//
//  KKUtilityClass.h
//  WebForJS
//
//  Created by zhangke on 2017/7/7.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUtilityClass : NSObject

@end


@interface UtilityHandler : NSObject

+ (UtilityHandler*)shareHandler;


/**
 runtime打印类属性及方法

 @param className 类名
 */
+ (void)showIvarPropertyMethodForClass:(Class)className;


/**
 G 年代标志符（公元）
 y 年
 M 月
 d 日
 h 时 在上午或下午(1~12) 十二小时制
 H 时 在一天中(0~23) 二十四小时制
 m 分
 s 秒
 S 毫秒
 E~EEE 周几 EEEE 星期几
 a 上午 / 下午 标记符
 z 时区
 D 一年中的第几天
 A 今天的多少毫秒
 设置dateFormat属性 
 self.dateFormatter.dateFormat = @"G yyyy-MM-dd a HH:mm:ss.SSS EEEE z";
 */
@property (nonatomic, strong) NSDateFormatter *dateFormatter;



@end
