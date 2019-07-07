//
//  NSIndexPath+safe.m
//  juanpi3
//
//  Created by Alvin on 2016/12/13.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "NSIndexPath+safe.h"
#import "QMFoundationDataForwardTarget.h"

@implementation NSIndexPath (safe)

+ (instancetype)safeIndexPathForItem:(NSInteger)item inSection:(NSInteger)section
{
    if (item<0) {
        item = 0;
        NSCAssert(NO, @"indexPath item不正常");
    }
    if (section<0) {
        section = 0;
        NSCAssert(NO, @"indexPath section不正常");
    }
    
    return [self indexPathForItem:item inSection:section];
}

+ (instancetype)safeIndexPathForRow:(NSInteger)row inSection:(NSInteger)section
{
    if (row<0) {
        row = 0;
        NSCAssert(NO, @"indexPath row不正常");
    }
    if (section<0) {
        section = 0;
        NSCAssert(NO, @"indexPath section不正常");
    }
    return [self indexPathForRow:row inSection:section];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [[QMFoundationDataForwardTarget alloc] init];
}

@end
