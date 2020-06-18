//
//  MallCouponUsingPopoverView.m
//  KKProject
//
//  Created by zk on 2020/5/13.
//  Copyright © 2020 zhangke. All rights reserved.
//

#import "MallCouponUsingPopoverView.h"
#import "UIScreen+WXUtility.h"
#import "MallOverallCouponView.h"


#define kIS_IPHONE_X_NOTCH_SCREEN_BOTTOM_HEIGHT      ([UIScreen currentScreenIsIphoneX] ? 34 : 0)

#define ContentViewHeigth (518+kIS_IPHONE_X_NOTCH_SCREEN_BOTTOM_HEIGHT)
#define BottomViewHeigth (56+kIS_IPHONE_X_NOTCH_SCREEN_BOTTOM_HEIGHT)


@interface MallCouponUsingPopoverView ()
@property (nonatomic, strong) UIView *maskView; /**< 背景遮罩 */
@property (nonatomic, strong) UIView *contentView; /**< 容器 */
@property (nonatomic, strong) UIView *topView; /**< 顶部view */
@property (nonatomic, strong) UIButton *leftBtn; /**< 左按钮 */
@property (nonatomic, strong) UIButton *backBtn; /**< 返回按钮 */
@property (nonatomic, strong) UILabel *titleLabel; /**< 标题 */
@property (nonatomic, strong) UIButton *rightBtn; /**< 右按钮 */
@property (nonatomic, strong) UIView *bottomView; /**< 底部view */
@property (nonatomic, strong) UIButton *confirmBtn; /**< 确定按钮 */

@end


#define CouponUsingTag 2005131709

@implementation MallCouponUsingPopoverView


+ (MallCouponUsingPopoverView *)popCouponUsingView {
    [MallCouponUsingPopoverView removeCouponUsingView];
    MallCouponUsingPopoverView *popoverView = [[MallCouponUsingPopoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    popoverView.tag = CouponUsingTag;
    [[UIApplication sharedApplication].keyWindow addSubview:popoverView];
    return popoverView;
}

+ (void)removeCouponUsingView {
    MallCouponUsingPopoverView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:CouponUsingTag];
    if (view) {
        [view removeFromSuperview];
        view = nil;
    }
}


- (void)showInstruction {
    
}

- (void)backAction {
    
}

- (void)confirmAction {
 
    [self closePopover];
}

- (void)closePopover {
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    NSLog(@"MallCouponUsingPopoverView--dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.maskView];
    @weakify(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        [self closePopover];
    }];
    [self.maskView addGestureRecognizer:tap];
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.topView];
    [self.topView addSubview:self.backBtn];
    self.backBtn.hidden = YES;
    [self.topView addSubview:self.leftBtn];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.rightBtn];
    
    MallOverallCouponView *discountView = [[MallOverallCouponView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth, CGRectGetMinY(self.bottomView.frame)-CGRectGetMaxY(self.topView.frame))];
    [self.contentView addSubview:discountView];
    
    NSArray *titleArray = @[@"商品券", @"订单券", @"现金券"];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSString *title in titleArray) {
        MallCouponHeaderModel *headerModel = [MallCouponHeaderModel new];
        headerModel.title = title;
        if ([title isEqualToString:@"商品券"]) {
            headerModel.isNeedUnfold = YES;
            headerModel.isUnfold = YES;
            headerModel.state = MallCouponStateTypeSelected;
        }
        [dataArray addObject:headerModel];
    }
    [discountView setDataArray:dataArray];
    @weakify(discountView);
    discountView.headerSelected = ^(NSInteger section) {
        if (section == 0) {
            @strongify(discountView);
            MallCouponHeaderModel *headerModel = dataArray[section];
            headerModel.isUnfold = !headerModel.isUnfold;
            [discountView setDataArray:dataArray];
        }
    };
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.confirmBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.top = kScreenHeight - ContentViewHeigth;
    }];
    
    
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, ContentViewHeigth)];
        _contentView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftBtn setTitle:@"使用说明" forState:(UIControlStateNormal)];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"#868D9A"] forState:(UIControlStateNormal)];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _leftBtn.frame = CGRectMake(15, 22, 50, 12);
        [_leftBtn addTarget:self action:@selector(showInstruction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _leftBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_backBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        _backBtn.frame = CGRectMake(16, 17, 9, 18);
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 16)];
        _titleLabel.center = CGPointMake(kScreenWidth/2, 28);
        _titleLabel.text = @"优惠券";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#212831"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightBtn setImage:[UIImage imageNamed:@"tanceng_close_icon"] forState:(UIControlStateNormal)];
        _rightBtn.frame = CGRectMake(kScreenWidth-37, 16, 20, 20);
        [_rightBtn addTarget:self action:@selector(closePopover) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 462, kScreenWidth, BottomViewHeigth)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [UIColor colorWithHexString:@"#F3F3F4"].CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0.5);
        _bottomView.layer.shadowOpacity = 1;
    }
    return _bottomView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _confirmBtn.frame = CGRectMake(0, 0, 220, 40);
        _confirmBtn.center = CGPointMake(kScreenWidth/2, 28);
        [_confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#EB002A"];
        _confirmBtn.layer.cornerRadius = 20;
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _confirmBtn;
}


@end
