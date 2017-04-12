//
//  ScrollLayout.m
//  Summary
//
//  Created by xinshiyun on 2017/4/11.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ScrollLayout.h"

@implementation ScrollLayout


-(void)prepareLayout{
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat insert = (self.collectionView.frame.size.width - self.itemSize.width) / 2;
    self.sectionInset = UIEdgeInsetsMake(0, insert, 0, insert);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    NSArray *attributesArr = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat scrollCenterX = self.collectionView.frame.size.width / 2.0 + self.collectionView.contentOffset.x;
    __weak ScrollLayout *WS = self;
    [attributesArr enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat differenceOffest = ABS(scrollCenterX - obj.center.x);
        CGFloat sale = 1 - (differenceOffest / WS.collectionView.frame.size.width / 3.0 );
        sale = sale > 0.8 ? sale :0.8;
        obj.transform = CGAffineTransformMakeScale(sale, sale);
    }];
    
    return attributesArr;
}

/*!
 *  多次调用 只要滑出范围就会 调用
 *  当CollectionView的显示范围发生改变的时候，是否重新发生布局
 *  一旦重新刷新 布局，就会重新调用
 *  1.layoutAttributesForElementsInRect：方法
 *  2.preparelayout方法
 */
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    NSLog(@"%f",proposedContentOffset.x);
    CGRect rect ;
    rect.origin.x = proposedContentOffset.x;
    rect.origin.y = 0;
    rect.size = self.collectionView.frame.size;
    
    NSArray *attributesArr = [super layoutAttributesForElementsInRect:rect];

    //获取中心距离
    CGFloat CenterX = proposedContentOffset.x + self.collectionView.frame.size.width / 2;
    
    __block CGFloat minData = MAXFLOAT;
    [attributesArr enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(ABS(minData) > ABS(obj.center.x - CenterX)){
            minData = obj.center.x - CenterX;
        }
    }];
    
    // 修改原有的偏移量
    proposedContentOffset.x += minData;
    //如果返回的时zero 那个滑动停止后 就会立刻回到原地
    return proposedContentOffset;

}

@end
