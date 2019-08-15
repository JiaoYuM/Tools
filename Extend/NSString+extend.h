//
//  NSString+extend.h
//  Test
//
//  Created by ZXY on 2017/2/9.
//  Copyright © 2017年 91JinRong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extend)
-(BOOL)containsEmoji;
+(BOOL)isInputRuleNotBlank:(NSString *)str;
-(NSString *)disable_emoji:(NSString *)text;
@end
