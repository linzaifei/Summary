//
//  WaterLayout.m
//  Summary
//
//  Created by xinshiyun on 2017/4/10.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "WaterLayout.h"
@interface WaterLayout()
@property(strong,nonatomic)NSMutableDictionary *MaxYDic;
@end


@implementation WaterLayout
/*!
 *  类方法布局
 *
 *  @param columnCount 瀑布流横排创建个数
 *
 *  @return
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


-(void)prepareLayout{

    
    
    
}



#pragma mark - 懒加载
-(NSMutableDictionary *)MaxYDic {
    
    if (_MaxYDic == nil) {
        _MaxYDic = [NSMutableDictionary dictionary];
    }
    return _MaxYDic;
}
@end
