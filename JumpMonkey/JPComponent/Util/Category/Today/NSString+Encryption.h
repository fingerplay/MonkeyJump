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

/** 用户名第一位到最后一位中间用星号替换 */
- (NSString *)secureUserNameString;

/**将要添加到URL的字符串进行特殊处理，如果这些字符串含有 !*'();:@&=+$,/?%#[] 这些特殊字符的话，用“%+ASCII”代替*/
- (NSString *)createNewStringByaddingPercentEscapesForSpecialCharater:(NSString *)string;

@end
