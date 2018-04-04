//
//  NSDate+Tool.h
//  CashLoan
//
//  Created by jiaoyu on 2017/5/8.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tool)
//计算时间差
+(NSTimeInterval)intervalFromLastDate:(NSString *)startDate toTheDate:(NSString *)endDate;
//转换时间戳转换为时间
+(NSString *)transformDateformate:(NSString *)timestamp;

+(NSString *)transformSecondsformate:(NSString *)timestamp;

//获取当前的时间戳
+(NSString *)currentTimestamp;
@end
