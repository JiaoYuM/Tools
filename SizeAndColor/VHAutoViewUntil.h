//
//  VHAutoViewUntil.h
//  fontTest
//
//

// 注释: 该页面主要是用来设置字体,颜色,并定义了网络请求时候拼接的各种URL

#import <UIKit/UIKit.h>

@interface VHAutoViewUntil : NSObject


//字符串与rect转换， 字符串格式为{x, y},{w, h}

+ (NSString *)rectToString:(CGRect)_r;
+ (CGRect)stringToRect:(NSString *)_s;

//字符串与point转换,字符串格式为x,y
+ (NSString *)piontToString:(CGPoint)_p;
+ (CGPoint)stringToPoint:(NSString *)_s;

//字符串与size转换,字符串格式为w,h
+ (NSString *)sizeToString:(CGSize)_z;
+ (CGSize)stringToSize:(NSString *)_s;

//16进制颜色字符串转换为UIColor，字符串格式为#FFFFFFFF 八位
+ (UIColor *) colorWithHexString: (NSString *)color;

//字体自动缩小,使用3x图值+ 2
+ (CGFloat) autoFontSize:(CGFloat)fontSize;

//字体4s-2 plus +2
+ (CGFloat) autoFontSizeWith4S:(CGFloat)fontSize;

//字体按照屏幕比例显示
+ (CGFloat) autoFontSizeWithScale:(CGFloat)fontSize;


+ (UIColor *)colorWithString:(NSString *)color;
//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithString:(NSString *)color alpha:(CGFloat)alpha;
+ (NSString *)countNumAndChangeformat:(CGFloat)num;
+ (NSString *)formatWithTwoBlackPerfourChar:(NSString *)code;


//以下是网络内容
NSString *getBaseUrl(void);
NSString *getOtherBaseUrl(void);
NSString *getCommonServiceUrl(void);
NSString *getErpFileUrl(void);


@end
