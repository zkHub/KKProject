//
//  ProducerConsumerVC.m
//  KKProject
//
//  Created by 张柯 on 2019/6/25.
//  Copyright © 2019 zhangke. All rights reserved.
//

#import "ProducerConsumerVC.h"

@interface ProducerConsumerVC ()

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) dispatch_semaphore_t pro_semaphore;
@property (nonatomic, strong) dispatch_semaphore_t con_semaphore;


//生产者线程跑的队列,这个队列可以控制生产者的执行是并行还是串行
@property(strong,nonatomic)dispatch_queue_t producerQueue;

//消费者线程跑的队列，这个队列可以控制消费者的执行是并行还是串行
@property(strong,nonatomic) dispatch_queue_t consumerQueue;


@end

@implementation ProducerConsumerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.maxCount = 10;
    //分别创建N个生产者和M消费者各自的运行并发队列
    //均使用并发队列，即生产者之间可以并发执行，消费者之间也可以并发执行
    self.producerQueue = dispatch_queue_create("producer", DISPATCH_QUEUE_CONCURRENT);
    self.consumerQueue = dispatch_queue_create("consumer", DISPATCH_QUEUE_CONCURRENT);
    
    self.pro_semaphore = dispatch_semaphore_create(self.maxCount);
    self.con_semaphore = dispatch_semaphore_create(0);
    
    NSLog(@"begin");
    [self producerFunc];
    [self consumerFunc];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


//生产者
- (void)producerFunc{
    
    dispatch_async(self.producerQueue, ^{
        while (YES) {
            sleep(1);
            NSLog(@"生产...");
            dispatch_semaphore_wait(self.pro_semaphore, DISPATCH_TIME_FOREVER);
            int t = random()%10;
            [self.array addObject:[NSString stringWithFormat:@"%d",t]];
            dispatch_semaphore_signal(self.con_semaphore);
            NSLog(@"生产成功---仓库容量%lu",self.array.count);
            
            /*
             //测试
            long spaceCount = dispatch_semaphore_wait(self.pro_semaphore, 5 * NSEC_PER_SEC);
            if (spaceCount != 0) {
                NSLog(@"等待生产---%ld---仓库容量%lu",spaceCount,self.array.count);
            } else {
                int t = random()%10;
                [self.array addObject:[NSString stringWithFormat:@"%d",t]];
                dispatch_semaphore_signal(self.con_semaphore);
                NSLog(@"生产成功---%ld---仓库容量%lu",spaceCount,self.array.count);
            }
            */
            
        }
    });
}

//消费者
- (void)consumerFunc{
    
    dispatch_async(self.consumerQueue, ^{
        while (YES) {
            sleep(2);
            NSLog(@"消费...");
            dispatch_semaphore_wait(self.con_semaphore, DISPATCH_TIME_FOREVER);
            [self.array removeLastObject];
            NSLog(@"消费成功---仓库容量%lu",self.array.count);
            dispatch_semaphore_signal(self.pro_semaphore);
            
            
            /*
            //测试
            long spaceCount = dispatch_semaphore_wait(self.con_semaphore, 5 * NSEC_PER_SEC);
            if (spaceCount != 0) {
                NSLog(@"等待消费---%ld---仓库容量%lu",spaceCount,self.array.count);
            } else {
                [self.array removeLastObject];
                NSLog(@"消费成功---%ld---仓库容量%lu",spaceCount,self.array.count);
                dispatch_semaphore_signal(self.pro_semaphore);
            }
            */
            
        }
    });
}

- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return  _array;
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
