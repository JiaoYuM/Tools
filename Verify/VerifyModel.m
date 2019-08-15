//
//  VerifyModel.m
//  ZhaoHuC
//
//  Created by MacPro on 2018/5/23.
//  Copyright © 2018年 Viewhigh. All rights reserved.
//

#import "VerifyModel.h"

@implementation VerifyModel

//比较两个版本号的大小
+(NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}


//身份证格式验证
+ (BOOL)isCorrect:(NSString *)IDNumber {
    
    NSMutableArray *IDArray = [NSMutableArray array];
    
    // 遍历身份证字符串,存入数组中
    
    for (int i = 0; i <18; i++) {
        
        NSRange range = NSMakeRange(i, 1);
        
        NSString *subString = [IDNumber substringWithRange:range];
        
        [IDArray addObject:subString];
        
    }
    
    // 系数数组
    
    NSArray *coefficientArray = @[@7, @9, @10, @5, @8, @4, @2, @1, @6, @3, @7, @9, @10, @5, @8, @4, @"2"];
    
    // 余数数组
    
    NSArray *remainderArray = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    // 每一位身份证号码和对应系数相乘之后相加所得的和
    
    int sum = 0;
    
    for (int i = 0; i <17; i++) {
        
        int coefficient = [coefficientArray[i] intValue];
        
        int ID = [IDArray[i] intValue];
        
        sum += coefficient * ID;
        
    }
    
    // 这个和除以11的余数对应的数
    
    NSString *str = remainderArray[(sum % 11)];
    
    // 身份证号码最后一位
    
    NSString *string = [IDNumber substringFromIndex:17];
    
    // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
    
    return [str isEqualToString:string];
    
}
//手机号的校验
+ (BOOL) isVaildMobileNo:(NSString *)mobileNo
{
    
    NSString *phoneRegex = @"^((1[345789]))\\d{9}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobileNo];
}
// 姓名校验 2~8个中文字,不允许拼音,数字
+ (BOOL)isVaildRealName:(NSString *)realName
{
   
    
    NSRange range1 = [realName rangeOfString:@"·"];
    NSRange range2 = [realName rangeOfString:@"•"];
    if(range1.location != NSNotFound ||   // 中文 ·
       range2.location != NSNotFound )    // 英文 •
    {
        //一般中间带 `•`的名字长度不会超过15位，如果有那就设高一点
        if ([realName length] < 2 || [realName length] > 15)
        {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+[·•][\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
    else
    {
        //一般正常的名字长度不会少于2位并且不超过8位，如果有那就设高一点
        if ([realName length] < 2 || [realName length] > 8) {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
}
///密码格式的判断
+ (BOOL)isVaildRealPassWord:(NSString *)passWord
{
    //去除开头结尾的空格
  NSString *str = [passWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(![str isEqualToString:passWord])
    {
        return NO;
    }
    //中文的判断
    for (int i=0; i<passWord.length; i++) {
        unichar ch = [passWord characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return NO;
        }
    }
    NSMutableArray *pdArray = [NSMutableArray array];
    // 遍历字符串,存入数组中
    for (int i = 0; i <passWord.length; i++) {
        
        NSRange range = NSMakeRange(i, 1);
        
        NSString *subString = [passWord substringWithRange:range];
        
        [pdArray addObject:subString];
    }
    int a = 0 ,b = 0, c = 0;
    for(NSString *str in pdArray)
    {
        //大写字母的判断
        NSString *pdRegex1 = @"^[A-Z]+$";
        NSPredicate *pdText1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pdRegex1];
        if([pdText1 evaluateWithObject:str])
        {
            a=1;
        }
    }
    for(NSString *str in pdArray)
    {
        //小写字母的判断
        NSString *pdRegex1 = @"^[a-z]+$";
        NSPredicate *pdText1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pdRegex1];
        if([pdText1 evaluateWithObject:str])
        {
            b=1;
        }
    }
    for(NSString *str in pdArray)
    {
        //数字的判断
        NSString *pdRegex1 = @"^[0-9]+$";
        NSPredicate *pdText1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pdRegex1];
        if([pdText1 evaluateWithObject:str])
        {
            c=1;
        }
    }    
    if(a==1&&b==1&&c==1)
    {
        return YES;
    }
    else
    {
          return NO;
    }
}
@end
