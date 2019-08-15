//
//  VHAutoViewUntil.m
//  fontTest
//
//

#import "VHAutoViewUntil.h"

#define HLWINSIZE [UIScreen mainScreen].bounds.size

@implementation VHAutoViewUntil

+ (NSString *)rectToString:(CGRect)_r
{
    return [NSString stringWithFormat:@"{%.1f,%.1f},{%.1f,%.1f}",
            _r.origin.x,
            _r.origin.y,
            _r.size.width,
            _r.size.height];
}
+ (CGRect)stringToRect:(NSString *)_s
{
    NSArray *_sa = [_s componentsSeparatedByString:@"},{"];
    NSString *_sp = _sa[0];
    NSString *_sr = _sa[1];
    
    _sp = [_sp substringFromIndex:1];
    _sr = [_sr substringToIndex:_sr.length - 1];
    
    NSArray *_spa = [_sp componentsSeparatedByString:@","];
    NSArray *_sra = [_sr componentsSeparatedByString:@","];
    
    return (CGRect)
    {{[_spa[0] floatValue],
        [_spa[1] floatValue]},
        {[_sra[0] floatValue],
            [_sra[1] floatValue]}};
}

+ (NSString *)piontToString:(CGPoint)_p
{
    return [NSString stringWithFormat:@"%.1f, %.1f",_p.x, _p.y];
}
+ (CGPoint)stringToPoint:(NSString *)_s
{
    NSArray *_sp = [_s componentsSeparatedByString:@","];
    
    return (CGPoint)
    {[_sp[0] floatValue],
        [_sp[1] floatValue]};
}

+ (NSString *)sizeToString:(CGSize)_z
{
    return [NSString stringWithFormat:@"%.1f, %.1f",_z.width, _z.height];
}

+ (CGSize)stringToSize:(NSString *)_s
{
    NSArray *_sp = [_s componentsSeparatedByString:@","];
    
    return (CGSize)
    {[_sp[0] floatValue],
        [_sp[1] floatValue]};
    
}

+ (UIColor *)colorWithHexString:(NSString *)color
{
    if (!color || 0 == color.length) return [UIColor clearColor];
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 8)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    //a
    range.location = 6;
    NSString *aString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) a / 255.0f)];
}

+ (CGFloat) autoFontSize:(CGFloat)fontSize
{
    if (HLWINSIZE.width <= 375) return fontSize;
    return fontSize + 2;
}

+ (CGFloat) autoFontSizeWith4S:(CGFloat)fontSize{
    if (HLWINSIZE.width <= 320) return fontSize;
    return fontSize - 2;
    if (HLWINSIZE.width <= 375) return fontSize;
    return fontSize + 2;
}

+ (CGFloat) autoFontSizeWithScale:(CGFloat)fontSize{
    
    return fontSize * ksProportionWidth;
}


+ (UIColor *)colorWithString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithString:(NSString *)color
{
    return [self colorWithString:color alpha:1.0f];
}

//数字逗号分隔
+ (NSString *)countNumAndChangeformat:(CGFloat)num{
    
    NSInteger inter = roundf(num);
    NSString *numStr = [NSString stringWithFormat:@"%zd",inter];
    NSString *str = [NSString stringWithFormat:@"%f",num];
    
    int count = 0;
    while (inter != 0){
        count++;
        inter /= 10;
    }
    
    NSMutableString *string = [NSMutableString stringWithString:numStr];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    if([str rangeOfString:@"."].location !=NSNotFound){
        //包含.
        
        NSArray *arr = [str componentsSeparatedByString:@"."];
        NSMutableString *f = arr[1];
        NSString *f1 = [NSString string];
        if (f.length >= 2) {
            f1 = [f substringWithRange:NSMakeRange(0, 2)];
        }
        [newstring appendString:[NSString stringWithFormat:@".%@",f1]];
    }else{
        
        [newstring appendString:@".00"];
    }
    return newstring;
}

// 每隔4个字符空两格
+ (NSString *)formatWithTwoBlackPerfourChar:(NSString *)code {
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    
    for (int i = 0, j = 0 ; i < [code length]; i++, j++) {
        [chars addObject:[NSNumber numberWithChar:[code characterAtIndex:i]]];
        if (j == 3) {
            j = -1;
            [chars addObject:[NSNumber numberWithChar:' ']];
            [chars addObject:[NSNumber numberWithChar:' ']];
        }
    }
    
    int length = (int)[chars count];
    char str[length];
    for (int i = 0; i < length; i++) {
        str[i] = [chars[i] charValue];
    }
    
    NSString *temp = [NSString stringWithUTF8String:str];
    return temp;
}

