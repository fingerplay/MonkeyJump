//
//  UserAPI.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/13.
//  Copyright © 2019 finger. All rights reserved.
//

#import "UserAPI.h"
#import "SecKeyManager.h"
#import "SCDevice.h"

#pragma mark - Login
@implementation LoginInput

@end

@implementation LoginAPI

- (instancetype)initWithAccountModel:(UserAccount *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (QMInput *)buildInput {
    LoginInput *input = [[LoginInput alloc] init];
    input.account = self.model.account;
    input.password = self.model.password;
    input.key = [[SecKeyManager sharedInstance] generateEncryptedAESKey];
    input.uuid = [SCDevice deviceUUID];
    return input;
}

- (void)configCommand:(QMCommand *)command
{
    command.url = DomainURL(@"user/login");
    command.method = QMRequestMethodPost;
}

- (void)startRequest {
    [super startRequest];
}


- (id)reformJsonData:(id)data {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDict = (NSDictionary *)data;
        UserAccount *account = [UserAccount mj_objectWithKeyValues:dataDict];
        return account;
    }
    
    return nil;
}

@end

#pragma mark - Register
@implementation RegisterInput

@end


@implementation RegisterAPI

- (instancetype)initWithAccountModel:(UserAccount *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (QMInput *)buildInput {
    RegisterInput *input = [[RegisterInput alloc] init];
    input.account = self.model.account;
    input.password = [[SecKeyManager sharedInstance] encryptWithRSAFromString:self.model.password];
    input.name = self.model.name;
    return input;
}

- (void)configCommand:(QMCommand *)command
{
    command.url = DomainURL(@"user/register");
    command.method = QMRequestMethodPost;
}
@end


#pragma mark - UserInfo

@implementation UserInfoInput

@end

@implementation UserInfoAPI


- (QMInput *)buildInput {
    UserInfoInput *input = [[UserInfoInput alloc] init];

    return input;
}

- (void)configCommand:(QMCommand *)command
{
    command.url = DomainURL(@"user/get");
    command.method = QMRequestMethodGet;
}

@end



