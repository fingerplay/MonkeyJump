//
//  UIView+SHGradient.m
//  SHUIKit
//
//  Created by zcl on 2019/5/15.
//

#import "UIView+SHGradient.h"

@implementation UIView (SHGradient)

- (CALayer*)sh_configGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor orientation:(SH_GRADIENT_ORIENTATION)orientation viewRect:(CGRect)rect {
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.frame = rect;
    //存放渐变的颜色的数组
    layer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    //起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
    switch (orientation) {
        case SH_GRADIENT_ORIENTATION_TOP_TO_BOTTOM:
            layer.startPoint = CGPointMake(0.0, 0.0);
            layer.endPoint = CGPointMake(0.0, 1);
            break;
        case SH_GRADIENT_ORIENTATION_LEFT_TO_RIGHT:
            layer.startPoint = CGPointMake(0.0, 0.0);
            layer.endPoint = CGPointMake(1, 0.0);
            break;
        default:
            break;
    }
    return layer;
}

@end
