//
//  ZFCollectionWaterFallViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/11.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFCollectionWaterFallViewController.h"
#import "ZFCollectModel.h"
#import "WaterFallLayout.h"
#import "ZFCollectionViewCell.h"
#import "ScrollLayout.h"

@interface ZFCollectionWaterFallViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZFWaterFallDelegate>

@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)NSMutableArray *dataArr;

@end

@implementation ZFCollectionWaterFallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [ZFCollectModel getDataWithPath:@"1.plist"];
    [self setUI];
}

-(void)setUI{
    
    UICollectionViewLayout *collectLayout= nil;
    switch (self.type) {
        case CollectionLayoutTypeNone:{
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumLineSpacing = 5;
            layout.minimumInteritemSpacing = 5;
            CGFloat width = (kScreenWidth - 4 * 5 ) / 3.0;
            layout.itemSize = CGSizeMake(width, width);
            layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
            collectLayout = layout;
        }break;
        case CollectionLayoutTypeWater:{
           WaterFallLayout *layout = [[WaterFallLayout alloc] initWithWaterFallLayoutWithColumnCount:3];
            layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
            layout.rowSpacing = 5;
            layout.columnSpacing = 5;
            layout.delegate = self;
            collectLayout = layout;
        }break;
        case CollectionLayoutTypeScroll:{
            ScrollLayout *layout = [[ScrollLayout alloc] init];
            layout.minimumLineSpacing = 5;
            layout.minimumInteritemSpacing = 5;
            layout.itemSize=CGSizeMake(240, 400);
            collectLayout = layout;
        }break;
            
        default:
            break;
    }
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectLayout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = HexRGB(0xf2f2f2);
    self.collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[ZFCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZFCollectionViewCell class])];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_collectionView)]];
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZFCollectionViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(CGFloat)getWaterFallLayout:(WaterFallLayout *)waterFallLayout WithItemWidth:(CGFloat)itemWidth WithItemIndexPath:(NSIndexPath *)indexPath{
    ZFCollectModel *model = self.dataArr[indexPath.item];
    return itemWidth * model.h / model.w;
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
