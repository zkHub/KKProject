//
//  KKUtilityClass.m
//  WebForJS
//
//  Created by zhangke on 2017/7/7.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import "KKUtilityClass.h"

@implementation KKUtilityClass

@end


@implementation UtilityHandler

+ (UtilityHandler *)shareHandler {
    static UtilityHandler *_shareHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareHandler = [[UtilityHandler alloc]init];
    });
    return _shareHandler;
}

-(NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
    }
    return _dateFormatter;
}




@end
