//
//  LoadImageViewController.m
//  KKProject
//
//  Created by 张柯 on 2018/4/19.
//  Copyright © 2018年 zhangke. All rights reserved.
//

#import "LoadImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface LoadImageViewController ()

@end

@implementation LoadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView.image = [UIImage imageNamed:@"mainpage_客户管理"];//30  会cache到 dirty 虚拟内存，系统不能操作
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mainpage_客户管理"];
    imageView2.image = [[UIImage alloc]initWithContentsOfFile:path];//3  这是只是加载到 clean 内存中，系统可以操作
    
    for (int i = 0; i < 10; i++) {
        imageView.image = [UIImage imageNamed:@"mainpage_客户管理"];//2
    }
    for (int i = 0; i < 10; i++) {
        imageView2.image = [[UIImage alloc]initWithContentsOfFile:path];//19
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/276769-02532b725b8bcc9f.jpg"] placeholderImage:[UIImage imageNamed:@"mainpage_客户管理"]];
    
    [self.view addSubview:imageView];
    [self.view addSubview:imageView2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
