//
//  SecKeyManager.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/21.
//  Copyright © 2019 finger. All rights reserved.
//

#import "SecKeyManager.h"
#import "NSData+AES.h"
#import "RSAHandler.h"
#import "SXRSAEncryptor.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"

@interface SecKeyManager ()
@property (nonatomic, copy) NSString* AESPublicKey;
@end

@implementation SecKeyManager

static SecKeyManager* _sharedInstance = nil;
static NSString* const kAESSalt = @"aodkfie8323409ad";
static NSString* const kRSAPublicKey = @"-----BEGIN PUBLIC KEY-----\nMFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALKE+B17zLNeOF8JzoZIcDeI4aM/d0io\njcEpptBRxr8R1F1nvnYKX8ODa15xhj+omgS3Ltou6q3FSvCmR1impRcCAwEAAQ==\n-----END PUBLIC KEY-----\n";

static NSUInteger const kAESKeyLength = 16;

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SecKeyManager alloc] init];
    });
    return _sharedInstance;
}

- (NSString*)encryptWithRSAFromString:(NSString*)str{
    NSString *encryptedStr = [SXRSAEncryptor encryptString:str publicKey:kRSAPublicKey];
//    NSData *plainData = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *encryptedStr = [RSAHandler encryptWithRSAWithPlainData:plainData publicKey:kRSAPublicKey];
    return encryptedStr;
}

- (NSString *)encryptWithAESFromString:(NSString *)str {
    if (!self.AESPublicKey || !self.AESPublicKey.length) {
        NSLog(@"AES Key不存在！需要重新生成!!");
        self.AESPublicKey = [self generateRandomLetterAndNumberWithCount:kAESKeyLength];
    }
    NSString *salted = [str stringByAppendingString:kAESSalt];
    NSData *data = [salted dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [data AES256EncryptWithKey:self.AESPublicKey];
    return [encryptedData base64EncodedString];
}

- (NSString*)generateEncryptedAESKey {
    NSString *randomStr = [self generateRandomLetterAndNumberWithCount:kAESKeyLength];
    self.AESPublicKey = randomStr;
    NSLog(@"AES public key=%@",self.AESPublicKey);
    return [self encryptWithRSAFromString:randomStr];
}

//返回16位大小写字母和数字
-(NSString *)generateRandomLetterAndNumberWithCount:(NSUInteger)count{
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:count];
    for (int i = 0; i < count; i++)
    {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    
    return result;
}

@end
