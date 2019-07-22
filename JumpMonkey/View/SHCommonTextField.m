//
//  SHCommonTextField.m
//  TestTextFieldDemo
//
//  Created by zhenwenl on 2017/7/28.
//  Copyright © 2017年 zhenwenl. All rights reserved.
//

#import "SHCommonTextField.h"
#import <QuartzCore/QuartzCore.h>
//#import "UIColor+ColorConvert.h"
//#import "SHUIModuleDefine.h"
#import <Masonry/Masonry.h>


#define DEFAULT_TEXTFIELD_TEXTCOLOR     [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0]
#define DEFAULT_TEXTFIELD_PADDING       12.0f
#define DEFAULT_TEXTFIELD_OFFSET        8.0f
#define DEFAULT_TEXTFIELD_CORNERRADIUS  5.0f



static NSString * const kAlpaAndNumberSet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ12345678990";

@interface SHCommonTextField()

//@property (strong, nonatomic) UIButton *toggle;
@property (assign, nonatomic) CGSize visibleImgSize;

@end

@implementation SHCommonTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    
    return self;
}

// Actually, most of these properties can be set individually in case of unique requirement
- (void)initialize {
    self.font = font(14);
    self.borderStyle = UITextBorderStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    self.clearsOnBeginEditing = NO;
    if (!self.isPasswordPattern) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }else{
        self.clearButtonMode = UITextFieldViewModeNever;
    }
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tintColor = [UIColor blueColor];
    
    _toggle = [UIButton new];
    [_toggle setImage:[UIImage imageNamed:@"SHUIKit_icn_invisible"] forState:UIControlStateNormal];
    [_toggle setImage:[UIImage imageNamed:@"SHUIKit_icn_visible"] forState:UIControlStateSelected];
    
    _canPaste = YES;
    _canSelect= YES;
    _canSelectAll = YES;
    _maxLength = _minLength = 0;
    //    _visibleImgSize = CGSizeZero;
    _isOnlyAlpaAndNum = NO;
    
    _leftText = @"";
    _leftTextFont = [UIFont systemFontOfSize:18];
    _leftTextColor = [UIColor whiteColor];
    _isPasswordPattern = NO;
    
    //设置placeholder字体大小
    [self setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    self.delegate = self;
    [self addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - action

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ((action == @selector(paste:)) && !_canPaste) {
        return NO;
    }
    if ((action == @selector(select:)) && !_canSelect) {
        return NO;
    }
    if ((action == @selector(selectAll:)) && !_canSelectAll) {
        return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //小于最小长度
    if ((textField.text.length <= self.minLength) && self.minLength) {
        if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldShouldReturn:)]) {
            [_realDelegate limitedTextFieldShouldReturn:textField];
        }
        return NO;
    }
    
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldShouldReturn:)]) {
        return [_realDelegate limitedTextFieldShouldReturn:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldDidEndEditing:)]) {
        [_realDelegate limitedTextFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //超过最大长度
    if ((textField.text.length >= self.maxLength) && self.maxLength && ![string isEqualToString:@""]) {
        if ([_realDelegate respondsToSelector:@selector(tipText:)]) {
            [self showTipsViewWithText:[_realDelegate tipText:textField]];
        }
        return NO;
    }
    if (_isOnlyAlpaAndNum) { //如果只允许输入英文字母和数字
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlpaAndNumberSet] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    
    return YES;
}

- (void)textfieldDidChange:(UITextField *)textField {
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldDidChange:)]) {
        [_realDelegate limitedTextFieldDidChange:textField];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _toggle.hidden = !textField.isEditing;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(limitedTextFieldShouldBeginEditing:)]) {
        [_realDelegate limitedTextFieldShouldBeginEditing:textField];
    }
    return YES;
}

#pragma mark - overrides

