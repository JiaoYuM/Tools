//
//  JYMatching.m
//  CashLoan
//
//  Created by jiaoyu on 2017/5/3.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import "JYMatching.h"

@implementation JYMatching
#pragma 正则匹配用户密码8-16位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"[0-9A-Za-z]{8,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}
#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}
@end
