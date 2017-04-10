//
//  ChangeViewController.h
//  Summary
//
//  Created by xinshiyun on 2017/4/10.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^(DidSelectCellBlock))(NSArray *dataArr,NSInteger selectIndex);
@interface ChangeViewController : UIViewController
@property(strong,nonatomic)NSArray *dataArr;
@property(strong,nonatomic)DidSelectCellBlock didSelectCellBlock;

@end
