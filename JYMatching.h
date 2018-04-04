//
//  JYMatching.h
//  CashLoan
//
//  Created by jiaoyu on 2017/5/3.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYMatching : NSObject

#pragma 正则匹配用户密码8-16位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;
@end
