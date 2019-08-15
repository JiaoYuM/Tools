//
//  VHAutoViewDefine.h
//  fontTest
//
//  Created by 杨倩倩 on 2017/3/27.
//  Copyright © 2017年 杨倩倩. All rights reserved.
//

#ifndef VHAutoViewDefine_h
#define VHAutoViewDefine_h

#import "VHAutoViewUntil.h"

#define HLWINSIZE [UIScreen mainScreen].bounds.size

#define rectToString(arg)   [VHAutoViewUntil rectToString:arg]
#define stringToRect(arg)   [VHAutoViewUntil stringToRect:arg]
#define piontToString(arg)  [VHAutoViewUntil piontToString:arg]
#define stringToPoint(arg)  [VHAutoViewUntil stringToPoint:arg]
#define sizeToString(arg)   [VHAutoViewUntil sizeToString:arg]
#define stringToSize(arg)   [VHAutoViewUntil stringToSize:arg]
//字符串不为空
#define noEmptyString(arg)  arg && arg.length > 0
//颜色
#define colorWithHexString(arg) [VHAutoViewUntil colorWithHexString:arg]
#define colorWithString(arg)    [VHAutoViewUntil colorWithString:arg]
#define colorWithStringByAlpha(arg,a) [VHAutoViewUntil colorWithString:arg alpha:a]

//字体大小
#define autoFontSize(arg)      [VHAutoViewUntil autoFontSize:arg]
#define autoFontSizeWith4S(arg) [VHAutoViewUntil autoFontSizeWith4S:arg]
#define autoFontSizeWithScale(arg) [VHAutoViewUntil autoFontSizeWithScale:arg]
#define d_CachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
#define d_Document  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

#define rgb(r, g, b) \
[UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1]

#define rgba(r, g, b, a) \
[UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) a / 255.0f)]

//金钱转换   12,2323.00模式 arg是Float 或者 Double类型
#define changeMoneyForNum(arg) [VHAutoViewUntil countNumAndChangeformat:arg]

//银行卡显示，4字一隔开
#define bankCodeShowFormatter(args) [VHAutoViewUntil formatWithTwoBlackPerfourChar:args]

//网络请求的参数
#define baseUrl getBaseUrl()
#define otherBaseUrl getOtherBaseUrl()
#define commonServiceUrl getCommonServiceUrl()


#endif /* VHAutoViewDefine_h */
