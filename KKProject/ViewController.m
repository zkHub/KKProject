//
//  ViewController.m
//  KKProject
//
//  Created by zhangke on 2017/7/13.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <objc/runtime.h>
#import "KKAdjustedButton.h"
#import <Masonry/Masonry.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<UIDocumentPickerDelegate>


@end

@implementation ViewController



- (void)pushAction {
    
//    Class class = NSClassFromString(@"BLECentralViewController");
//    UIViewController *vc = [[class alloc]init];
    BLECentralViewController *ble = [[BLECentralViewController alloc] init];
    [self.navigationController pushViewController:ble animated:YES];

//    NSArray *documentArr = @[@"public.content",@"public.text",@"public.source-code",@"public.image",@"public.audiovisual-content",@"com.adobe.pdf",@"com.apple.keynote.key",@"com.microsoft.word.doc",@"com.microsoft.excel.xls",@"com.microsoft.powerpoint.ppt"];
//    UIDocumentPickerViewController *docPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentArr inMode:(UIDocumentPickerModeOpen)];
//    docPicker.delegate = self;
//    [self.navigationController presentViewController:docPicker animated:YES completion:nil];

}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [UtilityHandler showIvarPropertyMethodForClass:[AVAudioSession class]];

//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [UtilityHandler showIvarPropertyMethodForClass:[UIButton class]];
    [UtilityHandler showIvarPropertyMethodForClass:[UIAlertAction class]];

    KKAdjustedButton *button = [KKAdjustedButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(90, 90, 200, 200);
    [button setTitle:@"123" forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:@"icon_bull"] forState:(UIControlStateNormal)];
    button.titleRect = CGRectMake(50, 50, 50, 50);
    button.imageRect = CGRectMake(150, 150, 50, 50);
    [button addTarget:self action:@selector(pushAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];

    
    NSString *string = @"翟让";

    [string transformToPinyin];
    
    NSString * result = [string SHA1String];
    NSLog(@"%@",result);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNull null] forKey:@"key"];
    [dict setSafeObject:[NSNull null] forKey:@"null"];
    
    
    KKPHTextView *textView = [[KKPHTextView alloc]initWithFrame:CGRectMake(20, 64, 100, 100)];
    textView.placeholder = @"qwertyuiopasdfghjklzxcvbnm";
    textView.font = [UIFont systemFontOfSize:15];
    textView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        MASViewAttribute *masTop = self.view.mas_top;

        if (@available(iOS 11.0, *)) {
            masTop = self.view.mas_safeAreaLayoutGuideTop;
        }
        make.top.mas_equalTo(masTop).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    

    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
