//
//  ZFPresentationController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/14.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFPresentationController.h"
#define frameOffset 240 //距离顶部高度

@interface ZFPresentationController()


@end

@implementation ZFPresentationController

-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController{
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        self.presentFrame = CGRectZero;
    }
    return self;
}




//- (void)presentationTransitionWillBegin{
//    NSLog(@"%@",self.presentedViewController);
//    NSLog(@"%@",self.presentingViewController);
//    
//    [self.containerView addSubview:self.presentingViewController.view];
////    [self.containerView addSubview:self.bgView];
//    
//    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//       
//        
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        
//    }];
//    
//}
//-(CGRect)frameOfPresentedViewInContainerView{
//    
//    CGRect toFrame = self.presentingViewController.view.bounds;
//    return CGRectMake(toFrame.origin.x,64, toFrame.size.width, frameOffset);
//}
-(void)containerViewDidLayoutSubviews{
    CGRect toFrame = self.presentingViewController.view.bounds;
    self.presentedView.frame = CGRectMake(toFrame.origin.x,64, toFrame.size.width, frameOffset);
//    }else{
//        self.presentedView.frame = self.presentFrame;
//    }
}


@end
