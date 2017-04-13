//
//  ZFPhotoCollectionViewCell.h
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;


@interface ZFPhotoCollectionViewCell : UICollectionViewCell

-(void)zf_setAssest:(id)data;

@property(copy,nonatomic)void(^btnSelectBlock)(PHAsset *asset,BOOL isSelect);

@property(assign,nonatomic)BOOL isSelect;

@end
