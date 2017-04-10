//
//  ZFCollectModel.h
//  Summary
//
//  Created by xinshiyun on 2017/4/10.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFCollectModel : NSObject
+(NSMutableArray *)getDataWithPath:(NSString *)plistPath;

@property(assign,nonatomic)CGFloat h;
@property(assign,nonatomic)CGFloat w;
@property(copy,nonatomic)NSString *img;
@property(copy,nonatomic)NSString *price;

@end
