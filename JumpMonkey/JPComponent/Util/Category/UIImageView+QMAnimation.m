//
//  UIImageView+QMAnimation.m
//  juanpi3
//
//  Created by Jay on 15/12/16.
//  Copyright © 2015年 Jay. All rights reserved.
//

#import "UIImageView+QMAnimation.h"

@implementation UIImageView (QMAnimation)

- (void)fadeLayer:(CALayer *)layer {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionFade;
    [layer addAnimation:transition forKey:@"fade"];
}


@end
