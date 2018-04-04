//
//  JYSystemInfo.h
//  CashLoan
//
//  Created by jiaoyu on 2017/5/25.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYSystemInfo : NSObject
//获取系统版本号 iPhone 6 6s 7 7p ...
+(NSString *)deviceModelName;
//判断手机是否越狱
+(BOOL)isBreakOutPrison;
@end
