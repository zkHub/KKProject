//
//  DispatchViewController.m
//  KKProject
//
//  Created by 张柯 on 2018/4/19.
//  Copyright © 2018年 zhangke. All rights reserved.
//

#import "DispatchViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface DispatchViewController ()

@property (nonatomic, copy) NSString *str;

@end





@implementation DispatchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self barrier];
//    [self dispatchGroup];
//    [self dispatchSemaphore];
//    [self test];
//    [self testQueue];
    [self testSemaphore];
    
}

- (void)testSemaphore {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//如果先wait则初始化时为最大并发数。
            NSLog(@"begin-%d-%@",i,[NSThread currentThread]);
            [NSThread sleepForTimeInterval:5];
            dispatch_semaphore_signal(semaphore);
            NSLog(@"end-%d-%@",i,[NSThread currentThread]);
        });
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//如果后wait则初始化时为最大并发数-1。
    }
    
  
    
}



- (void)testQueue {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"1--%@",[NSThread currentThread]);
    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:2];
        NSLog(@"2--%@",[NSThread currentThread]);
        //dispatch_sync 会等34打印才会打印5,dispatch_async则不会等待，而且是queue的话也适用
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"3--%@",[NSThread currentThread]);
//            [NSThread sleepForTimeInterval:2];
            NSLog(@"4--%@",[NSThread currentThread]);
        });
        NSLog(@"5--%@",[NSThread currentThread]);
    });
//    [NSThread sleepForTimeInterval:2];
    NSLog(@"6--%@",[NSThread currentThread]);
    
    
}


- (void)queue {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"1" forKey:@"1"];
    [user synchronize];
    
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"%@--1",[NSThread currentThread]);
    dispatch_async(queue, ^{
        NSLog(@"%@--2",[NSThread currentThread]);
        dispatch_sync(queue, ^{//如果是 serial 是串行执行会造成死锁，而 concurrent 允许并发执行。
            NSLog(@"%@--3",[NSThread currentThread]);
        });
    });
    NSLog(@"%@--4",[NSThread currentThread]);

    
}


- (void)test {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 100, 100)];
    label.text = @"123";
    [self.view addSubview:label];
    
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    [opQueue addOperationWithBlock:^{
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:4]];
        dispatch_async(dispatch_get_main_queue(), ^{
            label.text = @"456";
        });
    }];
    
}



#pragma mark --信号量实现任务依赖
- (void)dispatchSemaphore {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.operationQueue.maxConcurrentOperationCount = 4;
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSArray *array = @[@"https://www.baidu.com",@"https://www.taobao.com",@"http://www.qq.com"];
    dispatch_async(queue, ^{

        for (int i = 0; i < 3; i++) {
            NSString *urlStr = array[i];
            int tag = i;
            NSLog(@"%d-%@\n%@",tag,urlStr,[NSThread currentThread]);

            [sessionManager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"success-%d-%@\n%@",tag,urlStr,[NSThread currentThread]);
                //信号量+1，会唤醒之前正在等待的线程
                dispatch_semaphore_signal(semaphore);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failure-%d-%@\n%@",tag,urlStr,[NSThread currentThread]);
                dispatch_semaphore_signal(semaphore);
                
            }];
            //信号量-1，当返回值小于0时，函数返回会等待，阻塞当前线程
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"%d",tag);
        }
  
    });
    
    NSLog(@"done");
    
}

#pragma mark --分发组实现等待并发任务完成
- (void)dispatchGroup {

    dispatch_group_t group = dispatch_group_create();
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.operationQueue.maxConcurrentOperationCount = 4;
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSArray *array = @[@"https://www.baidu.com",@"https://www.taobao.com",@"http://www.qq.com"];
    for (int i = 0; i < 3; i++) {
        NSString *urlStr = array[i];
        int tag = i;
        dispatch_group_enter(group);//标志着一个任务追加到 group
        [sessionManager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success-%d-%@\n%@",tag,urlStr,[NSThread currentThread]);
            dispatch_group_leave(group);//标志着一个任务离开了 group
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure-%d-%@\n%@",tag,urlStr,[NSThread currentThread]);
            dispatch_group_leave(group);
            
        }];
        
    }
    //当 group 中未执行完毕任务数为0的时候，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"done-%@",[NSThread currentThread]);
    });
    
    NSLog(@"main_queue");
    
}


#pragma mark --栅栏
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("com.Ike.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        [NSThread sleepForTimeInterval:arc4random()%10];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
    });
    dispatch_async(queue, ^{
        // 追加任务2
        [NSThread sleepForTimeInterval:arc4random()%10];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        [NSThread sleepForTimeInterval:arc4random()%10];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程

    });
    
    dispatch_async(queue, ^{
        // 追加任务4
        [NSThread sleepForTimeInterval:arc4random()%10];              // 模拟耗时操作
        NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        
    });
    
    
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
