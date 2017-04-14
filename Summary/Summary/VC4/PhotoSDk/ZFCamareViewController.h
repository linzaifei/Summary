//
//  ZFCamareViewController.h
//  Summary
//
//  Created by xinshiyun on 2017/4/14.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class  PHAsset;
@protocol CameraViewDelegate <NSObject>

@optional
- (void)photoCapViewController:(UIViewController *)viewController didFinishDismissWithPhotoImage:(PHAsset *)alasset;

@end

@interface ZFCamareViewController : UIViewController

@property(weak,nonatomic)id<CameraViewDelegate> cameraDelegate;

@end
