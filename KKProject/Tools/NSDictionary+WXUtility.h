//
//  NSDictionary+WXUtility.h
//  CommonFramework
//
//  Created by leev on 2017/10/26.
//  Copyright © 2017年 XES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WXUtility)

/** 提供一个NSNumber类型的Value */
-(NSNumber *)numberForKey:(id)aKey;

/** 提供一个NSString类型的Value */
-(NSString *)stringForKey:(id)aKey;

/** 提供一个NSArray类型的Value */
-(NSArray *)arrayForKey:(id)aKey;

/** 提供一个NSDictionary类型的Value */
-(NSDictionary *)dictionaryForKey:(id)aKey;

/**
 *  功能：根据Key获取Value，提供非NULL的Value值，
 *  akey：可以为nil、NULL或其他值
 *  return：返回一个非NULL的值
 */
-(id)nonNullObjForKey:(id)aKey;

/** @brief 字典转为日志字符串 */
-(NSString *)logStrDescription;

@end
