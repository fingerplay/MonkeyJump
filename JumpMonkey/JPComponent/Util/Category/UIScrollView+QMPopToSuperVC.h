//
//  UIScrollView+QMPopToSuperVC.h
//  juanpi3
//
//  Created by Alvin on 16/4/19.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef NS_OPTIONS(NSInteger, QMHorizonDragDirection) {
    /** 手指从右向左拖拽 */
    QMHorizonDragDirectionLeft = 1 << 0,
    /** 手指从左向右拖拽 */
    QMHorizonDragDirectionRight = 1 << 1
};

typedef void(^QMHorizontalDragHandle)(QMHorizonDragDirection direction);

@interface UIScrollView (QMPopToSuperVC)

@property (nonatomic, copy) QMHorizontalDragHandle horizonBlock;
@property (nonatomic, copy, readonly) NSString *startPoint;

@end
