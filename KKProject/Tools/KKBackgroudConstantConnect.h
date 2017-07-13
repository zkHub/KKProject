//
//  BackgroudConstantConnect.h
//  WebForJS
//
//  Created by zhangke on 2017/7/6.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKBackgroudConstantConnect : NSObject

+(instancetype)shareInstance;

- (void)openBackgroundModel;
- (void)closeBackgroundModel;


@end
