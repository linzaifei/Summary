//
//  ZFPhotoPresentationVC.m
//  Summary
//
//  Created by xsy on 2017/4/19.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFPhotoPresentationVC.h"


#define frameOffset 240 //距离顶部高度
@interface ZFPhotoPresentationVC()
@property(strong,nonatomic)UIView *coverView;
@end
@implementation ZFPhotoPresentationVC

- (void)containerViewWillLayoutSubviews;{
    CGRect toFrame = self.presentingViewController.view.bounds;
    [self.containerView insertSubview:self.coverView atIndex:0];
    self.coverView.frame = toFrame;
    
    self.presentedView.frame = CGRectMake(toFrame.origin.x,64, toFrame.size.width, frameOffset);
}

-(UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [UIView new];
        _coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        _coverView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

-(void)close{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
}


@end
