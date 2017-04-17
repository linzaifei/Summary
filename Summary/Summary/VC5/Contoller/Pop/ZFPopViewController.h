//
//  ZFPopViewController.h
//  Summary
//
//  Created by xinshiyun on 2017/4/14.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFPopViewController : UIViewController
@property(strong,nonatomic)NSArray *picArr;
@property(strong,nonatomic)NSArray *dataArr;
@property(copy,nonatomic)void(^clickCellIndexBlock)(NSArray *dataArr,NSInteger index);
@end
