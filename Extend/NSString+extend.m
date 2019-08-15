//
//  NSString+extend.m
//  Test
//
//  Created by ZXY on 2017/2/9.
//  Copyright © 2017年 91JinRong. All rights reserved.
//

#import "NSString+extend.h"
#import <UIKit/UIKit.h>

@implementation NSString (extend)

+(BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    // 这里是后期补充的内容:九宫格判断
    if (!isMatch) {
        NSString *other = @"➋➌➍➎➏➐➑➒";
        unsigned long len=str.length;
        for(int i=0;i<len;i++)
        {
            unichar a=[str characterAtIndex:i];
            if(!((isalpha(a))
                 ||(isalnum(a))
                 ||((a=='_') || (a == '-'))
                 ||((a >= 0x4e00 && a <= 0x9fa6))
                 ||([other rangeOfString:str].location != NSNotFound)
                 ))
                return NO;
        }
        return YES;
        
    }
    return isMatch;
}

-(BOOL)containsEmoji{
    if (self == nil || self.length == 0) {
        return NO;
    }
    if ([self isEqualToString:@"……"]) {
        return NO;
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f]" options:NSRegularExpressionCaseInsensitive error:nil];
   
    for (int index = 0; index < self.length; index ++) {
        NSString *tempStr = [self substringWithRange:NSMakeRange(index, 1)];
        NSString *modifiedString = [regex stringByReplacingMatchesInString:tempStr
                                                                   options:0
                                                                     range:NSMakeRange(0, [tempStr length])
                                                              withTemplate:@""];
        if ([modifiedString isEqualToString:@""]) {
            return YES;
        }
        
        
    }    
    return NO;
}
- (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
//    for (int index = 0; index < self.length; index ++) {
////        NSString *tempStr = [self substringWithRange:NSMakeRange(index, 1)];
////        NSString *modifiedString = [regex stringByReplacingMatchesInString:tempStr
////                                                                   options:0
////                                                                     range:NSMakeRange(0, [tempStr length])
////                                                              withTemplate:@""];
////        return modifiedString;
////    }
}
@end
