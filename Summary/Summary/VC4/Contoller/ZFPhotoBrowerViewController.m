//
//  ZFPhotoBrowerViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFPhotoBrowerViewController.h"
#import "ZFPhotoViewController.h"
@interface ZFPhotoBrowerViewController ()

@end

@implementation ZFPhotoBrowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor redColor];
    [self .view addSubview:btn];
    @weakify(self);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.left.equalTo(@90);
        make.width.height.equalTo(@50);
    }];
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ZFPhotoViewController *photoViewController = [[ZFPhotoViewController alloc] init];
        
        [self presentViewController:photoViewController animated:YES completion:NULL];
    }];


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
