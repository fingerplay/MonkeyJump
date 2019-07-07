//
//  NSDate+QMExtand.m
//  Juanpi_2.0
//
//  Created by Brick on 14-3-3.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import "NSDate+QMExtand.h"
#import "NSDateFormatter+QMHelper.h"

@implementation NSDate (QMExtand)

    
-(BOOL)isToday{
    
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [NSDateFormatter dateFormatterWithFormatString:@"yyyy-MM-dd"];
    NSString * dateString = [formatter stringFromDate:date];
    
    formatter = [NSDateFormatter dateFormatterWithFormatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString * todayString = [NSString stringWithFormat:@"%@ 00:00:00",dateString];
    NSDate * today = [formatter dateFromString:todayString];
    
    NSDate * todayEnd = [today dateByAddingTimeInterval:60*60*24];
    
    if ([self compare:today]!=NSOrderedAscending&&[self compare:todayEnd]==NSOrderedAscending) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isTheSameDayBetween:(NSDate *)date and:(NSDate *)lastDate
{
    //判断是否是同一天
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];

    NSInteger day = [components day];
    NSInteger month= [components month];
    NSInteger year= [components year];

    NSDateComponents *lastComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:lastDate];

    NSInteger lastDay = [lastComponents day];
    NSInteger lastMonth= [lastComponents month];
    NSInteger lastYear= [lastComponents year];
    if ((day == lastDay)&&(month == lastMonth) &&(year == lastYear)) {
        return YES;
    }
    return NO;
}

+ (BOOL)isTheSameTimeBetween:(NSDate *)date and:(NSDate *)lastDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSString *lastDateStr = [dateFormatter stringFromDate:lastDate];

    if ([dateStr isEqualToString:lastDateStr]) {
        return YES;
    }
    return NO;
}

//获取当天的某个指定时间
+ (NSDate *)getTimeOfTodayWithInterval:(double)time
{
    NSDate *settingDate = [NSDate getTheZeroTime:[NSDate date]];
    NSDate *tomorrowDate = [settingDate dateByAddingTimeInterval:time];
    
    return tomorrowDate;
}

+ (NSDate *)getTimeOfTodayWithNSDate:(NSDate *)todayZeroDate Interval:(double)time
{
    NSDate *tomorrowDate = [todayZeroDate dateByAddingTimeInterval:time];
    return tomorrowDate;
}

//获取指定日期的零点时间
+ (NSDate *)getTheZeroTime:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    NSInteger day = [components day];
    NSInteger month= [components month];
    NSInteger year= [components year];
    
    NSString *settingTime = [NSString stringWithFormat:@"%ld-%ld-%ld 00:00:00",(long)year,(long)month,(long)day];
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterWithFormatString:@"yyyy-MM-dd HH:mm:ss"];

    formatter.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDate *settingDate = [formatter dateFromString:settingTime];
    
    return settingDate;
}

//获取明天的通知时间
+ (NSDate *)getNextDayNotifyTime
{

    NSDate *settingDate = [NSDate getTheZeroTime:[NSDate date]];
    
#ifdef APP_JP
    //返回明天的19：59：00
    NSDate *tomorrowDate = [settingDate dateByAddingTimeInterval:((24.0+20.0)*3600-60)];
#elif APP_JKY
    //返回明天的19:00:00
    NSDate *tomorrowDate = [settingDate dateByAddingTimeInterval:((24.0+19.0)*3600)];
#elif APP_JPHD
    //返回明天的19：59：00
    NSDate *tomorrowDate = [settingDate dateByAddingTimeInterval:((24.0+20.0)*3600-60)];
#elif APP_JKYHD
    //返回明天的19:00:00
    NSDate *tomorrowDate = [settingDate dateByAddingTimeInterval:((24.0+19.0)*3600)];
#else 
    NSDate *tomorrowDate = [settingDate dateByAddingTimeInterval:((24.0+20.0)*3600-60)];
#endif
    return tomorrowDate;
}

+ (NSString *)timeTextFromStartTime:(NSTimeInterval)startTime CurTime:(long long)currentTime
{
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormatString:@"dd"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:startTime];
//    NSString *startDateString = [dateFormatter stringFromDate:date];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc]initWithTimeIntervalSince1970:currentTime];
    
    NSDate *tomorrow, *dayAfterTomorrow;
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    dayAfterTomorrow = [tomorrow dateByAddingTimeInterval:secondsPerDay];
    
    NSString *startDayStr = [[[self convertDateToLocalTime:date] description] substringToIndex:10];
    NSString *todayStr = [[[self convertDateToLocalTime:today] description] substringToIndex:10];
    NSString *tomorrowStr = [[[self convertDateToLocalTime:tomorrow] description] substringToIndex:10];
    NSString *dayAfterTomorrowStr = [[[self convertDateToLocalTime:dayAfterTomorrow] description] substringToIndex:10];
    
//    NSString *nowDateString = [dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:currentTime]];
    NSString *preStr = @"";
    NSString *dateFormatterStr = @"HH:mm";
    
    if ([startDayStr isEqualToString:todayStr]) {
        preStr = @"今日";
        [dateFormatter setDateFormat:dateFormatterStr];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        return [NSString stringWithFormat:@"%@%@开抢", preStr, destDateString];
    }
    else if ([startDayStr isEqualToString:tomorrowStr]) {
        preStr = @"明日";
        [dateFormatter setDateFormat:dateFormatterStr];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        return [NSString stringWithFormat:@"%@%@开抢", preStr, destDateString];
    }
    else if ([startDayStr isEqualToString:dayAfterTomorrowStr]) {
        preStr = @"后日";
        [dateFormatter setDateFormat:dateFormatterStr];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        return [NSString stringWithFormat:@"%@%@开抢", preStr, destDateString];
    }
    else  {
        [dateFormatter setDateFormat:dateFormatterStr];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        
        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:startTime];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:tempDate];
        
        NSInteger day = [components day];
        NSInteger month= [components month];
        
//        [NSString stringWithFormat:@"剩%.2ld天%.2ld时%.2ld分%.2ld秒",(long)days,(long)hours,(long)minutes,(long)seconds]
        return [NSString stringWithFormat:@"%.2ld月%.2ld日 %@开抢", (long)month, (long)day,destDateString];
    }
    
    
}

+ (NSDate *)convertDateToLocalTime: (NSDate *)forDate {
    NSTimeZone *nowTimeZone = [NSTimeZone defaultTimeZone];
    NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:forDate];
    NSDate *newDate = [forDate dateByAddingTimeInterval:timeOffset];
    return newDate;
}

@end
