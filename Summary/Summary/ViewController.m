//
//  ViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/10.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ViewController.h"
#import "ChangeViewController.h"

#import "ZFCollectionLayoutViewContollerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 


}
- (IBAction)ClickAction:(UIButton *)sender {
    ChangeViewController *changeViewController = [[ChangeViewController alloc] init];
    changeViewController.dataArr = @[@"CollectionLayout布局",@"textfield封装",@"RAC登录",@"图片浏览",@"星星视图",@"链式编程",@"相册",@"表情键盘",@"iOS模态  PUSH",@"iOS蓝牙 wifi",@"3d touch",@"指纹解锁",@"微博详情优化"];
    [self.navigationController pushViewController:changeViewController animated:YES];
    changeViewController.didSelectCellBlock = ^(NSArray *dataArr ,NSInteger index){
        switch (index) {
            case 0:{
                ZFCollectionLayoutViewContollerViewController *VC = [[ZFCollectionLayoutViewContollerViewController alloc] init];
                
                [self.navigationController pushViewController:VC animated:YES];
            }break;
                
            default:
                break;
        }
        
        
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
