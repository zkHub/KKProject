//
//  KKAdjustedButton.m
//  KKProject
//
//  Created by zhangke on 2017/12/15.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import "KKAdjustedButton.h"

@implementation KKAdjustedButton


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return _titleRect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return _imageRect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
