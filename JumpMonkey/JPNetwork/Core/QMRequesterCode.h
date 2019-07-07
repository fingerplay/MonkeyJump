//
//  QMRequesterCode.h
//  juanpi3
//
//  Created by Jay on 16/5/16.
//  Copyright © 2016年 Jay. All rights reserved.
//

#ifndef QMRequesterCode_h
#define QMRequesterCode_h

/** 网络请求默认成功的状态码 */
static NSInteger const kCodeSuccess = 1000;

/** 无默认地址 */
static NSInteger const kCodeNoDefaultAddress = 2001;

/** 没有商品 */
static NSInteger const kCodeEmpty = 2002;

/** 次数已用尽 */
static NSInteger const kCodeSelectOut = 2011;

/** 1.选择不正确  2.收货人地址不正确 */
static NSInteger const kCodeSelectError = 2012;

/** 弹出图形验证码 */
static NSInteger const kCodeImageCode = 2110;

/** (马甲用户/2级黑名单) */
static NSInteger const kCodeVestUser2Error = 2401;

/** (马甲用户/3级黑名单) */
static NSInteger const kCodeVestUser3Error = 2402;

/** 获取sign失败，用户不存在 */
static NSInteger const kCodeUserSignError = 3003;

/** 用户sign错误，不匹配 */
static NSInteger const kCodeUserSignMatchError = 3004;

/** 服务器维护 */
static NSInteger const kCodeServerUnable = 3006;

/** PaySign错误 */
static NSInteger const kCodePaySignError = 3010;

/** 没有数据更新使用本地缓存的数据 */
static NSInteger const kCodeNoNewData = 13001;

#endif /* QMRequesterCode_h */
