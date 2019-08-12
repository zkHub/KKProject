//
//  UINavigationController+CheckLeaks.m
//  KKProject
//
//  Created by 张柯 on 2019/7/10.
//  Copyright © 2019 zhangke. All rights reserved.
//

#import "UINavigationController+CheckLeaks.h"

@implementation UINavigationController (CheckLeaks)





+ (void)load {
    
    Method fromMethod = class_getInstanceMethod([self class], @selector(popViewControllerAnimated:));
    Method toMethod = class_getInstanceMethod([self class], @selector(CL_popViewControllerAnimated:));
    if (!class_addMethod([self class], @selector(popViewControllerAnimated:), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}

- (UIViewController *)CL_popViewControllerAnimated:(BOOL)animated {
    
    UIViewController *vc = [self CL_popViewControllerAnimated:animated];
    __weak UIViewController *weakVC = vc;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakVC) {
            NSLog(@"%@--leak",weakVC);
        }
    });
    return vc;
    
}




@end
