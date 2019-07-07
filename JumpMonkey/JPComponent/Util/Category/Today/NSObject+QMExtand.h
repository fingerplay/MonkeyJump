//
//  NSObject+QMExtand.h
//  juanpi3
//
//  Created by Jay on 15-4-30.
//  Copyright (c) 2015年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (QMExtand)

/**
 *  返回该类的所有属性,不上溯到父类,
 *  value-key:pronames - @"name"
 *
 *  @return 该类的所有属性
 */
+ (NSDictionary *)extGetPropertys;

/**
 *  返回 该类以及父类的所有属性
 *  value-key:pronames - @"name"
 *
 *  @return 该类以及父类的所有属性
 */
+ (NSDictionary *)extGetPropertysWithSuper:(Class)superClass;


/**
 *  返回该类的属性名称,按从小到大排序,以@"&name=key"连接的字符串
 *
 *  @return 例:@"age=10&height=20&name=jack"
 */
- (NSString *)extGetPropertyNameAndKey;


/**
 *  比较object里面每个属性的值是否相等(NSString)
 *
 *  @return YES|NO
 */
- (BOOL)isEqualStringPropertyToObject:(id)object;
- (BOOL)isEqualStringPropertyToObject:(id)object ignoredKey:(NSString *)ignoredKey;

@end
//
//@interface NSObject(FreeRequestDelegate)
//
///**
// *  释放 网络请求代理
// */
//- (void)freeRequestDelegates;
//
//@end
