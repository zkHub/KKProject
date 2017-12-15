//
//  KKAdjustedButton.h
//  KKProject
//
//  Created by zhangke on 2017/12/15.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKAdjustedButton : UIButton

/**
 手动设置title与image在button的相对位置
 */
@property (nonatomic, assign) CGRect titleRect;
@property (nonatomic, assign) CGRect imageRect;

@end
