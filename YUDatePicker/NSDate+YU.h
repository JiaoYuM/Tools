//
//  NSDate+YU.h
//  YUDatePicker
//
//  Created by yuzhx on 15/4/26.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YU)

+ (NSString *)dateToString:(NSDate *)date;

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

+ (NSDate *)dateWithYea:(NSInteger)yeaNum;

+ (NSInteger)daysfromYear:(NSInteger)year andMonth:(NSInteger)month;

+ (NSDateComponents*)dateComponentsFromDate:(NSDate*)date;


//by BIN
+ (NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

+(NSInteger)compareDate:(NSString*)date01 withDate:(NSString*)date02;


@end
