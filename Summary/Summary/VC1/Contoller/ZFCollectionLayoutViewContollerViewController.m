//
//  ZFCollectionLayoutViewContollerViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/10.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFCollectionLayoutViewContollerViewController.h"
#import "ZFCollectModel.h"
#import "WaterLayout.h"

@interface ZFCollectionLayoutViewContollerViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)NSMutableArray *dataArr;
@property(strong,nonatomic)UICollectionView *collectionView;
@end

@implementation ZFCollectionLayoutViewContollerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [ZFCollectModel getDataWithPath:@"1.plist"];
    
    [self setUI];
}

-(void)setUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    CGFloat width = (kScreenWidth - 4 * 5 ) / 3.0;
    layout.itemSize = CGSizeMake(width, width);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.allowsMultipleSelection = YES;//
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_collectionView)]];
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 5);
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
