//
//  NSString+QMRequest.h
//  juanpi3
//
//  Created by 彭军 on 2017/1/13.
//  Copyright © 2017年 彭军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QMRequest)
//判断请求url是不是包含动态参数
- (BOOL)isDynamicUrl;
/** 返回对self进行32位md5加密的字符串 */
- (NSString *)MD5String;
/**
 *  根据URL生成动态Key
 *  动态key规则生成获取动态URL http://wiki.juanpi.org/pages/viewpage.action?pageId=21636796
 */
- (NSMutableString *)generateDynamicKey;
@end
