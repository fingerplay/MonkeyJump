//
//  Bezier.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/4.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BezierPoint : NSObject
@property (nonatomic, assign) CGFloat xx;
@property (nonatomic, assign) CGFloat yy;
@property (nonatomic, assign) CGFloat angle;
@end

@interface Bezier : NSObject

-(CGFloat)initWithp0:(CGPoint)p0 p1:(CGPoint)p1 p2:(CGPoint)p2 speed:(CGFloat)speed;

-(BezierPoint*)getAnchorPoint:(NSInteger)nIndex;
@end

NS_ASSUME_NONNULL_END
