//
//  SecKeyManager.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/21.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecKeyManager : NSObject

+ (instancetype)sharedInstance;

- (NSString*)encryptWithRSAFromString:(NSString*)str;

- (NSString*)encryptWithAESFromString:(NSString*)str;

- (NSString*)generateEncryptedAESKey;

@end

NS_ASSUME_NONNULL_END