/* 修改文本展示区域，一般跟editingRectForBounds一起重写 */
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGFloat widthLeft = self.leftView.frame.size.width;
    CGFloat widthRight = _visibleImgSize.width + 5;
    
    CGRect inset = CGRectMake(widthLeft+DEFAULT_TEXTFIELD_PADDING,
                              bounds.origin.y,
                              bounds.size.width-widthLeft-widthRight-DEFAULT_TEXTFIELD_PADDING*2-5,
                              bounds.size.height);
    return inset;
}

/* 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变 */
-(CGRect)editingRectForBounds:(CGRect)bounds {
    CGFloat widthLeft = self.leftView.frame.size.width;
    CGFloat widthRight = self.rightView.frame.size.width;
    widthRight = _visibleImgSize.width + 5;

    CGRect inset = CGRectMake(widthLeft+DEFAULT_TEXTFIELD_PADDING,
                              bounds.origin.y,
                              bounds.size.width-widthLeft-widthRight-DEFAULT_TEXTFIELD_PADDING*2-15,
                              bounds.size.height);
    return inset;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGFloat widthLeft = self.leftView.frame.size.width;
    return CGRectMake(0, 0, widthLeft, bounds.size.height);
}

//文本框 清除按钮 的 位置 及 显示范围
- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect rect = [super clearButtonRectForBounds:bounds];
    CGFloat clearBtnOffset = 0 - self.toggle.frame.size.width + 5;
    return  CGRectOffset(rect, clearBtnOffset, 0);
}

#pragma mark - inner interface

/* 获取图案大小 */
- (CGSize)sizeWithImage:(UIImage *)image {
    if (image) {
        return image.size;
    }
    return CGSizeZero;
}

/* 获取文字大小 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font {
    CGSize textSize;
    
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        titleParagraphStyle.lineBreakMode = NSLineBreakByClipping;
        
        textSize = [text boundingRectWithSize:CGSizeMake(self.frame.size.width, 99999.0)
                                      options:kNilOptions
                                   attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:titleParagraphStyle}
                                      context:nil].size;
        return textSize;
    }
    return CGSizeZero;
}

/* 点击眼睛图案 */
- (void)clickEyePassword:(UIButton *)button {
    button.selected = !button.isSelected;
    self.secureTextEntry = !button.selected;
    //更新光标位置。
    NSString* text = self.text;
    self.text = @" ";
    self.text = text;
}

#pragma mark - Getters & Setters

- (void)setLeftText:(NSString *)shLeftText {
    _leftText = shLeftText;
}

- (void)setLeftTextColor:(UIColor *)shLeftTextColor {
    _leftTextColor = shLeftTextColor;
}

- (void)setLeftTextFont:(UIFont *)shLeftTextFont {
    _leftTextFont = shLeftTextFont;
}

- (void)setCanPaste:(BOOL)canPaste{
    _canPaste = canPaste;
}

- (void)setLeftImage:(UIImage *)shLeftImage {
    _leftImage = shLeftImage;
    UIView *leftView;
    if (!shLeftImage) {
        if (_leftText && _leftText.length > 0) {
            CGSize textSize = [self sizeWithText:_leftText font:_leftTextFont];
            UILabel *leftLabel = [[UILabel alloc] init];
            leftLabel.text = _leftText;
            leftLabel.textColor = _leftTextColor;
            leftLabel.font = _leftTextFont;
            leftLabel.frame = CGRectMake(DEFAULT_TEXTFIELD_PADDING, 0, textSize.width, self.frame.size.height);
            
            leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(leftLabel.frame), self.frame.size.height)];
            [leftView addSubview:leftLabel];
        } else {
            leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_TEXTFIELD_PADDING, self.frame.size.height)];
        }
        
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
    } else {
        CGSize imgSize = [self sizeWithImage:shLeftImage];
        UIImageView *leftImg = [[UIImageView alloc] initWithImage:shLeftImage];
        leftImg.contentMode = UIViewContentModeCenter;
        leftImg.frame = CGRectMake(DEFAULT_TEXTFIELD_PADDING, (self.frame.size.height - imgSize.height) / 2, imgSize.width, imgSize.height);
        
        if (_leftText && _leftText.length > 0) {
            CGSize textSize = [self sizeWithText:_leftText font:_leftTextFont];
            UILabel *leftLabel = [[UILabel alloc] init];
            leftLabel.text = _leftText;
            leftLabel.textColor = _leftTextColor;
            leftLabel.font = _leftTextFont;
            leftLabel.frame = CGRectMake(CGRectGetMaxX(leftImg.frame)+DEFAULT_TEXTFIELD_PADDING, 0, textSize.width, self.frame.size.height);
            
            leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(leftLabel.frame), self.frame.size.height)];
            [leftView addSubview:leftImg];
            [leftView addSubview:leftLabel];
        } else {
            leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(leftImg.frame), self.frame.size.height)];
            [leftView addSubview:leftImg];
        }
        
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    
    [self setNeedsDisplay];
}

