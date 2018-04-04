//
//  NSDate+Tool.m
//  CashLoan
//
//  Created by jiaoyu on 2017/5/8.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import "NSDate+Tool.h"

@implementation NSDate (Tool)
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
+(NSString *)currentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    ;
    
    return timeString;    
}
@end
