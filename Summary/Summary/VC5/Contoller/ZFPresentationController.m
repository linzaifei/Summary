//
//  ZFPresentationController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/14.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFPresentationController.h"
#import "ZFPresentViewController.h"
@interface ZFPresentationController()

@property(strong,nonatomic)ZFPresentViewController *soureViewController;
@end

@implementation ZFPresentationController


-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController WithSoure:(UIViewController *)soureViewController{
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        NSLog(@"%@",presentedViewController);
        NSLog(@"%@",presentingViewController);
        self.soureViewController = (ZFPresentViewController *)soureViewController;
//        UIPresentationController
    
    }
    return self;
}

- (void)presentationTransitionWillBegin{
    NSLog(@"%@",self.presentedViewController);
    NSLog(@"%@",self.presentingViewController);
//    [self.containerView addSubview:self.soureViewController.view];
    [self.soureViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        
    }];
    
}

@end
