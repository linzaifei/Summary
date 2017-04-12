//
//  ZFCollectionWaterFallViewController.h
//  Summary
//
//  Created by xinshiyun on 2017/4/11.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFBaseViewController.h"


typedef NS_ENUM(NSInteger, CollectionLayoutType) {
    CollectionLayoutTypeNone = 0, //普通类型
    CollectionLayoutTypeWater,//瀑布流
    CollectionLayoutTypeScroll,//滚动类型
};
@interface ZFCollectionWaterFallViewController : ZFBaseViewController

@property(assign,nonatomic)CollectionLayoutType type;

@end
