/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 */

//  Created by 刘彦玮 on 15/8/1.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "BabyToy.h"


@implementation BabyToy


//十六进制转换为普通字符串的。
+(NSString *)ConvertDataToString:(NSData *)data equipName:(NSString *)equipName{

    if ([equipName hasPrefix:@"BS"]) {
       //BS设备解析的字符串
       NSString *aString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //去除掉首尾的空白字符和换行字符
        aString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![aString isEqualToString:@"a"] && aString.length > 0) {
             return aString;
        }
    }else {
        //根据文档数据是从第14个开始进行截取，所以最小长度是15
        NSInteger codeLen = 14;

        NSUInteger capacity = data.length * 2;
        NSMutableString *sbuf = [NSMutableString stringWithCapacity:capacity];
        const unsigned char *buf = data.bytes;

        NSInteger i;
        for (i=0; i<data.length; ++i) {

            [sbuf appendFormat:@"%02lX",(unsigned long)buf[i]];
        }
        NSLog(@"获取的字符串是：%@",sbuf);

        if ([sbuf hasPrefix:@"A0"] && sbuf.length > codeLen) {

            NSString *lenCode = [sbuf substringWithRange:NSMakeRange(2, 2)];
            if ([lenCode isEqualToString:@"OA"] == NO && [lenCode isEqualToString:@"04"] == NO) {

                NSNumber *lenNum = [self numberHexString:lenCode];
                NSLog(@"所取得内容长度是： %@",lenNum);
                //截取消息头后剩余字符串
                NSString *dataCode = [sbuf substringFromIndex:2];

                //判断获取的长度与字符串长度是否一致；
                if (dataCode.length == [lenNum integerValue]  * 2) {

                    //-2的目的是取出信号量的占位
                    NSString *correctCode = [sbuf substringWithRange:NSMakeRange(codeLen, sbuf.length - codeLen - 2)];
                    NSLog(@"最终截取的内容是：%@",correctCode);
                    return correctCode.copy;
                }
            }
        }
    }
    return @"";
}

+ (NSString *)ConvertHexStringToString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"===字符串===%@",unicodeString);
    return unicodeString;
}

//普通字符串转换为十六进制
+ (NSString *)ConvertStringToHexString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}


//int转data
+(NSData *)ConvertIntToData:(int)i
{

    NSData *data = [NSData dataWithBytes: &i length: sizeof(i)];
    return data;
}

//data转int
+(int)ConvertDataToInt:(NSData *)data{
    int i;
    [data getBytes:&i length:sizeof(i)];
    return i;
}

//十六进制转换为普通字符串的。
+ (NSData *)ConvertHexStringToData:(NSString *)hexString {
    
    NSData *data = [[BabyToy ConvertHexStringToString:hexString] dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}


//根据UUIDString查找CBCharacteristic
+(CBCharacteristic *)findCharacteristicFormServices:(NSMutableArray *)services
                                         UUIDString:(NSString *)UUIDString{
    for (CBService *s in services) {
        for (CBCharacteristic *c in s.characteristics) {
            if ([c.UUID.UUIDString isEqualToString:UUIDString]) {
                return c;
            }
        }
    }
    return nil;
}


//十六进制转换成十进制
+ (NSNumber *) numberHexString:(NSString *)aHexString{
    // 为空,直接返回.
    if (nil == aHexString){
        return nil;
    }

    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];

    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];

    return hexNumber;
}


@end


