//
//  MallOverallCouponView.h
//  KKProject
//
//  Created by zk on 2020/5/11.
//  Copyright © 2020 zhangke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MallCouponHeaderView.h"


NS_ASSUME_NONNULL_BEGIN

@interface MallOverallCouponView : UIView

@property (nonatomic, copy) void(^headerSelected)(NSInteger section); /**< header点击事件 */
@property (nonatomic, copy) void(^cellSelected)(NSInteger row); /**< cell点击事件 */

- (void)setDataArray:(NSArray<MallCouponHeaderModel *> *)dataArray;

@end

NS_ASSUME_NONNULL_END
