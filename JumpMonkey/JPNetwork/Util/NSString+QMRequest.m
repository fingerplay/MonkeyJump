//
//  NSString+QMRequest.m
//  juanpi3
//
//  Created by 彭军 on 2017/1/13.
//  Copyright © 2017年 彭军. All rights reserved.
//

#import "NSString+QMRequest.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (QMRequest)
//判断请求url是不是包含动态参数
- (BOOL)isDynamicUrl {
    if (![self isKindOfClass:[NSString class]] || self.length <= 0) {
        return NO;
    }
    
    NSString* decodedUrl = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (!decodedUrl || decodedUrl.length<= 0) {
        return NO;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\$\\{.*\\}" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:decodedUrl options:NSMatchingReportCompletion range:NSMakeRange(0, decodedUrl.length)];
    return range.location != NSNotFound;
}

- (NSString *)MD5String {
    const char *str = [self UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *encryptString = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                               r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return encryptString;
}

-(NSMutableString *)generateDynamicKey{
    
    NSMutableString *dynamicKey = nil;
    
    if ([self isKindOfClass:[NSString class]] && self.length) {
        
        NSString *requestUrl;
        if ([self rangeOfString:@"?"].location!=NSNotFound) {
            requestUrl = [[self componentsSeparatedByString:@"?"] objectAtIndex:0];
        }else{
            requestUrl = self;
        }
        
        NSURL *commandUrl = [NSURL URLWithString:requestUrl];
        
        if (commandUrl) {
            NSString *suffix  = [commandUrl.path stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            dynamicKey = [[NSMutableString alloc] initWithCapacity:3];
            [dynamicKey appendString:@"qimi"];
            
            NSString *host = commandUrl.host;
            NSArray *hostParam  = [host componentsSeparatedByString:@"."];
            if (hostParam && [hostParam count]>0) {
                [dynamicKey appendString:[hostParam objectAtIndex:0]];
            }
            if (suffix.length) {
                [dynamicKey appendString:suffix];
            }
            
        }
    }
    return dynamicKey;
}

@end
