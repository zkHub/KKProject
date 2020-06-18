//
//  MallOverallCouponCell.m
//  KKProject
//
//  Created by zk on 2020/5/11.
//  Copyright © 2020 zhangke. All rights reserved.
//

#import "MallOverallCouponCell.h"
#import "WXTermLabel.h"


@interface MallOverallCouponCell ()

@property (nonatomic, strong) WXTermLabel *titleLabel; /**< 标题 */
@property (nonatomic, strong) UILabel *numLabel; /**< 优惠金额 */
@property (nonatomic, strong) UILabel *usableLabel; /**< 有无可用 */
@property (nonatomic, strong) UIImageView *arrowImgView; /**< 箭头 */
@property (nonatomic, strong) UIView *lineView; /**< 分割线 */

@end


@implementation MallOverallCouponCell


- (void)hidenSeperatorLine {
    self.lineView.hidden = YES;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableArray *showLabelArr = [NSMutableArray array];
    self.titleLabel.customLineSpacing = 8;
    NSDictionary *dic = @{
        @"text":@"语文",
        @"color":@"#EB002A",
        @"filling":@(0)
    };
    [showLabelArr addObject:dic];
    self.titleLabel.termSubjectTop = 1;
    self.titleLabel.text = @"【暑】六年级升初一数学直播勤学班（全国人教）";
    [self.titleLabel new_updateTitleLabelsWithArray:showLabelArr itemFontSize:12];
    [self.contentView addSubview:self.titleLabel];
    self.numLabel.text = @"- ¥100";
    [self.contentView addSubview:self.numLabel];
    self.usableLabel.hidden = YES;
    [self.contentView addSubview:self.usableLabel];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).inset(15);
        make.left.mas_equalTo(self.contentView).inset(32);
        make.right.mas_equalTo(self.numLabel.mas_left).offset(-5);
        make.bottom.mas_equalTo(self.contentView).inset(15);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).inset(15);
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-2);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(14);
    }];
    [self.usableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).inset(16);
        make.right.mas_equalTo(self.arrowImgView.mas_left).mas_offset(-2);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        make.height.mas_equalTo(12);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).inset(14);
        make.right.mas_equalTo(self.contentView).inset(20);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).inset(32);
        make.right.mas_equalTo(self.contentView).inset(20);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
}

- (WXTermLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[WXTermLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#212831"];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.textColor = [UIColor colorWithHexString:@"#EB002A"];
        _numLabel.font = [UIFont systemFontOfSize:14];
    }
    return _numLabel;
}

- (UILabel *)usableLabel {
    if (!_usableLabel) {
        _usableLabel = [[UILabel alloc] init];
        _usableLabel.textAlignment = NSTextAlignmentRight;
        _usableLabel.textColor = [UIColor colorWithHexString:@"#868D9A"];
        _usableLabel.font = [UIFont systemFontOfSize:12];
    }
    return _usableLabel;
}


- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"discount_arrow_right_icon"];
    }
    return _arrowImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F4"];
    }
    return _lineView;
}


@end
