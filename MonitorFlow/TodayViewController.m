//
//  TodayViewController.m
//  MonitorFlow
//
//  Created by youplus on 2019/1/17.
//  Copyright © 2019 zhangke. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "MonitorFlow.h"

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MonitorFlow *monitro = [[MonitorFlow alloc] init];
    __weak __typeof(self) weakSelf = self;
    monitro.flowBlock = ^(NSString *up, NSString *down) {
        weakSelf.label.text = [NSString stringWithFormat:@"up:%@,down:%@",up,down];
    };
    [monitro startMonitor];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