//以下是网络的设置
//ERP专用
NSString *getBaseUrl()
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *ipStr = [userDefault objectForKey:@"ip"];
    NSString *portStr = [userDefault objectForKey:@"port"];
    NSString *rootStr = [userDefault objectForKey:@"root"];
    
    NSString *url = NULL;
    
    if (rootStr.length == 0) {
        
        if ([portStr integerValue] == 80) {
            
            url = ipStr;
        }else {
            // ERP与OES网络默认全路径 当网络配置没有默认是80,根目录如果没有则不进行拼接
            url = [[ipStr stringByAppendingString:@":"] stringByAppendingString:portStr];
        }
        
    }else {
        
        if ([portStr integerValue] == 80) {
            
            url = [[ipStr stringByAppendingString:@"/"]stringByAppendingString:rootStr];
            
        }else {
            
            // ERP与OES网络默认全路径 当网络配置没有默认是80,根目录如果没有则不进行拼接
            url = [[[[ipStr stringByAppendingString:@":"] stringByAppendingString:portStr] stringByAppendingString:@"/"]stringByAppendingString:rootStr];
        }
    }
    
    
    return url;
}
//OES不登陆
NSString *getOtherBaseUrl()
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *ipStr = [userDefault objectForKey:@"ip"];
    NSString *portStr = [userDefault objectForKey:@"port"];
    NSString *rootStr = [userDefault objectForKey:@"root"];
    
    
    NSString *url = NULL;
    
    if (rootStr.length == 0) {
        
        // 当网络配置没有默认是80,根目录如果没有则不进行拼接
        if ([portStr integerValue] == 80) {
            url = [ipStr stringByAppendingString:@"/common/commondc/openservice"];
        }else {
            url = [[[ipStr stringByAppendingString:@":"] stringByAppendingString:portStr] stringByAppendingString:@"/common/commondc/openservice"];
        }
        
    }else {
        // 地址OES 说明getOtherBaseUrl()走的是openservice服务
        if ([portStr integerValue] == 80) {
            
            url = [[[ipStr  stringByAppendingString:@"/"]stringByAppendingString:rootStr] stringByAppendingString:@"/common/commondc/openservice"];
            
        }else {
            url = [[[[[ipStr stringByAppendingString:@":"] stringByAppendingString:portStr] stringByAppendingString:@"/"]stringByAppendingString:rootStr] stringByAppendingString:@"/common/commondc/openservice"];
        }
    }
    
    return url;
}

//OES需要登录
NSString *getCommonServiceUrl()
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *ipStr = [userDefault objectForKey:@"ip"];
    NSString *portStr = [userDefault objectForKey:@"port"];
    NSString *rootStr = [userDefault objectForKey:@"root"];
    
    NSString *url = NULL;
    
    if (rootStr.length == 0) {
        
        // 当网络配置没有默认是80,根目录如果没有则不进行拼接
        
        if ([portStr integerValue] == 80) {
            
            url = [ipStr stringByAppendingString:@"/common/commondc/commonService"];
        }else {
            url = [[[ipStr stringByAppendingString:@":"] stringByAppendingString:portStr]  stringByAppendingString:@"/common/commondc/commonService"];
            
        }
        
    }else {
        
        // 地址OES 说明getCommonServiceUrl()走的是commonService服务
        
        if ([portStr integerValue] == 80) {
            url = [[[ipStr  stringByAppendingString:@"/"]stringByAppendingString:rootStr] stringByAppendingString:@"/common/commondc/commonService"];
        }else {
            url = [[[[[ipStr stringByAppendingString:@":"] stringByAppendingString:portStr] stringByAppendingString:@"/"]stringByAppendingString:rootStr] stringByAppendingString:@"/common/commondc/commonService"];
        }
    }
    
    return url;
}

//HERP附件服务端口与网络地址端口不一致,需要单据进行处理;
NSString *getErpFileUrl(void) {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *ipStr = [userDefault objectForKey:@"ip"];
    NSString *newServerPort = [userDefault objectForKey:@"newServerPort"];
    
    // 地址ERP
    NSString *url = NULL;
    
    if (newServerPort.length == 0) {
        
        url = ipStr;
        
    }else {
        url = [[ipStr stringByAppendingString:@":"] stringByAppendingString:newServerPort];
    }
    
    return url;
}


@end

