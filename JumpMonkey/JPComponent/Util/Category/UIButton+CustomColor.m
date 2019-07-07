//
//  UIButton+CustomColor.m
//  Jiukuaiyou_2.0
//
//  Created by lee on 14-4-17.
//  Copyright (c) 2014年 QM. All rights reserved.
//

#import "UIButton+CustomColor.h"
#import "UIColor+CustomColor.h"
#import "UIView+Common.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIButton (CustomColor)

+(UIButton *)buttonWithCustomColor:(CustomColorButton )customColorButton frame:(CGRect )frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    switch (customColorButton) {
        case GrayColorButton:
        {
            [btn setBackgroundColor:[UIColor button_grayColor]];
        }
            break;
        case GreenColorButton:
        {
            [btn setBackgroundColor:[UIColor button_greenColor]];
        }
            break;
        case RedColorButton:
        {
            [btn setBackgroundColor:[UIColor button_redColor]];
        }
            break;
        default:
            break;
    }
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:frame.size.height/2]; //设置矩形四个圆角半径
    return btn;
}

+(void)setButtonWithCustomColor:(CustomColorButton )customColorButton button:(UIButton *)button
{
    switch (customColorButton) {
        case GrayColorButton:
        {
            [button setBackgroundColor:[UIColor button_grayColor]];
        }
            break;
        case GreenColorButton:
        {
            [button setBackgroundColor:[UIColor button_greenColor]];
        }
            break;
        case RedColorButton:
        {
            [button setBackgroundColor:[UIColor button_redColor]];
        }
            break;
        default:
            break;
    }
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:button.height/2]; //设置矩形四个圆角半径
}
@end
