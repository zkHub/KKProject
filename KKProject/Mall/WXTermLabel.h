//
//  WXTermLabel.h
//  ParentsCommunity
//
//  Created by 刘波 on 2017/12/12.
//  Copyright © 2017年 XES. All rights reserved.
//  自动为label添加学期、学科属性，属性中不要包含emoji表情

#import <UIKit/UIKit.h>

@interface WXTermLabel : UILabel

/** 学期属性 */
@property (nonatomic , copy) IBInspectable NSString *termStr;
/** 学期背景色 */
@property (nonatomic , strong) UIColor *termBgColor;

/** 学科属性 */
@property (nonatomic , copy) IBInspectable NSString *subjectStr;
/** 学科边框色 */
@property (nonatomic , strong) UIColor *subjectBorderColor;

/** 学期、学科 上边距高度 */
@property (nonatomic , assign) CGFloat termSubjectTop;

// 行间距
@property (nonatomic, assign) CGFloat customLineSpacing;

/** 更新 学期 学科 字段 */
-(void)updateTermInfo:(NSString *)termStr subjectInfo:(NSString *)subjectStr;
/** 更新 预售 学期 学科 字段 ，首页和课程列表页使用*/
-(void)updateTitleLabelsWithArray:(NSArray *)itemsArray;

- (void)setCustomLineSpacingText:(NSString*)text;

-(void)new_updateTitleLabelsWithArray:(NSArray *)itemsArray itemFontSize:(CGFloat)itemFontSize;

@end
