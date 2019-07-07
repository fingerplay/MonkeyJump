//
//  UITextField+QMSecure.m
//  juanpi3
//
//  Created by 罗谨 on 16/3/21.
//  Copyright © 2016年 罗谨. All rights reserved.
//

#import "UITextField+QMSecure.h"
#import <objc/runtime.h>
@implementation UITextField (QMSecure)

- (void)setRealText:(NSString *)realText {
    if (realText) {
        objc_setAssociatedObject(self, "realText", realText, OBJC_ASSOCIATION_RETAIN);
    }
}

- (NSString *)realText {
    return objc_getAssociatedObject(self, "realText");
}

@end
