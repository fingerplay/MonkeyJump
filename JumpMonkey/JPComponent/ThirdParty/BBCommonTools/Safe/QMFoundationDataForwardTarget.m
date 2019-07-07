//
//  QMFoundationDataForwardTarget.m
//  Pods
//
//  Created by Alvin on 2017/7/27.
//
//

#import "QMFoundationDataForwardTarget.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
@interface QMFoundationDataForwardTarget()

@property (nonatomic, strong) NSMutableArray *multForwardTargets;

@end

@implementation QMFoundationDataForwardTarget

- (instancetype)init {
    if (self = [super init]) {
        _multForwardTargets = [NSMutableArray array];
        [_multForwardTargets addObject:[NSArray array]];
        [_multForwardTargets addObject:[NSDictionary dictionary]];
        [_multForwardTargets addObject:[NSString string]];
        [_multForwardTargets addObject:[NSNumber numberWithInt:0]];
        [_multForwardTargets addObject:[NSData data]];
        [_multForwardTargets addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    for (id forwardingTarget in self.multForwardTargets) {
        if ([forwardingTarget respondsToSelector:aSelector]) {
            return forwardingTarget;
        }
    }
    return nil;
}

@end
