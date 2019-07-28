//
//  APIManager.m
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/13.
//  Copyright © 2019 finger. All rights reserved.
//

#import "APIManager.h"
#import "QMRequestManager.h"
#import "UserAccountManager.h"

@interface APIManager ()<QMRequesterDatasource>

@end

static APIManager *_sharedInstance = nil;
@implementation APIManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[APIManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configRequest];
    }
    return self;
}

- (void)configRequest {
    [QMRequestManager sharedManager].datasource = self;
}

#pragma mark - QMRequestManager DataSource
//获取动态参数替换列表
- (NSDictionary *)requesterPublicParamsWithParamType:(QMRequestParamType)paramType {
    return @{@"userId": @([UserAccountManager sharedManager].currentAccount.userId) ?: @(0),
             @"os": @(1)
             };
}
@end
