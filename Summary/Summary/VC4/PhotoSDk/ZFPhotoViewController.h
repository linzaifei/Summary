//
//  ZFPhotoViewController.h
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;
@protocol ZFPhotoPickerViewControllerDelegate;
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

/*!
 * 最大选择数量 默认9 
 */
@property(assign,nonatomic)NSInteger maxCount;

/*!
 * 选中的照片
 */
@property(strong,nonatomic)NSArray<PHAsset *>*selectItems;

@property (nonatomic,weak) id<ZFPhotoPickerViewControllerDelegate> delegate;


@end



@protocol ZFPhotoPickerViewControllerDelegate <NSObject>

- (void)photoPickerViewControllerTapCameraAction:(ZFPhotoViewController *)pickerViewController;
- (void)photoPickerViewController:(ZFPhotoViewController *)pickerViewController didSelectPhotos:(NSArray<PHAsset *> *)photos;

@end

