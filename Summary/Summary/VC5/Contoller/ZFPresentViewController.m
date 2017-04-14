//
//  ZFPresentViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/14.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFPresentViewController.h"
#import "ZFShowViewController.h"
#import "ZFPresentViewController.h"
#import "ZFPopViewController.h"
@interface ZFPresentViewController ()<UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) ZFPopViewController *itemPopVC;
@property (strong, nonatomic) ZFPopViewController *buttonPopVC;



@property (strong, nonatomic) NSString *currentPop;
@end

//@implementation ZFPresentViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    
//    
//    
//    [self setUI];
//}
//
//-(void)setUI{
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"选择" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    btn.translatesAutoresizingMaskIntoConstraints = NO;
//    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[btn]-50-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(btn)]];
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[btn(==30)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(btn)]];
//
//}
//
//-(void)click{
////    ZFShowViewController *showViewController = [[ZFShowViewController alloc] init];
////    [self presentViewController:showViewController animated:YES completion:NULL];
//    
////    UIPopoverPresentationController * pop = [[UIPopoverPresentationController  alloc] initWithPresentedViewController:<#(nonnull UIViewController *)#> presentingViewController:<#(nullable UIViewController *)#>]
//    
//    //创建你需要显示的controller
// 
//}


@implementation ZFPresentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"item" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.view.backgroundColor = [UIColor whiteColor];
    _button = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 40)];
    [_button setTitle:@"button" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:_button];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableDidSelected:) name:@"click" object:nil];
}
- (void)rightItemClick{
    self.itemPopVC = [[ZFPopViewController alloc] init];
    self.itemPopVC.modalPresentationStyle = UIModalPresentationPopover;
    self.itemPopVC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    //rect参数是以view的左上角为坐标原点（0，0）
    self.itemPopVC.popoverPresentationController.backgroundColor = [UIColor whiteColor];
    self.itemPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown; //箭头方向,如果是baritem不设置方向，会默认up，up的效果也是最理想的
    self.itemPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.itemPopVC animated:YES completion:nil];
} //处理popover上的talbe的cell点击
- (void)tableDidSelected:(NSNotification *)notification {
    NSIndexPath *indexpath = (NSIndexPath *)notification.object;
    switch (indexpath.row) {
        case 0:
        self.view.backgroundColor = [UIColor greenColor];
        break;
        case 1:
        self.view.backgroundColor = [UIColor grayColor];
        break;
        case 2:
        self.view.backgroundColor = [UIColor blueColor];
        break;
        case 3:
        self.view.backgroundColor = [UIColor purpleColor];
        break;
        case 4:
        self.view.backgroundColor = [UIColor yellowColor];
        break;
    }
    if (self.buttonPopVC) {     //我暂时使用这个方法让popover消失，但我觉得应该有更好的方法，因为这个方法并不会调用popover消失的时候会执行的回调。
        [self.buttonPopVC dismissViewControllerAnimated:YES completion:nil];
        self.buttonPopVC = nil;
    }else{
        [self.itemPopVC dismissViewControllerAnimated:YES completion:nil];
        self.itemPopVC = nil;
    
    }
}
- (void)buttonClick:(UIButton *)sender{
    self.buttonPopVC = [[ZFPopViewController alloc] init];

    self.buttonPopVC.modalPresentationStyle = UIModalPresentationPopover;
    self.buttonPopVC.popoverPresentationController.sourceView = _button;  //rect参数是以view的左上角为坐标原点（0，0）
    self.buttonPopVC.popoverPresentationController.sourceRect = _button.bounds; //指定箭头所指区域的矩形框范围（位置和尺寸），以view的左上角为坐标原点
    self.buttonPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
    self.buttonPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.buttonPopVC animated:YES completion:nil];
}//UIPopoverPresentationControllerDelegate,只有返回UIModalPresentationNone才可以让popover在手机上按照我们在preferredContentSize中返回的size显示。这是一个枚举，可以尝试换成其他的值尝试。
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;   //no点击蒙版popover不消失， 默认yes
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
