//
//  NSObject+MultiParam.h
//  juanpi3
//
//  Created by 彭军 on 16/6/22.
//  Copyright © 2016年 彭军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MultiParam)
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr waitUntilDone:(BOOL)wait withObjects:(id)object1, ...;
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObjects:(NSArray *)objects waitUntilDone:(BOOL)wait;

@end
