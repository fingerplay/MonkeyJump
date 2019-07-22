//
//  UserAPI.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/13.
//  Copyright © 2019 finger. All rights reserved.
//

#import "QMRequester.h"
#import "UserAccount.h"

NS_ASSUME_NONNULL_BEGIN
@interface LoginInput : QMInput
@property (nonatomic, copy) NSString *account; //用户账号，登录使用
@property (nonatomic, copy) NSString *password; //登录密码
@property (nonatomic, copy) NSString *key; //本地生成的AES Key

@end


@interface LoginAPI : QMRequester
@property (nonatomic, strong) UserAccount *model;

- (instancetype)initWithAccountModel:(UserAccount*)model;
@end


@interface RegisterInput : QMInput
@property (nonatomic, copy) NSString *account; //用户账号，登录使用
@property (nonatomic, copy) NSString *name; //用户昵称，显示在游戏中
@property (nonatomic, copy) NSString *password; //登录密码
@end

@interface RegisterAPI : QMRequester
@property (nonatomic, strong) UserAccount *model;

- (instancetype)initWithAccountModel:(UserAccount*)model;
@end


@interface UserInfoInput : QMInput

@end

@interface UserInfoAPI : QMRequester

@end
NS_ASSUME_NONNULL_END
