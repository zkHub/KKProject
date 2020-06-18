//
//  DanmakuViewController.m
//  KKProject
//
//  Created by 张柯 on 2020/6/17.
//  Copyright © 2020 zhangke. All rights reserved.
//

#import "DanmakuViewController.h"
#import <HJDanmaku.h>
#import "DanmakuCell.h"
#import "DanmakuModel.h"


@interface DanmakuViewController ()<HJDanmakuViewDelegate, HJDanmakuViewDateSource>

@property (nonatomic, strong) HJDanmakuView *danmakuView; /**<  */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DanmakuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.danmakuView];
    [self.danmakuView prepareDanmakus:nil];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.danmakuView.isPrepared) {
        [self.danmakuView prepareDanmakus:nil];
    } else {
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(randomSendNewDanmaku) userInfo:nil repeats:YES];
        }
        [self.danmakuView play];
    }
}

- (void)randomSendNewDanmaku {
//    HJDanmakuType type = arc4random() % 3;
    DanmakuModel *danmakuModel = [[DanmakuModel alloc] initWithType:HJDanmakuTypeLR];
    danmakuModel.text = [NSString stringWithFormat:@"%ld",arc4random()%34234242342];
    [self.danmakuView sendDanmaku:danmakuModel forceRender:YES];
}

- (HJDanmakuView *)danmakuView {
    if (!_danmakuView) {
        HJDanmakuConfiguration *config = [[HJDanmakuConfiguration alloc] initWithDanmakuMode:(HJDanmakuModeLive)];
        config.numberOfLines = 2;
        _danmakuView = [[HJDanmakuView alloc] initWithFrame:self.view.bounds configuration:config];
        _danmakuView.delegate = self;
        _danmakuView.dataSource = self;
        [_danmakuView registerClass:[DanmakuCell class] forCellReuseIdentifier:NSStringFromClass([DanmakuCell class])];
    }
    return _danmakuView;
}


- (CGFloat)danmakuView:(HJDanmakuView *)danmakuView widthForDanmaku:(HJDanmakuModel *)danmaku {
    return 100;
}

- (HJDanmakuCell *)danmakuView:(HJDanmakuView *)danmakuView cellForDanmaku:(HJDanmakuModel *)danmaku {
    DanmakuCell *cell = [danmakuView dequeueReusableCellWithIdentifier:NSStringFromClass([DanmakuCell class])];
    DanmakuModel *model = (DanmakuModel *)danmaku;
    cell.textLabel.text = model.text;
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
