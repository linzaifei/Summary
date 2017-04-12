//
//  WaterLayout.h
//  Summary
//
//  Created by xinshiyun on 2017/4/10.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFallLayout;

@protocol ZFWaterFallDelegate <NSObject>

@required
-(CGFloat)getWaterFallLayout:(WaterFallLayout *)waterFallLayout WithItemWidth:(CGFloat)itemWidth WithItemIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterFallLayout : UICollectionViewLayout

/*!
 * 类方法布局
 *
 *  @param columnCount 瀑布流横排创建个数
 *  @return nil
 */
+(instancetype)WaterFallLayoutWithColumnCount:(NSInteger)columnCount;
//初始化方法

-(instancetype)initWithWaterFallLayoutWithColumnCount:(NSInteger)columnCount;

/*!
 *  瀑布流横排显示数目 默认 3
 */
@property(assign,nonatomic)NSInteger columnCount;

/*!
 *  列间距，默认是0
 */
@property(assign,nonatomic)NSInteger columnSpacing;

/*!
 * 行间距，默认是0
 */
@property(assign,nonatomic)NSInteger rowSpacing;

/*!
 * section与collectionView的间距，默认是（0，0，0，0）
 */
@property(assign,nonatomic)UIEdgeInsets sectionInset;

/*!
 *  同时设置间距
 *
 *  @param columnSpacing 列间距
 *  @param rowSpacing    行间距
 *  @param sectionInset section与collectionView的间距
 */
-(void)setColumnSpacing:(NSInteger)columnSpacing WithRowSpacing:(NSInteger)rowSpacing WithSectionInset:(UIEdgeInsets)sectionInset;



@property(weak,nonatomic)id<ZFWaterFallDelegate> delegate;

@end
