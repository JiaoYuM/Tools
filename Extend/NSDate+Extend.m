//
//  NSDate+Extend.m
//  categoryKitDemo
//
//  Created by zhanghao on 2016/7/23.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "NSDate+Extend.h"

static NSDateFormatter *dateFormatter;

@implementation NSDate (Extend)

- (NSCalendar *)calendar {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
#else
    return [NSCalendar currentCalendar]
#endif
}

- (NSInteger)year {
    return [[[self calendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month {
    return [[[self calendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day {
    return [[[self calendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[[self calendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[self calendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[[self calendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)weekday {
    return [[[self calendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSString *)dayFromWeekday {
    return [NSDate dayFromWeekday:self];
}

+ (NSString *)dayFromWeekday:(NSDate *)date {
    switch([date weekday]) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)stringWithFormat:(NSString *)format {
    return [[NSDate date] stringWithFormat:format];
}

+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format {
    return [date stringWithFormat:format];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

+ (NSString *)ymdFormatJoinedByString:(NSString *)string {
    return [NSString stringWithFormat:@"yyyy%@MM%@dd", string, string];
}

+ (NSString *)ymdHmsFormat {
    return [NSString stringWithFormat:@"%@ %@", [self ymdFormat], [self hmsFormat]];
}

+ (NSString *)ymdFormat {
    return @"yyyy-MM-dd";
}

+ (NSString *)hmsFormat {
    return @"HH:mm:ss";
}

+ (NSString *)dmyFormat {
    return @"dd/MM/yyyy";
}

+ (NSString *)myFormat {
    return @"MM/yyyy";
}


+(NSTimeInterval)intervalFromLastDate:(NSString *)startDate toTheDate:(NSString *)endDate{
    NSArray *timeArray1=[startDate componentsSeparatedByString:@"."];
    startDate=[timeArray1 objectAtIndex:0];
    
    NSArray *timeArray2=[endDate componentsSeparatedByString:@"."];
    endDate = [timeArray2 objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy年MM月dd日HH:mm:ss:SSS"];
    
    NSDate *d1 = [date dateFromString:startDate];
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1000;  //精确到毫秒
    
    NSDate *d2=[date dateFromString:endDate];
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1000;  //精确到毫秒
    
    NSTimeInterval timeSpace = late2 - late1;
    
    return timeSpace;
}
//时间戳转换为时间
+(NSString *)transformDateformate:(NSString *)timestamp{
    //后台传的是13位的 所以要除以1000  iOS默认是10位的
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/1000];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateformatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *staartstr=[dateformatter stringFromDate:date];
    NSLog(@"%@",staartstr);
    return staartstr;
}

//时间戳转换时间 精确到秒
+(NSString *)transformSecondsformate:(NSString *)timestamp{
    //后台传的是13位的 所以要除以1000  iOS默认是10位的
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue] /1000];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *staartstr=[dateformatter stringFromDate:date];
    NSLog(@"%@",staartstr);
    return staartstr;
}

//获取当前时间非时间戳模式格式:2015-07-15 15:00:00
+(NSString *)currentFormatterTimes {
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *time = [dateFormatter stringFromDate:currentDate];
    
    return time;
}


+(NSString *)currentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970] * 1000;
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

+(NSInteger)transformInterval:(NSString *)dateString{
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSDate * now = [dateformatter dateFromString:dateString];
    //转成时间戳
    return (long)[now timeIntervalSince1970] * 1000;
}



+(NSDateFormatter *)defaultFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc]init];
    });
    return dateFormatter;
}

+ (NSDate *)dateFromString:(NSString *)timeStr
                    format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [NSDate defaultFormatter];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    return date;
}

+ (NSInteger)cTimestampFromDate:(NSDate *)date
{
    return (long)[date timeIntervalSince1970];
}


+(NSInteger)cTimestampFromString:(NSString *)timeStr
                          format:(NSString *)format
{
    NSDate *date = [NSDate dateFromString:timeStr format:format];
    return [NSDate cTimestampFromDate:date];
}

+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp
                     withDateFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    return [NSDate datestrFromDate:date withDateFormat:format];
}

+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format
{
    NSDateFormatter* dateFormat = [NSDate defaultFormatter];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}



@end

