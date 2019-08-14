//
//  NSObject+Run.m
//  KKProject
//
//  Created by 张柯 on 2019/8/14.
//  Copyright © 2019 zhangke. All rights reserved.
//

#import "NSObject+Run.h"

@implementation NSObject (Run)

//存放 NSObject 方法列表中
- (void)run {
    NSLog(@"NSObject-run");
}

//存放 metaClass 方法列表中，若未实现则因为 isa 指向 NSObject，就会去 NSObject 方法列表中查找 SEL

//+ (void)run {
//    NSLog(@"NSObject+run");
//}

@end
