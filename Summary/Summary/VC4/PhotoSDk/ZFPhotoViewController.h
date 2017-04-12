//
//  ZFPhotoViewController.h
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFPhotoViewController : UIViewController
/*!
 * 排显示数目 默认 3
 */
@property(assign,nonatomic)NSInteger columnCount;

/*!
 *  列间距，默认是5
 */
@property(assign,nonatomic)NSInteger columnSpacing;

/*!
 * 行间距，默认是5
 */
@property(assign,nonatomic)NSInteger rowSpacing;

/*!
 * section与collectionView的间距，默认是（5，5，5，5）
 */
@property(assign,nonatomic)UIEdgeInsets sectionInset;


@end
