//
//  ZFTextFiledEditView.h
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFTextFiledEditView : UIView

@property(copy,nonatomic)NSString *title;
@property(strong,nonatomic)UIColor *titleTextColor;
@property(copy,nonatomic)NSString *text;
@property(strong,nonatomic)UIColor *textColor;
@property(copy,nonatomic)NSString *placeholder;
@property(assign,nonatomic)NSInteger font;

@end
