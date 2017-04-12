//
//  WaterLayout.m
//  Summary
//
//  Created by xinshiyun on 2017/4/10.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "WaterFallLayout.h"
@interface WaterFallLayout()
@property(strong,nonatomic)NSMutableDictionary *MaxYDic;//用来存最大的一个Y值
@property(strong,nonatomic)NSMutableArray *attributArr;
@end


@implementation WaterFallLayout
/*!
 *  类方法布局
 *  @param columnCount 瀑布流横排创建个数
 *  @return nil
 */
+(instancetype)WaterFallLayoutWithColumnCount:(NSInteger)columnCount{
    return [[self alloc] initWithWaterFallLayoutWithColumnCount:columnCount];
}
//初始化方法
-(instancetype)initWithWaterFallLayoutWithColumnCount:(NSInteger)columnCount{
    
    if (self = [super init]) {
        
        self.columnCount = columnCount;
    }
    return self;
}

-(instancetype)init {
    
    if (self = [super init]) {
        self.columnCount = 3;
    }
    return self;
}

//准备布局
-(void)prepareLayout{
    [super prepareLayout];
    //获取每一个cell中Y最短的一个
    for (int i =0; i < self.columnCount; i++) {
        self.MaxYDic[@(i)] = @(self.sectionInset.top);
    }
    
    //获取第一组中所有的数据
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
   
    for (int i = 0; i < itemCount; i ++) { //获取第一组中所有的属性
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.attributArr addObject:attributes];
    }
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - self.rowSpacing * (self.columnCount - 1)) / self.columnCount;
    
    CGFloat itemHeight =0;
    if ([self.delegate respondsToSelector:@selector(getWaterFallLayout:WithItemWidth:WithItemIndexPath:)]) {
        itemHeight = [self.delegate getWaterFallLayout:self WithItemWidth:itemWidth WithItemIndexPath:indexPath];
    }
    
    //找出cell中Y 最短的一个cell的Y
    __block NSNumber *minYKey = @0;
    __weak WaterFallLayout *weakSelf = self;
    [self.MaxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL * _Nonnull stop) {
        if ([weakSelf.MaxYDic[minYKey] floatValue]  > [obj floatValue]) {
            minYKey = key;
        }
    }];
    
    CGFloat itemMinX = self.sectionInset.left + (self.rowSpacing + itemWidth) * [minYKey intValue];
    CGFloat itemMinY = self.sectionInset.top + [self.MaxYDic[minYKey] floatValue];
    
    attributes.frame = CGRectMake(itemMinX, itemMinY, itemWidth, itemHeight);
    
    //存储最大一个数据
    self.MaxYDic[minYKey] = @(CGRectGetMaxY(attributes.frame));
    
    return attributes;
}

-(CGSize)collectionViewContentSize{

    //找出Cell中最大的一个Y
    __block NSNumber *maxYKey = @0;
    __weak WaterFallLayout *weakSelf = self;
    [self.MaxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL * _Nonnull stop) {
        if ([weakSelf.MaxYDic[maxYKey] floatValue]  < [obj floatValue]) {
            maxYKey = key;
        }
    }];

    return CGSizeMake(0, [self.MaxYDic[maxYKey] floatValue] + self.sectionInset.bottom);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributArr;
}




/*!
 *  同时设置间距
 *
 *  @param columnSpacing 列间距
 *  @param rowSpacing    行间距
 *  @param sectionInset section与collectionView的间距
 */
-(void)setColumnSpacing:(NSInteger)columnSpacing WithRowSpacing:(NSInteger)rowSpacing WithSectionInset:(UIEdgeInsets)sectionInset{
    
    self.columnSpacing = columnSpacing;
    self.rowSpacing = rowSpacing;
    self.sectionInset = sectionInset;
}

#pragma mark -- 其他方法
/*
 //返回collectionView的内容的尺寸
 -(CGSize)collectionViewContentSize;
 
 
 -(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
 1.返回rect中的所有的元素的布局属性
 2.返回的是包含UICollectionViewLayoutAttributes的NSArray
 3.UICollectionViewLayoutAttributes可以是cell，追加视图或装饰视图的信息，通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的UICollectionViewLayoutAttributes：
 1)layoutAttributesForCellWithIndexPath:
 2)layoutAttributesForSupplementaryViewOfKind:withIndexPath:
 3)layoutAttributesForDecorationViewOfKind:withIndexPath
 
 -(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath )indexPath
 返回对应于indexPath的位置的cell的布局属性
 
 -(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString )kind atIndexPath:(NSIndexPath *)indexPath
 返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
 
 -(UICollectionViewLayoutAttributes * )layoutAttributesForDecorationViewOfKind:(NSString)decorationViewKind atIndexPath:(NSIndexPath )indexPath
 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
 
 -(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
 当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
 
 在需要更新layout时，需要给当前layout发送
 1)-invalidateLayout， 该消息会立即返回，并且预约在下一个loop的时候刷新当前layout
 2)-prepareLayout，
 3)依次再调用-collectionViewContentSize和-layoutAttributesForElementsInRect来生成更新后的布局。
 
 */

#pragma mark - 懒加载
-(NSMutableDictionary *)MaxYDic {
    
    if (_MaxYDic == nil) {
        _MaxYDic = [NSMutableDictionary dictionary];
    }
    return _MaxYDic;
}

-(NSMutableArray *)attributArr{
    if (_attributArr == nil) {
        _attributArr = [NSMutableArray array];
    }
    return _attributArr;
}
@end
