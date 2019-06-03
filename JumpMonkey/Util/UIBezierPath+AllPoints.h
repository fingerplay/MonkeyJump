//
//  UIBezierPath+AllPoints.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/6/3.
//  Copyright © 2019 finger. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (AllPoints)

/** 获取所有点*/
- (NSArray *)points;

@end

NS_ASSUME_NONNULL_END
