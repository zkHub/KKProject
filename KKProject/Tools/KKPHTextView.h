//
//  XFBPHTextView.h
//  XFBusinessTable
//
//  Created by zhangke on 2017/6/16.
//  Copyright © 2017年 SinFun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

@interface KKPHTextView : UITextView


/**
 设置UITextView的placeHolder---支持iOS9.0以上
 */
@property (nonatomic,strong) NSString *placeholder;

/**
 为了方便修改一些属性（可以私有）
 */
@property (nonatomic,strong) UILabel *placeHolderLabel;

@end
