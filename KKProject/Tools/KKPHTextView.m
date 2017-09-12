//
//  XFBPHTextView.m
//  XFBusinessTable
//
//  Created by zhangke on 2017/6/16.
//  Copyright © 2017年 SinFun. All rights reserved.
//

#import "KKPHTextView.h"

@implementation KKPHTextView


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.placeHolderLabel = [[UILabel alloc] init];
        self.placeHolderLabel.text = @"";
        self.placeHolderLabel.numberOfLines = 0;
        self.placeHolderLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.placeHolderLabel];
        if (DeviceVersion >= 9.0) {
            [self setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
        }
        self.font = [UIFont systemFontOfSize:17];

    }
    return self;
}


/**
 同步placeholder的字体

 @param font 字体
 */
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeHolderLabel.font = font;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeHolderLabel.font = self.font;
    self.placeHolderLabel.text = placeholder;
    
}


/**
 解决Capture View Hierarchy不显示的问题
 */
- (void)_firstBaselineOffsetFromTop {
    
}
- (void)_baselineOffsetFromBottom {
    
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
