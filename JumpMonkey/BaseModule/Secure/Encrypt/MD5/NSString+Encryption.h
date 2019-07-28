//
//  NSString+Encryption.h
//  juanpi3
//
//  Created by zagger on 15/7/28.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encryption)

/** 返回对self进行32位md5加密的字符串 */
- (NSString *)MD5String;


/** 返回从第4位开始连续4位以星号代替的电话号码 */
- (NSString *)secureMobileString;

/** 返回从第7位开始连续9位以星号代替的身份证号 */
- (NSString *)secureIDCardString;

@end
