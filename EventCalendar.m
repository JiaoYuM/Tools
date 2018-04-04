//
//  EventCalendar.m
//  EventKitDemo
//
//  Created by jiaoyu on 2017/5/18.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import "EventCalendar.h"
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>
@implementation EventCalendar
static EventCalendar *calendar;
+(instancetype)sharedEventCalendar{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[EventCalendar alloc] init];
    });
    return calendar;
}

-(void)createEventCalendarTitle:(NSString *)title description:(NSString *)description startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray{
    __weak typeof(self) weakSelf = self;
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [weakSelf showAlert:@"添加失败，请稍候重试"];
                }else if (!granted){
                    [weakSelf showAlert:@"不允许使用日历，请在设置中允许此App使用日历"];
                }else{
                    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                    event.title = title;
                    event.location = description;
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc] init];
                    event.startDate = startDate;
                    event.endDate = endDate;
                    event.allDay = allDay;
        
                    //添加提醒
                    if (alarmArray && alarmArray.count > 0) {
                        for (NSString *timeStr in alarmArray) {
                            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeStr integerValue]]];
                        }
                    }
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    [weakSelf showAlert:@"已添加到系统日历中"];

                }
            });
        }];
    }
}
- (void)showAlert:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end
