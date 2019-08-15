//
//  NSDate+Extend.h
//  categoryKitDemo
//
//  Created by zhanghao on 2016/7/23.
//  Copyright © 2017年 zhanghao. All rights reserved.
//
//  注释:时间戳转日期,计算时间差等;


#import <Foundation/Foundation.h>

@interface NSDate (Extend)

@property (nonatomic, assign, readonly) NSInteger year;
@property (nonatomic, assign, readonly) NSInteger month;
@property (nonatomic, assign, readonly) NSInteger day;
@property (nonatomic, assign, readonly) NSInteger hour;
@property (nonatomic, assign, readonly) NSInteger minute;
@property (nonatomic, assign, readonly) NSInteger second;
@property (nonatomic, assign, readonly) NSInteger weekday;

/**
 获取星期几(名称)
 
 @return Return weekday as a localized string
 [1 - Sunday]
 [2 - Monday]
 [3 - Tuerday]
 [4 - Wednesday]
 [5 - Thursday]
 [6 - Friday]
 [7 - Saturday]
 */
- (NSString *)dayFromWeekday;
+ (NSString *)dayFromWeekday:(NSDate *)date;

+ (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

+ (NSString *)ymdFormatJoinedByString:(NSString *)string;
+ (NSString *)ymdHmsFormat;
+ (NSString *)ymdFormat;
+ (NSString *)hmsFormat;
+ (NSString *)dmyFormat; // day month years format
+ (NSString *)myFormat; // month years format


//计算时间差
+(NSTimeInterval)intervalFromLastDate:(NSString *)startDate toTheDate:(NSString *)endDate;
//转换时间戳转换为时间
+(NSString *)transformDateformate:(NSString *)timestamp;

+(NSString *)transformSecondsformate:(NSString *)timestamp;

//获取当前的时间戳例如78323810293
+(NSString *)currentTimestamp;

//获取当前时间非时间戳模式格式:2015-07-15 15:00:00
+(NSString *)currentFormatterTimes;

//时间转换成时间戳
+(NSInteger)transformInterval:(NSString *)dateString;



// 字符串转NSDate
//theTime 字符串时间
//转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00

+ (NSDate *)dateFromString:(NSString *)timeStr
                    format:(NSString *)format;

/**
 *  NSDate转时间戳
 *
 *  @param date 字符串时间
 *
 *  @return 返回时间戳
 */
+ (NSInteger)cTimestampFromDate:(NSDate *)date;


// 字符串转时间戳
//  @param theTime 字符串时间
//  @param format  转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
// @return 返回时间戳的字符串

+(NSInteger)cTimestampFromString:(NSString *)timeStr
                          format:(NSString *)format;


/**
 *  时间戳转字符串
 *
 *  @param timeStamp 时间戳
 *  @param format    转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp
                     withDateFormat:(NSString *)format;

/**
 *  NSDate转字符串
 *
 *  @param date   NSDate时间
 *  @param format 转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format;

@end


