//
//  ZFPhotoHeadView.m
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFPhotoHeadView.h"
@interface ZFPhotoHeadView()
@property(strong,nonatomic)UIButton *titleBtn;
@end
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
    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    backBtn.frame = CGRectMake(0, 0, 70, 30);
    [backBtn setImage:[UIImage imageNamed:[@"ZFPhotoBundle.bundle" stringByAppendingPathComponent:@"camera_edit_cross.png"]] forState:UIControlStateNormal];
    [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    
    self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleBtn setTitle:NSLocalizedString(@"全部相册", nil) forState:UIControlStateNormal];
    [self.titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleBtn.frame = CGRectMake(0, 0, 70, 30);


    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn setTitle:NSLocalizedString(@"选择", nil) forState:UIControlStateNormal];
    [chooseBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    chooseBtn.frame = CGRectMake(0, 0, 40, 25);
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:chooseBtn];
    item.titleView = self.titleBtn;
    
    [self pushNavigationItem:item animated:YES];
    
    [backBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [chooseBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_titleBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 300;
    chooseBtn.tag = 301;
    _titleBtn.tag = 302;
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

-(void)setTitle:(NSString *)title{
    _title = title;
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
}
@end

@interface ZFCamareHeadView()
@property(strong,nonatomic)UIButton *titleBtn;
@end
@implementation ZFCamareHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

-(void)setUI{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:[@"ZFPhotoBundle.bundle" stringByAppendingPathComponent:@"camera_edit_cross.png"]] forState:UIControlStateNormal];
    
    self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleBtn setTitle:NSLocalizedString(@"相机", nil) forState:UIControlStateNormal];
    [self.titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleBtn.frame = CGRectMake(0, 0, 50, 30);
    
    
    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashBtn setImage:[UIImage imageNamed:[@"ZFPhotoBundle.bundle" stringByAppendingPathComponent:@"camera_flashlight.png"]] forState:UIControlStateNormal];
    [flashBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    flashBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    flashBtn.frame = CGRectMake(0, 0, 40, 25);
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setImage:[UIImage imageNamed:[@"ZFPhotoBundle.bundle" stringByAppendingPathComponent:@"camera_shift_camera_highlighted.png"]] forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    changeBtn.frame = CGRectMake(0, 0, 40, 25);
    
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:flashBtn];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:changeBtn];
    item.rightBarButtonItems = @[rightItem,rightItem1];
    item.titleView = self.titleBtn;
    
    [self pushNavigationItem:item animated:YES];
    
    [backBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [flashBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [changeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 310;
    flashBtn.tag = 311;
    changeBtn.tag = 312;
    
}

-(void)clickBtn:(UIButton *)btn{
    switch (btn.tag - 310) {
        case 0:
            if (self.cancelBlock) {
                self.cancelBlock();
            }
            break;
        case 1:
            if (self.flashBlock) {
                self.flashBlock(btn);
            }
            break;
        case 2:
            if (self.changeBlock) {
                self.changeBlock();
            }
            break;
        default:
            break;
    }
}

@end


@interface ZFTakePhotoHeadView()
@property(strong,nonatomic)UIButton *takePhotoBtn;
@end
@implementation ZFTakePhotoHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

-(void)setUI{
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    cancelBtn.frame = CGRectMake(0, 0, 40, 25);
    [self addSubview:cancelBtn];
    
    
    self.takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.takePhotoBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.takePhotoBtn setImage:[UIImage imageNamed:[@"ZFPhotoBundle.bundle" stringByAppendingPathComponent:@"compose_color_black_select.png"]] forState:UIControlStateNormal];
    [self.takePhotoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.takePhotoBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.takePhotoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.takePhotoBtn.frame = CGRectMake(0, 0, 50, 30);
    [self addSubview:self.takePhotoBtn];
    
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn setTitle:NSLocalizedString(@"采用", nil) forState:UIControlStateNormal];
    chooseBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [chooseBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    chooseBtn.frame = CGRectMake(0, 0, 40, 25);
    [self addSubview:chooseBtn];
    
    
    [self.takePhotoBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [chooseBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn.tag = 320;
    self.takePhotoBtn.tag = 321;
    chooseBtn.tag = 322;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.takePhotoBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.takePhotoBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:cancelBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cancelBtn]-60-[_takePhotoBtn]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(cancelBtn,_takePhotoBtn)]];

    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:chooseBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_takePhotoBtn]-60-[chooseBtn]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(chooseBtn,_takePhotoBtn)]];

}

-(void)clickBtn:(UIButton *)btn{
    switch (btn.tag - 320) {
        case 0:
            if(self.cancelBlock){
                self.cancelBlock();
            }
            break;
        case 1:
            if (self.takePhotoBlock) {
                self.takePhotoBlock();
            }        
            break;
        case 2:
            if(self.chooseBlock){
                self.chooseBlock();
            }
            break;
            
        default:
            break;
    }
    
    
}

@end
