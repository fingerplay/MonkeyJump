//
//  NSDate+QMExtand.h
//  Juanpi_2.0
//
//  Created by Brick on 14-3-3.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (QMExtand)
    
-(BOOL)isToday;

+ (BOOL)isTheSameDayBetween:(NSDate *)date and:(NSDate *)lastDate;

+ (BOOL)isTheSameTimeBetween:(NSDate *)date and:(NSDate *)lastDate;

//获取当天的某个指定时间
+ (NSDate *)getTimeOfTodayWithInterval:(double)time;

+ (NSDate *)getTimeOfTodayWithNSDate:(NSDate *)todayZeroDate Interval:(double)time;

//获取指定日期的零点时间
+ (NSDate *)getTheZeroTime:(NSDate *)date;

+ (NSDate *)getNextDayNotifyTime;

/**
 * 项目中label显示为今日，明日或者后日的视图
 *
 * @param startTime 商品的开抢时间
 *
 * @param currentTime 当前的时间
 *
 * @return label的字符串
 */
+ (NSString *)timeTextFromStartTime:(NSTimeInterval)startTime CurTime:(long long)currentTime;
@end
