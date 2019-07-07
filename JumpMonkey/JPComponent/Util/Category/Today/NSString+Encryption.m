//
//  NSString+Encryption.m
//  juanpi3
//
//  Created by zagger on 15/7/28.
//  Copyright © 2015年 zagger. All rights reserved.
//

#import "NSString+Encryption.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Encryption)

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

- (NSString *)secureMobileString {
    if (self.length >= 7) {
        NSString *secureMobile = [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return secureMobile;
    } else if(self.length > 3){
        NSInteger maskLength = self.length - 3;
        NSString *maskStr = @"";
        for (int i =0; i<maskLength; i++) {
            maskStr = [maskStr stringByAppendingString:@"*"];
        }
        NSString *secureMobile = [self stringByReplacingCharactersInRange:NSMakeRange(3, maskLength) withString:maskStr];
        return secureMobile;
    } else {
        return self;
    }
}

- (NSString *)secureIDCardString {
    if (self.length == 18) {
        NSString *secureIDCard = [self stringByReplacingCharactersInRange:NSMakeRange(6, 9) withString:@"*********"];
        return secureIDCard;
    } else {
        return self;
    }
}

- (NSString *)secureUserNameString {
    NSString *secureUserName;
    if (self.length <= 1) {
        return self;
    } else if (self.length == 2) {
        secureUserName = [self stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
        return secureUserName;
    } else {
        secureUserName = [self substringToIndex:1];
        for (int i = 1; i < self.length - 1; i++) {
            secureUserName = [secureUserName stringByAppendingString:@"*"];
        }
        secureUserName = [secureUserName stringByAppendingString:[self substringFromIndex:self.length - 1]];
        return secureUserName;
    }
}


- (NSString *)createNewStringByaddingPercentEscapesForSpecialCharater:(NSString *)string {
    
    if (!string && string.length <= 0) {
        return @"";
    }
    
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, (CFStringRef)@"?!@#$^&%*+,:;='\"`<>()[]{}/\\|", kCFStringEncodingUTF8));


    return outputStr;
}

@end
