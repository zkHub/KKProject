//
//  PropertyViewController.m
//  KKProject
//
//  Created by 张柯 on 2018/5/14.
//  Copyright © 2018年 zhangke. All rights reserved.
//

#import "PropertyViewController.h"

@interface PropertyViewController ()

@property (copy, nonatomic) NSMutableString *aCopyMStr;
@property (strong, nonatomic) NSMutableString *strongMStr;
@property (weak,nonatomic) NSMutableString *weakMStr;
@property (assign,nonatomic) NSMutableString *assignMStr;


@end

@implementation PropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableString *mstrOrigin = [[NSMutableString alloc]initWithString:@"mstrOriginValue"];
    
    self.aCopyMStr = mstrOrigin;
    self.strongMStr = mstrOrigin;
    self.strongMStr = mstrOrigin;
    self.weakMStr = mstrOrigin;
    
    NSLog(@"mstrOrigin输出:%p,%@", mstrOrigin,mstrOrigin);
    NSLog(@"aCopyMStr输出:%p,%@",_aCopyMStr,_aCopyMStr);
    NSLog(@"strongMStr输出:%p,%@",_strongMStr,_strongMStr);
    NSLog(@"weakMStr输出:%p,%@",_weakMStr,_weakMStr);
    NSLog(@"引用计数%@",[mstrOrigin valueForKey:@"retainCount"]);

    NSLog(@"------修改原值后------");
    
    [mstrOrigin appendString:@"+1"];
    NSLog(@"mstrOrigin输出:%p,%@", mstrOrigin,mstrOrigin);
    NSLog(@"aCopyMStr输出:%p,%@",_aCopyMStr,_aCopyMStr);
    NSLog(@"strongMStr输出:%p,%@",_strongMStr,_strongMStr);
    NSLog(@"weakMStr输出:%p,%@",_weakMStr,_weakMStr);
    NSLog(@"引用计数%@",[_strongMStr valueForKey:@"retainCount"]);


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
