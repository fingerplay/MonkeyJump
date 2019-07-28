//
//  UserAccountManager.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/13.
//  Copyright © 2019 finger. All rights reserved.
//

#import "UserAccountManager.h"
#import "UserAPI.h"

@implementation UserAccountManager
@synthesize currentAccount = _currentAccount;

static UserAccountManager *_sharedInstance = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[UserAccountManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadAccountFromFile];
    }
    return self;
}

#pragma mark - Public
- (void)autoLoginWithSuccCallback:(UserAccountSuccCallback)succBlock failCallback:(UserAccountFailCallback)failBlock {
    LoginAPI *api = [[LoginAPI alloc] initWithAccountModel:self.currentAccount];
    [api startRequestWithSuccCallback:^(QMStatus *status, QMInput *input, id output) {
        if (status.code == ERROR_CODE_SUCCESS) {
            NSLog(@"登录成功,output=%@",output);
            if ([output isKindOfClass:[UserAccount class]]) {
                self.currentAccount = output;
            }
            
            if (succBlock) {
                succBlock(output);
            }
        }else {
            NSLog(@"登录失败:%@",status.info);
            if (failBlock) {
                failBlock(status.code, status.info);
            }
        }
    } failCallback:^(QMStatus *status, QMInput *input, NSError *error) {
        NSLog(@"登录失败:%@",error);
        if (failBlock) {
            failBlock(status.code, status.info ?: @"请求超时");
        }
    }];
}

- (void)loginWithAccount:(NSString *)account password:(NSString *)password succCallback:(UserAccountSuccCallback)succBlock failCallback:(UserAccountFailCallback)failBlock {
    UserAccount *user = [[UserAccount alloc] init];
    user.account = account;
    user.password = password;
    LoginAPI *api = [[LoginAPI alloc] initWithAccountModel:user];
    [api startRequestWithSuccCallback:^(QMStatus *status, QMInput *input, id output) {
        if (status.code == ERROR_CODE_SUCCESS) {
            NSLog(@"登录成功,output=%@",output);
            if ([output isKindOfClass:[UserAccount class]]) {
                self.currentAccount = output;
            }
            if (succBlock) {
                succBlock(output);
            }
        }else {
            NSLog(@"登录失败:%@",status.info);
            if (failBlock) {
                failBlock(status.code, status.info);
            }
        }
    } failCallback:^(QMStatus *status, QMInput *input, NSError *error) {
        NSLog(@"登录失败:%@",error);
        if (failBlock) {
            failBlock(status.code, status.info);
        }
    }];
    
}

- (void)registerWithAccount:(NSString *)account name:(NSString *)name password:(NSString *)password succCallback:(UserAccountSuccCallback)succBlock failCallback:(UserAccountFailCallback)failBlock{
    UserAccount *user = [[UserAccount alloc] init];
    user.account = account;
    user.name = name;
    user.password = password;
    RegisterAPI *api = [[RegisterAPI alloc] initWithAccountModel:user];
    [api startRequestWithSuccCallback:^(QMStatus *status, QMInput *input, id output) {
        if (status.code == ERROR_CODE_SUCCESS) {
            NSLog(@"注册成功,output=%@",output);
            if (succBlock) {
                succBlock(output);
            }
        }else {
            NSLog(@"注册失败:%@",status.info);
            if (failBlock) {
                failBlock(status.code, status.info);
            }
        }
    } failCallback:^(QMStatus *status, QMInput *input, NSError *error) {
        NSLog(@"注册失败:%@",error);
        if (failBlock) {
            failBlock(status.code, status.info);
        }
    }];
    
}

- (void)logout {
    
}

- (void)getUserInfoWithSuccCallback:(UserAccountSuccCallback)succBlock failCallback:(UserAccountFailCallback)failBlock {
    UserInfoAPI *api = [[UserInfoAPI alloc] init];
    [api startRequestWithSuccCallback:^(QMStatus *status, QMInput *input, id output) {
        if (status.code == ERROR_CODE_SUCCESS) {
            NSLog(@"获取用户信息成功,output=%@",output);
            if (succBlock) {
                succBlock(output);
            }
        }else {
            NSLog(@"获取用户信息失败,output=%@",output);
            if (failBlock) {
                failBlock(status.code, status.info);
            }
        }

    } failCallback:^(QMStatus *status, QMInput *input, NSError *error) {
        NSLog(@"获取用户信息失败:%@",error);
    }];
}


#pragma mark - Private

- (NSString*)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"userAccount"];
}

- (BOOL)saveAccountToFile {
    BOOL succ = [NSKeyedArchiver archiveRootObject:self.currentAccount toFile:[self filePath]];
    return succ;
}

- (UserAccount*)loadAccountFromFile {
    UserAccount* account = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    return account;
}

#pragma mark - Property
- (UserAccount *)currentAccount {
    if (_currentAccount != nil) {
        return _currentAccount;
    }
    _currentAccount = [self loadAccountFromFile];
    return _currentAccount;
}

- (void)setCurrentAccount:(UserAccount *)currentAccount {
    _currentAccount = currentAccount;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self saveAccountToFile];
    });
}
@end
