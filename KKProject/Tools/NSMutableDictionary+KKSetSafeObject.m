//
//  NSMutableDictionary+KKSetSafeObject.m
//  KKProject
//
//  Created by zhangke on 2017/12/12.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import "NSMutableDictionary+KKSetSafeObject.h"

@implementation NSMutableDictionary (KKSetSafeObject)

-(void)setSafeObject:(id)obj forKey:(id<NSCopying>)akey{
    
    if (nil==obj || [obj isKindOfClass:[NSNull class]]) {
        [self setObject:@"" forKey:akey];
    }else{
        [self setObject:obj forKey:akey];
    }
    
}


@end
