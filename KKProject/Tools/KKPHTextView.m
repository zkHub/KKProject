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
        [self.placeHolderLabel sizeToFit];
        [self addSubview:self.placeHolderLabel];
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
            [self setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
        } else {
            //iOS9(不包括)以下还没有_placeholderLabel，需要手动添加并处理显示与隐藏
            [self refreshPlaceHoderFrame];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
//            [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
    }
    return self;
}

- (void)textDidChange:(NSNotification *)noti {
    if (self.hasText) {
        self.placeHolderLabel.hidden = YES;
    } else {
        self.placeHolderLabel.hidden = NO;
    }
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"text"] && object == self) {
//        if (self.text.length > 0) {
//            self.placeHolderLabel.hidden = YES;
//        } else {
//            self.placeHolderLabel.hidden = NO;
//        }
//    }else{
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self removeObserver:self forKeyPath:@"text" context:nil];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        
    } else {
        [self refreshPlaceHoderFrame];
    }
    
}


- (void)refreshPlaceHoderFrame {
    CGFloat offsetLeft = self.textContainerInset.left + self.textContainer.lineFragmentPadding;
    CGFloat offsetRight = self.textContainerInset.right + self.textContainer.lineFragmentPadding;
    CGFloat offsetTop = self.textContainerInset.top;
    CGFloat offsetBottom = self.textContainerInset.bottom;
    
    CGSize expectedSize = [self.placeHolderLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame)-offsetLeft-offsetRight, CGRectGetHeight(self.frame)-offsetTop-offsetBottom)];
    
    if (self.textAlignment == NSTextAlignmentLeft) {
        self.placeHolderLabel.frame = CGRectMake(offsetLeft, offsetTop, expectedSize.width, expectedSize.height);
        
    } else if (self.textAlignment == NSTextAlignmentRight) {
        self.placeHolderLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-expectedSize.width-offsetRight, offsetTop, expectedSize.width, expectedSize.height);
        
    } else {
        self.placeHolderLabel.frame = CGRectMake(offsetLeft, offsetTop, expectedSize.width, expectedSize.height);
        
    }
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
