//
//  MallCouponHeaderView.m
//  KKProject
//
//  Created by zk on 2020/5/11.
//  Copyright © 2020 zhangke. All rights reserved.
//

#import "MallCouponHeaderView.h"

@implementation MallCouponHeaderModel

- (NSString *)num {
    if (!_num.isNotBlank) {
        _num = @"0";
    }
    return _num;
}

@end


@interface MallCouponHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel; /**< 标题 */
@property (nonatomic, strong) UILabel *numLabel; /**< 优惠金额 */
@property (nonatomic, strong) UILabel *usableLabel; /**< 有无可用 */
@property (nonatomic, strong) UIImageView *arrowImgView; /**< 箭头 */

@end

@implementation MallCouponHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)reloadDataWithModel:(MallCouponHeaderModel *)model {
    NSString *titleString = model.title;
    if (model.subTitle.isNotBlank) {
        titleString = [NSString stringWithFormat:@"%@（已选%@张）",model.title,model.subTitle];
    }
    self.titleLabel.text = titleString;
    if (model.state == MallCouponStateTypeNoAvailable) {
        self.usableLabel.text = @"无可用";
        self.usableLabel.textColor = [UIColor colorWithHexString:@"#868D9A"];
        self.usableLabel.hidden = NO;
        self.numLabel.hidden = YES;
    } else if (model.state == MallCouponStateTypeAvailable) {
        self.usableLabel.text = [NSString stringWithFormat:@"%d张可用",1];
        self.usableLabel.textColor = [UIColor colorWithHexString:@"#1F2831"];
        self.usableLabel.hidden = NO;
        self.numLabel.hidden = YES;
    } else {
        self.numLabel.text = [NSString stringWithFormat:@"- ¥%@",model.num];
        self.numLabel.hidden = NO;
        self.usableLabel.hidden = YES;
    }
    
    if (model.isNeedUnfold) {
        self.arrowImgView.image = [UIImage imageNamed:@"discount_arrow_up_icon"];
    } else {
        self.arrowImgView.image = [UIImage imageNamed:@"discount_arrow_right_icon"];
    }
}


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.usableLabel];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.arrowImgView];
    
    @weakify(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        if (self.selectedAction) {
            self.selectedAction();
        }
    }];
    [self addGestureRecognizer:tap];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 150, 14)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#212831"];
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 15, kScreenWidth-170-38, 14)];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.textColor = [UIColor colorWithHexString:@"#EB002A"];
        _numLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _numLabel;
}

- (UILabel *)usableLabel {
    if (!_usableLabel) {
        _usableLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 16, kScreenWidth-170-38, 12)];
        _usableLabel.textAlignment = NSTextAlignmentRight;
        _usableLabel.textColor = [UIColor colorWithHexString:@"#868D9A"];
        _usableLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    return _usableLabel;
}


- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-36, 14, 16, 16)];
    }
    return _arrowImgView;
}

@end
