//
/*	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
*/
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//
//
//  NSObject+BeeNotification.m
//

#import "NSObject+BeeNotification.h"
#import <objc/runtime.h>
#import "NSMutableDictionary+safe.h"
#pragma mark -

@implementation NSNotification(BeeNotification)

- (BOOL)is:(NSString *)name
{
	return [self.name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
	return [self.name hasPrefix:prefix];
}

@end

#pragma mark -

@interface NSObject(BeeNotificationPrivate)

@property (nonatomic, strong) NSMutableDictionary *blocks;
- (void)handleNSNotification:(NSNotification *)n;

@end

@implementation NSObject(BeeNotification)

+ (NSString *)NOTIFICATION
{
	return [NSString stringWithFormat:@"notify.%@.", [self description]];
}

- (void)handleNotification:(NSNotification *)notification
{
}

- (void)observeNotification:(NSString *)name
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleNotification:)
												 name:name
											   object:nil];
}

- (void)observeNotification:(NSString *)name notifyHandle:(void (^)(NSNotification *notice))block
{
    if (!self.blocks) {
        self.blocks = [NSMutableDictionary dictionary];
    }
    [self.blocks setObject:block forKey:name];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(blockHandleEvent:)
                                                 name:name
                                               object:nil];
}

- (void)blockHandleEvent:(NSNotification *)notice
{
    void (^notifyBlock)(NSNotification *) = [self.blocks objectForKey:notice.name];
    if (notifyBlock) {
        notifyBlock(notice);
    }
}

- (void)unobserveNotification:(NSString *)name
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:name
												  object:nil];
    if (self.blocks) {
        [self.blocks safeRemoveObjectForKey:name];
    }
}

- (void)unobserveAllNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.blocks) {
        [self.blocks removeAllObjects];
    }
}

- (BOOL)postNotification:(NSString *)name
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    });
	
	return YES;
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    });
	
	return YES;
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object withUserInfo:(NSDictionary *)useInfo {
    if (![useInfo isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:useInfo];
    });
    return YES;
}


- (NSMutableDictionary *)blocks
{
    return  objc_getAssociatedObject(self, "blocks");
}

- (void)setBlocks:(NSMutableDictionary *)blocks
{
    objc_setAssociatedObject(self, "blocks", blocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
