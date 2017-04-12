//
//  ZFTextFiledViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFTextFiledViewController.h"
#import "ZFTextFiledEditView.h"
@interface ZFTextFiledViewController ()
@property(strong,nonatomic)ZFTextFiledEditView *textFiledEditView;
@end

@implementation ZFTextFiledViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.textFiledEditView = [ZFTextFiledEditView new];
    self.textFiledEditView.placeholder = @"请输入姓名";
    self.textFiledEditView.title = @"委托代理人姓名";
    self.textFiledEditView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.textFiledEditView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_textFiledEditView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_textFiledEditView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_textFiledEditView(>=51)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_textFiledEditView)]];
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
