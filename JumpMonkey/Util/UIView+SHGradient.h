//
//  UIView+SHGradient.h
//  SHUIKit
//
//  Created by zcl on 2019/5/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SH_GRADIENT_ORIENTATION) {
    SH_GRADIENT_ORIENTATION_LEFT_TO_RIGHT,
    SH_GRADIENT_ORIENTATION_TOP_TO_BOTTOM,
};

@interface UIView (SHGradient)

- (CALayer*)sh_configGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor orientation:(SH_GRADIENT_ORIENTATION)orientation viewRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
