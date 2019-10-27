//
//  UserAccount.h
//  JumpMonkey
//
//  Created by 罗谨 on 2019/7/13.
//  Copyright © 2019 finger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelInfo.h"
#import "LifeInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserAccount : NSObject<NSCoding>
@property (nonatomic, assign) NSInteger userId; //唯一ID，后台分配
@property (nonatomic, strong) NSString *account; //用户账号，登录使用
@property (nonatomic, strong) NSString *name; //用户昵称，显示在游戏中
@property (nonatomic, strong) NSString *password; //登录密码
@property (nonatomic, assign) NSInteger scores; //用户得分
@property (nonatomic, strong) LevelInfo *levelInfo; //等级相关信息
@property (nonatomic, strong) LifeInfo *lifeInfo; //生命值相关信息
@end

NS_ASSUME_NONNULL_END
