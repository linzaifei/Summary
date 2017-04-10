//
//  ZFCollectModel.m
//  Summary
//
//  Created by xinshiyun on 2017/4/10.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFCollectModel.h"

@implementation ZFCollectModel
+(NSMutableArray *)getDataWithPath:(NSString *)plistPath{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistPath ofType:nil];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    return [self getdataWithArr:arr];
}

+(NSMutableArray *)getdataWithArr:(NSArray *)arr{
    NSArray *dataArr = [[arr.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return [ZFCollectModel mj_objectWithKeyValues:value];
    }] array];
    return [dataArr mutableCopy];
}
@end
