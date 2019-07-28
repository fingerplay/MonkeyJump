//
//  RSAHandler.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/28.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pem.h"
#import "rsa.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSAHandler : NSObject

+ (BOOL)generateRSAKeyPairWithKeySize:(int)keySize publicKey:(RSA **)publicKey privateKey:(RSA **)privateKey;

+ (NSData *)decryptWithRSAKey:(RSA *)rsaKey cipherData:(NSData *)cipherData :(BOOL)isPubulic;

+ (NSString *)encryptWithRSAWithPlainData:(NSData *)plainData publicKey:(NSString*)publicKey;

@end

NS_ASSUME_NONNULL_END
