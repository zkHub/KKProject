//
//  KKAdjustedButton.m
//  KKProject
//
//  Created by zhangke on 2017/12/15.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import "KKAdjustedButton.h"

@implementation KKAdjustedButton


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    if (!UIEdgeInsetsEqualToEdgeInsets(self.touchEdge, UIEdgeInsetsZero)) {
        bounds = UIEdgeInsetsResetRect(bounds, self.touchEdge);
    }
    return CGRectContainsPoint(bounds, point);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectIsEmpty(_titleRect) && !CGRectIsNull(_titleRect)) {
        self.titleLabel.frame = _titleRect;
    }
    if (!CGRectIsEmpty(_imageRect) && !CGRectIsNull(_imageRect)) {
        self.imageView.frame = _imageRect;
    }
}

@end
