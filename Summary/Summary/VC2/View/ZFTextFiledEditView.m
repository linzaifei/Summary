//
//  ZFTextFiledEditView.m
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFTextFiledEditView.h"
#import "UITextView+Placeholder.h"
@interface ZFTextFiledEditView()<UITextViewDelegate>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextView *textView;

@end
@implementation ZFTextFiledEditView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [UILabel new];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = HexRGB(0x737373);
    [self addSubview:self.titleLabel];
    
    self.textView = [UITextView new];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.scrollEnabled = NO;
    self.textView.textColor = HexRGB(0x333333);
    self.textView.delegate = self;
    self.textView.textContainerInset = UIEdgeInsetsZero;
    self.textView.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.textView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_titleLabel]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_titleLabel]-20-[_textView]-15-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_textView,_titleLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_textView]-18-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_textView)]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.textView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self sizeToFit];
}

#pragma mark --- 

-(NSString *)title{
    return self.titleLabel.text;
}
-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
-(NSString *)text{
    return self.textView.text;
}
-(void)setText:(NSString *)text{
    self.textView.text = text;
}
-(void)setFont:(NSInteger)font{
    _font = font;
    self.titleLabel.font = [UIFont systemFontOfSize:font];
    self.textView.font = [UIFont systemFontOfSize:font];
}
-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.textView.textColor = textColor;
}
-(void)setTitleTextColor:(UIColor *)titleTextColor{
    self.titleLabel.textColor = titleTextColor;
}
-(void)setPlaceholder:(NSString *)placeholder{
    self.textView.placeholder = placeholder;
}



@end
