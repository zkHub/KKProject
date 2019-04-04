//
//  KKAdjustedButton.h
//  KKProject
//
//  Created by zhangke on 2017/12/15.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark --inline 内联函数
/**
 根据insets重新计算Rect
 insets 各个参数 正的往外扩展，负的往内收缩
 即与 UIEdgeInsetsInsetRect 相反
 
 @param rect rect
 @param insets insets
 @return 新生成的Rect
 */
UIKIT_STATIC_INLINE CGRect UIEdgeInsetsResetRect(CGRect rect, UIEdgeInsets insets) {
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top  + insets.bottom);
    return rect;
}


@interface KKAdjustedButton : UIButton


/**
 设置button的点击区域 四个参数含义：正的向外扩展，负的向内收缩
 */
@property (nonatomic, assign) UIEdgeInsets touchEdge;

/**
 手动设置title与image在button的相对位置
 */
@property (nonatomic, assign) CGRect titleRect;
@property (nonatomic, assign) CGRect imageRect;

@end
