//
//  QMSaveKeyChain.h
//  Jiukuaiyou_2.0
//
//  Created by Brick on 14-4-25.
//  Copyright (c) 2014年 QM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMSaveKeyChain : NSObject

+ (id)load:(NSString *)service;
+ (void)save:(NSString *)service data:(id)data;
+ (void)delete:(NSString *)service;

@end
