//
//  WXTermLabel.m
//  ParentsCommunity
//
//  Created by 刘波 on 2017/12/12.
//  Copyright © 2017年 XES. All rights reserved.
//

#import "WXTermLabel.h"

@implementation WXTermLabel

-(void)awakeFromNib{
    [super awakeFromNib];
    [self updateTermInfo:_termStr subjectInfo:_subjectStr];
}

-(void)updateTermInfo:(NSString *)termStr subjectInfo:(NSString *)subjectStr{
    
    [self removeAllSubviews];
    
    // 字体大小
    CGFloat fontSize = self.font.pointSize;
    
    for (int i = 0 ; i < termStr.length ; i ++ ) {
        
        NSString *aTerm = [termStr substringWithRange:NSMakeRange(i, 1)];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(i * (fontSize - 1 + 5) , _termSubjectTop > 0 ? _termSubjectTop : 1, fontSize - 1, fontSize - 1)];
        lbl.backgroundColor = _termBgColor ? _termBgColor : [UIColor colorWithHexString:@"0xf13232"];
        lbl.layer.cornerRadius = 2.;
        lbl.clipsToBounds = YES;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:fontSize - 6];
        lbl.text = aTerm;
        [self addSubview:lbl];
    }
    
    for (int j = 0; j < subjectStr.length ; j ++) {
        
        NSString *aSubject = [subjectStr substringWithRange:NSMakeRange(j, 1)];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake((termStr.length + j) * (fontSize - 1 + 5), _termSubjectTop > 0 ? _termSubjectTop : 1 , fontSize - 1, fontSize - 1)];
        lbl.layer.borderWidth = 1.;
        lbl.layer.borderColor = _subjectBorderColor ? _subjectBorderColor.CGColor : [UIColor colorWithHexString:@"0xf13232"].CGColor;
        lbl.layer.cornerRadius = 2.;
        lbl.clipsToBounds = YES;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor colorWithHexString:@"0xf13232"];
        lbl.font = [UIFont systemFontOfSize:fontSize - 6];
        lbl.text = aSubject;
        [self addSubview:lbl];
    }
    
    // 左侧空间
    CGFloat leftOffset = (termStr.length + subjectStr.length) * (fontSize - 1 + 5);
    if (!self.text) {
        self.text = @"";
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = leftOffset;
    if (self.customLineSpacing != 0) {
        paragraphStyle.lineSpacing = self.customLineSpacing;
    }
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attrStr;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}

/**
 "text": "预售",//文字
 "redirect": "",//点击交互
 "color": "#F07737",//颜色，若填充则为填充颜色，否则为文字颜色
 "filling": 1,//填充状态 1 填充 0 不填充
 "radius": "1px",//圆角
 "alpha": 100//透明度
 */
//支持显示多个字的标签
-(void)updateTitleLabelsWithArray:(NSArray *)itemsArray{
    
    [self removeAllSubviews];
    CGFloat leftOffset = 0;
    // 字体大小
    CGFloat fontSize = self.font.pointSize;
    for (int i = 0 ; i < itemsArray.count ; i ++ ) {
        NSDictionary *itemDic = itemsArray[i];
        NSString *title = [itemDic nonNullObjForKey:@"text"];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(leftOffset, _termSubjectTop > 0 ? _termSubjectTop : 1, fontSize*title.length - 1, fontSize - 1)];
        NSInteger isFilling = [[itemDic nonNullObjForKey:@"filling"] integerValue];
        UIColor *currentColor = [self colorFromHexString:[itemDic objectForKey:@"color"]];
        if (isFilling == 1) {
            lbl.backgroundColor = currentColor;
            lbl.textColor = [UIColor whiteColor];
        }else {
            lbl.layer.borderWidth = 1.;
            lbl.layer.borderColor = [UIColor colorWithHexString:@"0xf13232"].CGColor;
            lbl.textColor = currentColor;
        }
        lbl.layer.cornerRadius = 2.;
        lbl.clipsToBounds = YES;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:fontSize - 6];
        lbl.text = [itemDic nonNullObjForKey:@"text"];
        [self addSubview:lbl];

        leftOffset = leftOffset + lbl.frame.size.width + 5;
    }
    
    // 左侧空间
    if (!self.text) {
        self.text = @"";
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = leftOffset;
    if (self.customLineSpacing != 0) {
        paragraphStyle.lineSpacing = self.customLineSpacing;
    }
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attrStr;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}


-(void)new_updateTitleLabelsWithArray:(NSArray *)itemsArray itemFontSize:(CGFloat)itemFontSize{
    
    [self removeAllSubviews];
    CGFloat leftOffset = 0;
    // 字体大小
    CGFloat fontSize = self.font.pointSize;
    for (int i = 0 ; i < itemsArray.count ; i ++ ) {
        NSDictionary *itemDic = itemsArray[i];
        NSString *title = [itemDic nonNullObjForKey:@"text"];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(leftOffset, _termSubjectTop, (itemFontSize)*title.length+4, fontSize)];
        NSInteger isFilling = [[itemDic nonNullObjForKey:@"filling"] integerValue];
        UIColor *currentColor = [self colorFromHexString:[itemDic nonNullObjForKey:@"color"]];
        if (isFilling == 1) {
            lbl.backgroundColor = currentColor;
            lbl.textColor = [UIColor whiteColor];
        }else {
            lbl.layer.borderWidth = 1.;
//            lbl.layer.borderColor = [UIColor colorWithHexValue:0xf13232].CGColor;
            lbl.layer.borderColor = _subjectBorderColor ? _subjectBorderColor.CGColor : [UIColor colorWithHexString:@"0xf13232"].CGColor;
            lbl.textColor = currentColor;
        }
        lbl.layer.mask = [self getCornerMaskLayerWithBounds:lbl.bounds cornerSize:CGSizeMake(2, 2) cornerType:(UIRectCornerAllCorners)];
//        lbl.layer.cornerRadius = 2.;
//        lbl.clipsToBounds = YES;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:itemFontSize];
        lbl.text = [itemDic nonNullObjForKey:@"text"];
        [self addSubview:lbl];
        
        leftOffset = leftOffset + lbl.frame.size.width + 5;
    }
    
    // 左侧空间
    if (!self.text) {
        self.text = @"";
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = leftOffset;
    if (self.customLineSpacing != 0) {
        paragraphStyle.lineSpacing = self.customLineSpacing;
    }
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attrStr;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}

// "#ffffff" 到 UIColor 的转化
- (UIColor *)colorFromHexString:(NSString *)hexString {
    if ([hexString isEqualToString:@""]) {
        return nil;
    }
    
    if ([hexString characterAtIndex:0] != '#') {
        return nil;
    }
    
    unsigned rgbValue = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if ([hexString characterAtIndex:0] == '#') {
        [scanner setScanLocation:1];
    }
    
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)setCustomLineSpacingText:(NSString*)text
{
    if (self.subviews.count > 0) {
        [self removeAllSubviews];
    }
    if (!text) {
        text = @"";
    }
    if (self.customLineSpacing == 0) {
        self.text = text;
        return;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = self.customLineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attrStr;
}

// 切角方法
- (CAShapeLayer*)getCornerMaskLayerWithBounds:(CGRect)bounds cornerSize:(CGSize)cornerSize cornerType:(UIRectCorner)cornerType
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(cornerType) cornerRadii:cornerSize];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}

@end
