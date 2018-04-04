//
//  EventCalendar.h
//  EventKitDemo
//
//  Created by jiaoyu on 2017/5/18.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventCalendar : NSObject
+(instancetype)sharedEventCalendar;
/*
 **
 *title 事件标题
 description  事件描述   这里可以添加位置 也可以是其它想显示的内容
 startDate 开始时间  事件的开始日期
 endDate 结束时间    事件的结束时间
 allDay 是否全天     对应系统设置里的全天
 alarmArray  闹钟集合   提前提醒的时间集合 可以设置多个  时间单位是秒  提前提醒需要设置时间为负数 如-3600 就是提前一个小时提醒
 */

-(void)createEventCalendarTitle:(NSString *)title description:(NSString *)description startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray;
@end
