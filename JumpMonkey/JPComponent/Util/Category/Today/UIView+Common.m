//
//  UIView+Common.m
//  Juanpi_2.0
//
//  Created by lee on 14-2-18.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import "UIView+Common.h"
#import <objc/runtime.h>

@implementation UIView (Common)

- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}



- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

@end

@implementation UIView(ScreenShot)

- (UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context) {
        [self.layer renderInContext:context];
        UIImage *sharedPic = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return sharedPic;
    }
    UIGraphicsEndImageContext();
    return nil;
}

@end

@implementation UIView(CABaseAnimation)

- (CAAnimation *)moveAnimation:(UIBezierPath *(^)(UIBezierPath *movePath))pathConfig
{
    UIBezierPath *movePath = [[UIBezierPath alloc] init];
    CGPoint fromPoint = self.center;
    [movePath moveToPoint:fromPoint];
    movePath = pathConfig(movePath);
    
    CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.path = movePath.CGPath;
    moveAnimation.removedOnCompletion = NO;
    return moveAnimation;
}

- (CAAnimation *)roteAnimation:(CGFloat)angle
{
    CABasicAnimation * tranformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    tranformAnimation.fromValue = [NSNumber numberWithFloat:0.f];
    tranformAnimation.toValue = [NSNumber numberWithFloat:angle];
    //    tranformAnimation.cumulative = YES;
    tranformAnimation.removedOnCompletion = NO;
    return tranformAnimation;
}

- (CAAnimation *)scaleAnimation:(CGFloat)scale
{
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = @(scale);
    scaleAnimation.removedOnCompletion = NO;
    return scaleAnimation;
}

- (CAAnimation *)opacityAnimation:(CGFloat)alpha
{
    CABasicAnimation * opacityAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:alpha];
    opacityAnimation.removedOnCompletion = NO;
    return opacityAnimation;
}

- (void)addAnimationGroup:(NSArray<CAAnimation *> *)animations duraTime:(CGFloat)duratime completion:(void(^)())completion
{
    CAAnimationGroup *animaGroup = [[CAAnimationGroup alloc]init];
    animaGroup.animations = animations;
    animaGroup.duration = duratime;
    animaGroup.autoreverses = NO;
    animaGroup.removedOnCompletion = NO;
    [self.layer addAnimation:animaGroup forKey:@"AnitionGroup"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duratime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}

@end

@implementation UIView(ControllEvents)

#pragma mark - helpMethods
- (void)tapAction:(UIGestureRecognizer *)gesture
{
    if (self.touchUpInsideHandle) {
        self.touchUpInsideHandle(gesture);
    }
}

#pragma mark - properties
- (void)setTouchUpInsideHandle:(QMViewTouchUpInsideHandle)touchUpInsideHandle
{
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    objc_setAssociatedObject(self,"touchUpInsideHandle", touchUpInsideHandle, OBJC_ASSOCIATION_COPY);
}

- (QMViewTouchUpInsideHandle)touchUpInsideHandle
{
    QMViewTouchUpInsideHandle handle = objc_getAssociatedObject(self, "touchUpInsideHandle");
    return handle;
}

@end

//#ifndef TODAY_EXTENSION
//#import "QMAppUtils.h"
//@implementation UIView(OwnerController)
//
//- (UIViewController*)owerController
//{
//    for (UIView* next = [self superview]; next; next = next.superview) {
//        UIResponder* nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            return (UIViewController*)nextResponder;
//        }
//    }
//    return nil;
//}
//
//- (BOOL)isContainInVisbleVC
//{
//    if (self.owerController != [QMAppUtils currentVisibleVC]) {// 判断是否是 currentVisbleVC的子控制器或者子view
//        UIResponder *respond = [self.owerController nextResponder];
//        BOOL contained = NO;
//        while (respond) {
//            if ([respond isKindOfClass:[UIViewController class]]) {
//                UIViewController *ctl = (UIViewController *)respond;
//                if (ctl == [QMAppUtils currentVisibleVC]) {
//                    contained = YES;
//                    break;
//                }
//            }
//            respond = [respond nextResponder];
//        }
//        return contained;
//    }
//    return YES;
//}
//
//- (BOOL)isVisible
//{
//    if (!self.isContainInVisbleVC) {
//        return NO;
//    }
//
//    UIResponder *nextRespond = [self.owerController nextResponder];
//    CGRect rect = [self.superview convertRect:self.frame toView:self.owerController.view];
//    // 处理包含于scrollView情况
//    if ([nextRespond isKindOfClass:[UIScrollView class]]) {
//        UIScrollView *superScroll = (UIScrollView *)nextRespond;
//        rect.origin.x += superScroll.contentOffset.x;
//    }
//    BOOL visible = CGRectIntersectsRect(self.owerController.view.frame,rect) || CGRectContainsRect(self.owerController.view.frame,rect);
//    return visible;
//}
//
//@end
//
//#endif
