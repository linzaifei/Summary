//
//  ZFPhotoHeadView.h
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCamareHeadView;
@class ZFTakePhotoHeadView;

typedef void(^CancelBlock)();
typedef void(^ChooseBlock)();
typedef void(^TitleBlock)();
typedef void(^FlashBlock)(UIButton *flashBtn);
typedef void(^ChangeBlock)();


@interface ZFPhotoHeadView : UINavigationBar
@property(copy,nonatomic)NSString *title;
@property(copy,nonatomic)CancelBlock cancelBlock;
@property(copy,nonatomic)ChooseBlock chooseBlock;
@property(copy,nonatomic)TitleBlock titleBlock;
@end

@interface ZFCamareHeadView : UINavigationBar
@property(copy,nonatomic)CancelBlock cancelBlock;
@property(copy,nonatomic)ChangeBlock changeBlock;
@property(copy,nonatomic)FlashBlock flashBlock;
@end

@interface ZFTakePhotoHeadView : UIView
@property(copy,nonatomic)void(^takePhotoBlock)();
@property(copy,nonatomic)CancelBlock cancelBlock;
@property(copy,nonatomic)ChooseBlock chooseBlock;
@end


