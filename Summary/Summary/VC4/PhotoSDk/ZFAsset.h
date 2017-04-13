//
//  ZFAsset.h
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PHAsset;
@interface ZFAsset : NSObject
@property(strong,nonatomic)UIImage *image;
@property(copy,nonatomic)NSString *imgPath;
@property(copy,nonatomic)NSString *imgName;

@property(strong,nonatomic)PHAsset *asset;
@end
