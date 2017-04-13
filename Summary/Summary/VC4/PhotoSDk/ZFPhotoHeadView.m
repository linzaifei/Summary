//
//  ZFPhotoHeadView.m
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFPhotoHeadView.h"

@implementation ZFPhotoHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
    }
    return self;
}

-(void)setUI{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    backBtn.frame = CGRectMake(0, 0, 60, 30);
    [backBtn setImage:[UIImage imageNamed:[@"ZFPhotoBundle.bundle" stringByAppendingPathComponent:@"photo_back.png"]] forState:UIControlStateNormal];
    [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn setTitle:NSLocalizedString(@"选择", nil) forState:UIControlStateNormal];
    [chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    chooseBtn.frame = CGRectMake(0, 0, 40, 25);
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:chooseBtn];
    [self pushNavigationItem:item animated:YES];
    
    [backBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [chooseBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 300;
    chooseBtn.tag = 301;
    
}

-(void)clickBtn:(UIButton *)btn{
    switch (btn.tag - 300) {
        case 0:
            if (self.cancelBlock) {
                self.cancelBlock();
            }
            break;
        case 1:
            if (self.chooseBlock) {
                self.chooseBlock();
            }
            break;
        case 2:
            if (self.titleBlock) {
                self.titleBlock();
            }
            break;
        default:
            break;
    }
}


@end
