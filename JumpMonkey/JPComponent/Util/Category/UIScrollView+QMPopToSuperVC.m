//
//  UIScrollView+QMPopToSuperVC.m
//  juanpi3
//
//  Created by Alvin on 16/4/19.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "UIScrollView+QMPopToSuperVC.h"
#import "QMRuntimeHelper.h"
@implementation UIScrollView (QMPopToSuperVC)

- (void)pan:(UIPanGestureRecognizer *)recoginzer
{
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication] keyWindow]];
    if (recoginzer.state == UIGestureRecognizerStateBegan){
        self.startPoint = NSStringFromCGPoint(touchPoint);
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        CGPoint stars = CGPointFromString(self.startPoint);
        if (fabs(touchPoint.y-stars.y) < 60){
            if (fabs(touchPoint.x - stars.x) > 40) {
                if (touchPoint.x - stars.x > 0) {
                    if (self.horizonBlock) {
                        self.horizonBlock(QMHorizonDragDirectionRight);
                    }
                }else{
                    if (self.horizonBlock) {
                        self.horizonBlock(QMHorizonDragDirectionLeft);
                    }
                }
            }
            
        }
    }
}

#pragma mark - Property
- (void)setHorizonBlock:(QMHorizontalDragHandle)horizonBlock
{
    [self.panGestureRecognizer addTarget:self action:@selector(pan:)];
    objc_setAssociatedObject(self, "horizonBlock", horizonBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (QMHorizontalDragHandle)horizonBlock
{
    return objc_getAssociatedObject(self, "horizonBlock");
}

- (void)setStartPoint:(NSString *)startPoint
{
    objc_setAssociatedObject(self, "startPointValue", startPoint, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)startPoint
{
    NSString *spString = objc_getAssociatedObject(self, "startPointValue");
    if (!spString) {
        spString = NSStringFromCGPoint(CGPointZero);
        objc_setAssociatedObject(self, "startPointValue", spString, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return spString;
}

@end
