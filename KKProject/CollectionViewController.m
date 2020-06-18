//
//  CollectionViewController.m
//  KKProject
//
//  Created by youplus on 2018/12/28.
//  Copyright © 2018 zhangke. All rights reserved.
//

#import "CollectionViewController.h"
#import "Masonry/Masonry.h"

@interface CollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIView *_playerView;

}
@property (nonatomic, strong) UIView *playerView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation CollectionViewController


+ (CollectionViewController *)colletionViewTest {
    CollectionViewController *c = [[CollectionViewController alloc] init];
    c.playerView = [UIView new];
    return c;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            [_dataArray addObject:@(i)];
        }
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CollectionViewController *c = [CollectionViewController colletionViewTest];
    NSLog(@"%@--%@",c.playerView,c->_playerView);
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(120);
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}


- (UICollectionView *)collectionView {

    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.itemSize = CGSizeMake(50, 50);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;

//        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        
        // 长按手势触发 处理 cell 拖动
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        [_collectionView addGestureRecognizer:longGesture];
        
    }
    return _collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] init];
    NSNumber *num = self.dataArray[indexPath.item];
    label.text = [NSString stringWithFormat:@"%d",num.intValue];
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(cell.contentView);
    }];
    cell.backgroundColor = [UIColor cyanColor];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    id objc = [self.dataArray objectAtIndex:sourceIndexPath.item];
    [self.dataArray removeObject:objc];
    [self.dataArray insertObject:objc atIndex:destinationIndexPath.item];
}


// 长按拖动手势事件
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            // 通过手势获取点，通过点获取点击的indexPath， 移动该item
            NSIndexPath *AindexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:AindexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            // 更新移动位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
        }
            break;
        case UIGestureRecognizerStateEnded:
            // 移动完成关闭cell移动
            [self.collectionView endInteractiveMovement];
            break;
            
        default:
            [self.collectionView endInteractiveMovement];
            break;
    }
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
