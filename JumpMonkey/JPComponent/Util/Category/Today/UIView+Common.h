//
//  UIView+Common.h
//  Juanpi_2.0
//
//  Created by lee on 14-2-18.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//


/**
 
 View类扩展
 
 **/

#import <UIKit/UIKit.h>

@interface UIView (Common)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;


@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGFloat centerX;

@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;


@end

@interface UIView(ScreenShot)

- (UIImage *)convertViewToImage;

@end

@interface UIView(CABaseAnimation)

// to add an animate,use : self.layer addAnimation:[self move...]
// use addAnimationGroup to add animations

/** Config example:
 * CGPoint toPoint = CGPointMake(x, y); // must
 * [movePath addQuadCurveToPoint:toPoint controlPoint:CGPointMake(x, y)];// carve
 * [movePath addLineToPoint] // Line
 * des: config the toPoint
 */
- (CAAnimation *)moveAnimation:(UIBezierPath *(^)(UIBezierPath *movePath))pathConfig;
- (CAAnimation *)roteAnimation:(CGFloat)angle;
- (CAAnimation *)scaleAnimation:(CGFloat)scale;
- (CAAnimation *)opacityAnimation:(CGFloat)alpha;

- (void)addAnimationGroup:(NSArray<CAAnimation *> *)animations duraTime:(CGFloat)duratime completion:(void(^)())completion;

@end

typedef void (^QMViewTouchUpInsideHandle)(UIGestureRecognizer *gesture);

@interface UIView(ControllEvents)

@property (nonatomic, copy) QMViewTouchUpInsideHandle touchUpInsideHandle;

- (void)setTouchUpInsideHandle:(QMViewTouchUpInsideHandle)touchUpInsideHandle;

@end

//@interface UIView(OwnerController)
///** 视图所在的视图控制器*/
//@property (nonatomic, weak, readonly) UIViewController *owerController;
///** 视图是否在可见的控制器中*/
//@property (nonatomic, assign, readonly) BOOL isContainInVisbleVC;
///** 当前视图是否处于可见区域*/
//@property (nonatomic, assign, readonly) BOOL isVisible;
//
//@end
