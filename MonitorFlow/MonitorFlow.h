//
//  MonitorFlow.h
//  KKProject
//
//  Created by youplus on 2019/1/17.
//  Copyright © 2019 zhangke. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^FlowCallBack)(NSString *up, NSString *down);

@interface MonitorData : NSObject
@property (assign, nonatomic) float wwanSend;
@property (assign, nonatomic) float wwanReceived;
@property (assign, nonatomic) float wifiSend;
@property (assign, nonatomic) float wifiReceived;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MonitorFlow : NSObject

@property (nonatomic, copy) FlowCallBack flowBlock;

//开始检测
- (void)startMonitor;

//停止检测
- (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
