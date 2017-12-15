//
//  NSMutableDictionary+KKSetSafeObject.h
//  KKProject
//
//  Created by zhangke on 2017/12/12.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (KKSetSafeObject)

-(void)setSafeObject:(id)obj forKey:(id<NSCopying>)akey;

@end
