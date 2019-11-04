//
//  UserAccountManager.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/13.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccount.h"
#import "LifeInfo.h"

typedef void(^UserAccountSuccCallback)(id userInfo);

typedef void(^UserAccountFailCallback)(NSInteger code, NSString *errorInfo);

@interface UserAccountManager : NSObject

@property (nonatomic, strong) UserAccount *currentAccount;
@property (nonatomic, strong) LifeInfo *lifeInfo; //生命值相关信息

+ (instancetype)sharedManager;

- (void)autoLoginWithSuccCallback:(UserAccountSuccCallback)succBlock failCallback:(UserAccountFailCallback)failBlock;

- (void)loginWithAccount:(NSString*)account password:(NSString*)password succCallback:(UserAccountSuccCallback)succBlock failCallback:(UserAccountFailCallback)failBlock;

- (void)registerWithAccount:(NSString*)account name:(NSString*)name password:(NSString*)password succCallback:(UserAccountSuccCallback)succBlock failCallback:(UserAccountFailCallback)failBlock;

- (void)logout;

//从服务端获取账号最新信息，如积分、昵称等
- (void)getUserInfoWithSuccCallback:(UserAccountSuccCallback)succBlock failCallback:(UserAccountFailCallback)failBlock;

- (void)saveLifeInfoAsync;

@end
