//
//  ZFPhotoCollectionViewCell.m
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFPhotoCollectionViewCell.h"
#import <Photos/Photos.h>
#import "ZFBtn.h"
@interface ZFPhotoCollectionViewCell()
@property(strong,nonatomic)UIImageView *imageView;
@property(strong,nonatomic)ZFBtn *selectBtn;
@property(strong,nonatomic)PHAsset *asset;

@end

@implementation ZFPhotoCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.imageView = [UIImageView new];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    
    self.selectBtn = [ZFBtn new];
    self.selectBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectBtn.frame = CGRectMake(0, 0, 60, 30);
    [self.selectBtn setImage:[UIImage imageNamed:[@"ZFPhotoBundle.bundle" stringByAppendingPathComponent:@"Asset_checked_no.png"]] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:[@"ZFPhotoBundle.bundle" stringByAppendingPathComponent:@"Asset_checked.png"]] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(clickCollect:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectBtn];
    

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_imageView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_imageView)]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_selectBtn]-5-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_selectBtn)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_selectBtn]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_selectBtn)]];
 
    
}
-(void)zf_setAssest:(id)data{
    if ([data isKindOfClass:[UIImage class]]) {//显示第一张相机
        self.selectBtn.hidden = YES;
        self.imageView.image = data;
    }else{
        self.selectBtn.hidden = NO;
        self.asset = (PHAsset *)data;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        CGSize size = CGSizeMake(self.asset.pixelWidth * 0.06 < 200 ? 200 :self.asset.pixelWidth * 0.06, self.asset.pixelHeight * 0.06 <200 ? 200 :self.asset.pixelHeight * 0.06 );
        // 从asset中获得图片
        __weak ZFPhotoCollectionViewCell *WS = self;
       /*
        //会缓存在内存中
        [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            WS.imageView.image = result;
        }];
        */
        
        //不会缓存在内存中
        [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                WS.imageView.image = result;
        }];
        
    }
}

-(void)setIsSelect:(BOOL)isSelect{
    self.selectBtn.selected = isSelect;
}

-(void)clickCollect:(ZFBtn *)btn{
//    btn.selected = !btn.selected;
    if (self.btnSelectBlock) {
        self.btnSelectBlock(self.asset, btn.selected);
    }
}

@end
