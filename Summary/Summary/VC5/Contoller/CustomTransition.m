//
//  CustomTransition.m
//  Summary
//
//  Created by xinshiyun on 2017/4/14.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "CustomTransition.h"
#import "ZFShowViewController.h"
#import "ZFPresentViewController.h"
@interface CustomTransition()
@property(assign,nonatomic)BOOL ispresenting;
@end

@implementation CustomTransition

/**
 用来做转场动画
 
 @param ispresenting YES 显示 NO 消失
 @return <#return value description#>
 */
-(instancetype)initWithTransition:(BOOL)ispresenting{
    if (self = [super init]) {
        self.ispresenting = ispresenting;
    }
    return self;
}
// This is used for percent driven interactive transitions, as well as for
// container controllers that have companion animations that might need to
// synchronize with the main animation.
//动画时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{

//    NSLog(@"%@",transitionContext.containerView);//容器
//    NSLog(@"%@",[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]);
//    NSLog(@"%@",[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]);
    
    if (self.ispresenting) {
        ZFShowViewController *showVC =  [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [transitionContext.containerView addSubview:toView];
        CGRect rect = [transitionContext finalFrameForViewController:showVC];

        CGRect startRect = CGRectOffset(rect, 0, -rect.size.height);
        toView.frame = startRect;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:5.0f initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
            toView.frame = rect;
        } completion:^(BOOL finished) {
            if (finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }
        }];
    }else{
    
        
    
    
    
    
    }
    
}
@end
