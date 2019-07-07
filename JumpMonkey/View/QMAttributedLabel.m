//
//  QMAttributedLabel.m
//  juanpi3
//
//  Created by zhaojun on 15-3-13.
//  Copyright (c) 2015年 zhaojun. All rights reserved.
//

#import "QMAttributedLabel.h"

@interface QMAttributedLabel ()
@end

@implementation QMAttributedLabel


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

#pragma mark - properties
- (void)setHtmlString:(NSString *)htmlString
{
//    htmlString = @"<font color=\"#ff0000\" size=\"10\">cps品牌 主</font>";//测试用
    _htmlString = htmlString;
    if (!_htmlString) {
        _htmlString = @"";
    }
    [self setHTMLText:_htmlString];
}

- (void)setDefaultFont:(UIFont *)defaultFont
{
    _defaultFont = defaultFont;
    self.font = defaultFont;
}

- (void)setDefaultTextColor:(UIColor *)defaultTextColor
{
    _defaultTextColor = defaultTextColor;
    self.textColor = defaultTextColor;
}

@end
