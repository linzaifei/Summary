//
//  ZFPhotoHeadView.h
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFPhotoHeadView : UINavigationBar
@property(copy,nonatomic)void(^cancelBlock)();
@property(copy,nonatomic)void(^chooseBlock)();
@property(copy,nonatomic)void(^titleBlock)();
@end