#pragma mark - outter interface
- (void)hiddenVisibleBtn{
    self.rightView = nil;
    self.rightViewMode = UITextFieldViewModeNever;
    [self setNeedsDisplay];
}

- (void)showVisibleBtn{
    
    if (_toggle) {
        [_toggle removeFromSuperview];
    }
    //    _visibleImgSize = [self sizeWithImage:[UIImage imageNamed:@"icn_visible"]];
    _visibleImgSize = CGSizeMake(32, 32);
    
//    self.rightView = _toggle;
    [self addSubview:_toggle];
    [_toggle addTarget:self action:@selector(clickEyePassword:) forControlEvents:UIControlEventTouchUpInside];
    [_toggle sizeToFit];
    
    _toggle.hidden = !self.isEditing;
    _toggle.tag = 100;
    _toggle.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_toggle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.mas_equalTo(self.visibleImgSize.width + 10);
        make.height.mas_equalTo(self);
//        make.left.mas_equalTo(self.mas_right);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    self.rightViewMode = UITextFieldViewModeAlways;
    [self setNeedsDisplay];
}

- (void)showTipsViewWithText:(NSString *)tipsText{
    if (tipsText) {
        if (_tipsLabel) {
            [_tipsLabel removeFromSuperview];
        }
        _tipsLabel = [UILabel new];
        _tipsLabel.text = tipsText;
        [self.superview addSubview:_tipsLabel];
        _tipsLabel.font = font(14);
        _tipsLabel.textColor = [UIColor redColor];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        __weak typeof(self) weakSelf = self;
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.tipsLabelTopFloat) {
                make.top.mas_equalTo(CGRectGetMaxY(self.frame) + weakSelf.tipsLabelTopFloat);
            } else {
                make.top.mas_equalTo(CGRectGetMaxY(self.frame) + 22);
            }
            make.height.mas_equalTo(14.0f);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];
        
    }
}

- (void)showTipsViewWithTextSub:(NSString *)tipsText{
    if (tipsText) {
        if (_tipsLabel) {
            [_tipsLabel removeFromSuperview];
        }
        _tipsLabel = [UILabel new];
        _tipsLabel.text = tipsText;
        [self addSubview:_tipsLabel];
        _tipsLabel.font = font(14);
        _tipsLabel.textColor = [UIColor redColor];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.frame.size.height + self.tipsLabelTopFloat);
            make.height.mas_equalTo(14.0f);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];
        
    }
}

- (void)shakeWithTipText:(NSString *)tipText withAnimation:(BOOL)animation{
    self.layer.borderColor = [UIColor redColor].CGColor;
    
    //TextView晃动
    if (animation) {
        CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        CGFloat currentTx = self.transform.tx;
        
        shakeAnimation.duration = 0.5;
        shakeAnimation.values = @[ @(currentTx), @(currentTx + 10), @(currentTx-8), @(currentTx + 8), @(currentTx -5), @(currentTx + 5), @(currentTx) ];
        shakeAnimation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1) ];
        shakeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.layer addAnimation:shakeAnimation forKey:@"kAFViewShakerAnimationKey"];
    }
    
    //提示框
    if (tipText) {
        [self showTipsViewWithText:tipText];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}


@end
