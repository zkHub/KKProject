//
//  MallCouponHeaderView.h
//  KKProject
//
//  Created by zk on 2020/5/11.
//  Copyright © 2020 zhangke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MallCouponStateType) {
    MallCouponStateTypeNoAvailable = 0, // 无可用
    MallCouponStateTypeAvailable, // 有可用的，没有选中
    MallCouponStateTypeSelected, // 有可用且选中
};


@interface MallCouponHeaderModel : NSObject
@property (nonatomic, copy) NSString *title; /**< 标题 */
@property (nonatomic, copy) NSString *subTitle; /**< 副标题 */
@property (nonatomic, copy) NSString *num; /**< 优惠金额*/
@property (nonatomic, assign) BOOL isNeedUnfold; /**< 是否需要展开 */
@property (nonatomic, assign) BOOL isUnfold; /**< 是否展开 */
@property (nonatomic, assign) MallCouponStateType state; /**< 是否无可用 */
@property (nonatomic, copy) NSArray *detailArray; /**< 优惠券数据 */

@end


@interface MallCouponHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) void(^selectedAction)(void); /**< 点击事件 */

- (void)reloadDataWithModel:(MallCouponHeaderModel *)model;

@end

NS_ASSUME_NONNULL_END
