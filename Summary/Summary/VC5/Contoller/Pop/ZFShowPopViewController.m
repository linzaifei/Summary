//
//  ZFShowPopViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/17.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFShowPopViewController.h"
#import "ZFPopViewController.h"
@interface ZFShowPopViewController ()<UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) ZFPopViewController *itemPopVC;
@property (strong, nonatomic) ZFPopViewController *buttonPopVC;
@property (strong, nonatomic) UIButton *button;


@property(strong,nonatomic)NSArray *dataArr;
@end

@implementation ZFShowPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = @[@"green",@"gray", @"blue",@"purple", @"yellow"];
    [self setUI];
}
-(void)setUI{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"item" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.view.backgroundColor = [UIColor whiteColor];
    _button = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 40)];
    [_button setTitle:@"button" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:_button];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)rightItemClick{
    self.itemPopVC = [[ZFPopViewController alloc] init];
    self.itemPopVC.dataArr = self.dataArr;
    self.itemPopVC.modalPresentationStyle = UIModalPresentationPopover;
    self.itemPopVC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    //rect参数是以view的左上角为坐标原点（0，0）
    self.itemPopVC.popoverPresentationController.backgroundColor = [UIColor whiteColor];
    self.itemPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown; //箭头方向,如果是baritem不设置方向，会默认up，up的效果也是最理想的
    self.itemPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.itemPopVC animated:YES completion:nil];
    __weak ZFShowPopViewController *ws = self;
    self.itemPopVC.clickCellIndexBlock = ^(NSArray *dataArr, NSInteger index) {
        [ws tableDidSelected:index];
    };
}

- (void)buttonClick:(UIButton *)sender{
    self.buttonPopVC = [[ZFPopViewController alloc] init];
    self.buttonPopVC.dataArr = self.dataArr;
    self.buttonPopVC.modalPresentationStyle = UIModalPresentationPopover;
    self.buttonPopVC.popoverPresentationController.sourceView = _button;  //rect参数是以view的左上角为坐标原点（0，0）
    self.buttonPopVC.popoverPresentationController.sourceRect = _button.bounds; //指定箭头所指区域的矩形框范围（位置和尺寸），以view的左上角为坐标原点
    self.buttonPopVC.popoverPresentationController.backgroundColor = [UIColor whiteColor];
    self.buttonPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
    self.buttonPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.buttonPopVC animated:YES completion:nil];
    __weak ZFShowPopViewController *ws = self;
    self.buttonPopVC.clickCellIndexBlock = ^(NSArray *dataArr, NSInteger index) {
        [ws tableDidSelected:index];
    };
}

//处理popover上的talbe的cell点击
- (void)tableDidSelected:(NSInteger)index {
   
    switch (index) {
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
    if (self.buttonPopVC) {  
        [self.buttonPopVC dismissViewControllerAnimated:YES completion:nil];
        self.buttonPopVC = nil;
    }else{
        [self.itemPopVC dismissViewControllerAnimated:YES completion:nil];
        self.itemPopVC = nil;
    }
}

//UIPopoverPresentationControllerDelegate,只有返回UIModalPresentationNone才可以让popover在手机上按照我们在preferredContentSize中返回的size显示。这是一个枚举，可以尝试换成其他的值尝试。
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;   //no点击蒙版popover不消失， 默认yes
}
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{

    NSLog(@"popver消失");
}
- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView  * __nonnull * __nonnull)view{
    NSLog(@"控制器%@",popoverPresentationController);
 
    
    
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
