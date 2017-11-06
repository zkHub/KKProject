//
//  XFFollowButton.m
//  KKProject
//
//  Created by 张柯 on 2017/10/16.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import "XFFollowButton.h"
#import "PrefixHeader.h"


@implementation XFFollowButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    CGFloat width = frame.size.width;
//    CGFloat height = frame.size.height;
    if (self) {
        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(15.0/75*width, 0, 45.0/75*width, 45.0/75*width)];
        [self addSubview:_headerView];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame)+10.0/75*width, width, 20.0/75*width)];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"跟进";
        _label.font = [UIFont systemFontOfSize:14];
        [self addSubview:_label];
    }
    return self;
}

@end
