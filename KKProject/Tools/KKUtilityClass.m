//
//  KKUtilityClass.m
//  WebForJS
//
//  Created by zhangke on 2017/7/7.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import "KKUtilityClass.h"
#import <objc/runtime.h>


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


+ (void)showIvarPropertyMethodForClass:(Class)className {
    //拷贝出成员变量列表
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(className, &ivarCount);
    NSLog(@"-----ivarCount-%u-----",ivarCount);
    for (int i = 0; i < ivarCount; i++) {
        //获取成员变量并打印
        Ivar ivar = ivars[i];
        NSLog(@"ivar-%s",ivar_getName(ivar));
    }
    free(ivars);
    //拷贝出属性列表
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList(className,&propertyCount);
    NSLog(@"-----propertyCount-%u-----",propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        //获取属性并打印
        objc_property_t property = propertys[i];
        NSLog(@"property-%s",property_getName(property));
    }
    free(propertys);
    //拷贝出方法列表
    unsigned int methodsCount = 0;
    Method *methods = class_copyMethodList(className, &methodsCount);
    NSLog(@"-----methodsCount-%u-----",methodsCount);
    for (NSUInteger i = 0; i < methodsCount; i++) {
        // 获取方法名称
        SEL methodSEL = method_getName(methods[i]);
        const char *methodName = sel_getName(methodSEL);
        NSLog(@"method-%s",methodName);
    }
    free(methods);
}



-(NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
    }
    return _dateFormatter;
}




@end
