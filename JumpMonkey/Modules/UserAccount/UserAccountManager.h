//
//  UserAccountManager.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/13.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccount.h"

@interface UserAccountManager : NSObject

@property (nonatomic, strong) UserAccount *currentAccount;

+ (instancetype)sharedManager;

- (void)autoLogin;

- (void)loginWithAccount:(NSString*)account password:(NSString*)password;

- (void)registerWithAccount:(NSString*)account name:(NSString*)name password:(NSString*)password;

- (void)logout;

//从服务端获取账号最新信息，如积分、昵称等
- (void)getUserInfo;

@end
