//
//  CollectionViewCell.m
//  Summary
//
//  Created by xinshiyun on 2017/4/11.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFCollectionViewCell.h"
#import "ZFCollectModel.h"
@interface ZFCollectionViewCell()
@property(strong,nonatomic)UIImageView *imageView;
@property(strong,nonatomic)UILabel *piceLabel;
@end
@implementation ZFCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.imageView = [UIImageView new];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.imageView];
    
    self.piceLabel = [UILabel new];
    self.piceLabel.font = [UIFont systemFontOfSize:15];
    self.piceLabel.textColor = [UIColor whiteColor];
    self.piceLabel.textAlignment = NSTextAlignmentCenter;
    self.piceLabel.backgroundColor = [UIColor grayColor];
    self.piceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.piceLabel];

    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_imageView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_imageView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_piceLabel]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_piceLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_piceLabel]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_piceLabel)]];
    
}

-(void)setModel:(ZFCollectModel *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.piceLabel.text = model.price;
    
}

@end
