//
//  QMAttributedLabel.h
//  juanpi3
//
//  Created by zhaojun on 15-3-13.
//  Copyright (c) 2015年 zhaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+htmlText.h"

@interface QMAttributedLabel : UILabel
{
    NSString *_htmlString;
}

/** 设置html，直接显示在label上 */
@property (nonatomic, strong) NSString *htmlString;

/** 默认字体大小 */
@property (nonatomic, strong) UIFont *defaultFont;

/** 默认字体颜色 */
@property (nonatomic, strong) UIColor *defaultTextColor;

@end
