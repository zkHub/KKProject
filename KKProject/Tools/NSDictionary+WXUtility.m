//
//  NSDictionary+WXUtility.m
//  CommonFramework
//
//  Created by leev on 2017/10/26.
//  Copyright © 2017年 XES. All rights reserved.
//

#import "NSDictionary+WXUtility.h"

@implementation NSDictionary (WXUtility)

/** 提供一个NSNumber类型的Value */
-(NSNumber *)numberForKey:(id)aKey{
    id aValue = [self nonNullObjForKey:aKey];
    
//    NSAssert(aValue == nil || [aValue isKindOfClass:[NSNumber class]] , @"value非NSNumber类型");
    
    if ([aValue isKindOfClass:[NSNumber class]]) {
        // 不做处理
    }else if ([aValue isKindOfClass:[NSString class]] || [aValue isKindOfClass:[NSMutableString class]]) {
        if ([((NSString *)aValue) stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length > 0) {
            aValue = nil;
        }else{
            aValue = [NSNumber numberWithDouble:[aValue doubleValue]];
        }
    }else{
        aValue = nil;
    }
    
    return aValue;
}

/** 提供一个NSString类型的Value */
-(NSString *)stringForKey:(id)aKey{
    id aValue = [self nonNullObjForKey:aKey];
//    NSAssert(aValue == nil || [aValue isKindOfClass:[NSString class]] || [aValue isKindOfClass:[NSMutableString class]] , @"value非NSString类型");
    
    if ([aValue isKindOfClass:[NSString class]] || [aValue isKindOfClass:[NSMutableString class]]) {
        // 不做处理
    }else if ([aValue isKindOfClass:[NSNumber class]]) {
        aValue = [NSString stringWithFormat:@"%@" , aValue];
    }else{
        aValue = nil;
    }
    return aValue;
}

/** 提供一个NSArray类型的Value */
-(NSArray *)arrayForKey:(id)aKey{
    id aValue = [self nonNullObjForKey:aKey];
//    NSAssert(aValue == nil || [aValue isKindOfClass:[NSArray class]] || [aValue isKindOfClass:[NSMutableArray class]] , @"value非NSArray类型");
    
    if ([aValue isKindOfClass:[NSArray class]] || [aValue isKindOfClass:[NSMutableArray class]]) {
        // 不做处理
    }else{
        aValue = nil;
    }
    return aValue;
}

/** 提供一个NSDictionary类型的Value */
-(NSDictionary *)dictionaryForKey:(id)aKey{
    id aValue = [self nonNullObjForKey:aKey];
//    NSAssert(aValue == nil || [aValue isKindOfClass:[NSDictionary class]] || [aValue isKindOfClass:[NSMutableDictionary class]] , @"value非NSDictionary类型");
    
    if ([aValue isKindOfClass:[NSDictionary class]] || [aValue isKindOfClass:[NSMutableDictionary class]]) {
        // 不做处理
    }else{
        aValue = nil;
    }
    return aValue;
}

/**
 *  功能：根据Key获取Value，提供非NULL的Value值，
 *  akey：可以为nil、NULL或其他值
 *  return：返回一个非NULL的值
 */
-(id)nonNullObjForKey:(id)aKey{
    
//    NSAssert( aKey != nil && aKey != [NSNull null] , @"key为nil或null" );
    
    if (aKey == nil || aKey == [NSNull null]) {
        return nil;
    }
    
    id aValue = [self objectForKey:aKey];
    if (aValue == [NSNull null]) {
        return nil;
    }else{
        return aValue;
    }
    
}

-(NSString *)logStrDescription{
    NSMutableString *logStr = [NSMutableString string];
    
    for (NSString *key in self.allKeys)
    {
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@ ", key, [self nonNullObjForKey:key]];
        [logStr appendString:keyValue];
    }
    
    return logStr;
}
@end
