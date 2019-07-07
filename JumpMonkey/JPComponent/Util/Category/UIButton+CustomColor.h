//
//  UIButton+CustomColor.h
//  Jiukuaiyou_2.0
//  颜色button
//  Created by lee on 14-4-17.
//  Copyright (c) 2014年 QM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CustomColor)

typedef enum{
    GrayColorButton = 0,
    GreenColorButton,
    WhiteColorButton,
    RedColorButton
}CustomColorButton;

+(UIButton *)buttonWithCustomColor:(CustomColorButton )customColorButton frame:(CGRect )frame;

+(void)setButtonWithCustomColor:(CustomColorButton )customColorButton button:(UIButton *)button;
@end
