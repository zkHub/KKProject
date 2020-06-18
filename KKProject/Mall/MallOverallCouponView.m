//
//  MallOverallCouponView.m
//  KKProject
//
//  Created by zk on 2020/5/11.
//  Copyright © 2020 zhangke. All rights reserved.
//

#import "MallOverallCouponView.h"
#import "MallOverallCouponCell.h"


@interface MallOverallCouponView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *tipsView; /**< 提示框 */
@property (nonatomic, strong) UILabel *tipsLabel; /**< 提示语 */
@property (nonatomic, strong) UIButton *tipsBtn; /**< 使用推荐按钮 */
@property (nonatomic, strong) UITableView *tableView; /**< 选择优惠券列表 */
@property (nonatomic, copy) NSArray<MallCouponHeaderModel *> *dataArray; /**< 主数据源 */

@end

@implementation MallOverallCouponView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//MARK: - setDataSource

- (void)setDataArray:(NSArray<MallCouponHeaderModel *> *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
}


//MARK: - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MallCouponHeaderModel *headerModel = self.dataArray[section];
    if (headerModel.isNeedUnfold) {
        if (headerModel.isUnfold) {
            return 2;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MallCouponHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MallCouponHeaderView"];
    if (!headerView) {
        headerView = [[MallCouponHeaderView alloc] initWithReuseIdentifier:@"MallCouponHeaderView"];
    }
    MallCouponHeaderModel *headerModel = self.dataArray[section];
    [headerView reloadDataWithModel:headerModel];
    headerView.selectedAction = ^{
        if (headerModel.state == MallCouponStateTypeNoAvailable) {
            return;
        }
        if (self.headerSelected) {
            self.headerSelected(section);
        }
    };

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MallOverallCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MallOverallCouponCell class]) forIndexPath:indexPath];
    MallCouponHeaderModel *headerModel = self.dataArray[indexPath.section];
    if (indexPath.row == 1) {
        [cell hidenSeperatorLine];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellSelected) {
        self.cellSelected(indexPath.row);
    }
}

- (void)useRecommendation {
    self.tipsBtn.hidden = YES;
    self.tipsLabel.width = kScreenWidth-40;
    self.tipsLabel.text = @"已选中推荐优惠（优惠最多），使用优惠券2张,共抵扣￥150.00";
}


//MARK: - initView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.tipsView];
    [self.tipsView addSubview:self.tipsLabel];
    [self.tipsView addSubview:self.tipsBtn];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.tipsView.frame), kScreenWidth, self.height-32);
    [self addSubview:self.tableView];
}


- (UIView *)tipsView {
    if (!_tipsView) {
        _tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
        _tipsView.backgroundColor = [UIColor colorWithHexString:@"#FFF5E5"];
    }
    return _tipsView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40-88, 32)];
        _tipsLabel.text = @"已使用优惠券3张,共抵扣￥250.00";
        _tipsLabel.textColor = [UIColor colorWithHexString:@"#EB002A"];
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.numberOfLines = 2;
    }
    return _tipsLabel;
}

- (UIButton *)tipsBtn {
    if (!_tipsBtn) {
        _tipsBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _tipsBtn.frame = CGRectMake(kScreenWidth-88, 8, 72, 16);
        _tipsBtn.layer.borderColor = [UIColor colorWithHexString:@"#EE0020"].CGColor;
        _tipsBtn.layer.borderWidth = 1.0;
        _tipsBtn.layer.cornerRadius = 8;
        [_tipsBtn setTitle:@"使用推荐优惠" forState:(UIControlStateNormal)];
        [_tipsBtn setTitleColor:[UIColor colorWithHexString:@"#EE0020"] forState:(UIControlStateNormal)];
        _tipsBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_tipsBtn addTarget:self action:@selector(useRecommendation) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _tipsBtn;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MallOverallCouponCell class] forCellReuseIdentifier:NSStringFromClass([MallOverallCouponCell class])];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 72;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}




@end
