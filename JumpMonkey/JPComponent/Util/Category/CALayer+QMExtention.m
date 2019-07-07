//
//  CALayer+QMExtention.m
//  juanpi3
//
//  Created by Alvin on 2016/12/6.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "CALayer+QMExtention.h"
#import "NSObject+swizzle.h"
#import "QMDeviceHelper.h"
@implementation CALayer (QMExtention)

+ (void)load
{
    [self exchangeMethod:@selector(setBorderWidth:) withMethod:@selector(qmSetBorderWidth:)];
}

- (void)qmSetBorderWidth:(CGFloat)borderWidth
{
    if (borderWidth == 0.5 && ScreenSizeIphone6P==ScreenInch()) {
        borderWidth = 0.66;
    }
    [self qmSetBorderWidth:borderWidth];
}

@end
