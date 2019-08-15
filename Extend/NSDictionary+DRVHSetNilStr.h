//
//  NSDictionary+DRVHSetNilStr.h
//  FinancialManager
//
//  Created by 洪宾王 on 17/7/17.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

// 注释: 主要是用于数组/字典中的null转换成@""; 空字符串;

#import <Foundation/Foundation.h>

@interface NSDictionary (DRVHSetNilStr)

+(id)changeType:(id)myObj;

@end
