//
//  Base64.m
//  FinancialManager
//
//  Created by 洪宾王 on 2017/12/11.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "Base64.h"
#import <CommonCrypto/CommonCryptor.h>


static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@interface Base64()
+(int)char2Int:(char)c;
@end

@implementation Base64


+(NSString *)encode:(NSData *)data
{
    if (data.length == 0)
        return nil;
    
    char *characters = malloc(data.length * 3 / 2);
    
    if (characters == NULL)
        return nil;
    
    int end = (int)data.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[data bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == data.length - 2)
    {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == data.length - 1)
    {
        int d = ((int)(((char *)[data bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rtnStr;
    
}

+(NSData *)decode:(NSString *)data
{
    if(data == nil || data.length <= 0) {
        return nil;
    }
    NSMutableData *rtnData = [[NSMutableData alloc]init];
    int slen = (int)data.length;
    int index = 0;
    while (true) {
        while (index < slen && [data characterAtIndex:index] <= ' ') {
            index++;
        }
        if (index >= slen || index  + 3 >= slen) {
            break;
        }
        
        int byte = ([self char2Int:[data characterAtIndex:index]] << 18) + ([self char2Int:[data characterAtIndex:index + 1]] << 12) + ([self char2Int:[data characterAtIndex:index + 2]] << 6) + [self char2Int:[data characterAtIndex:index + 3]];
        Byte temp1 = (byte >> 16) & 255;
        [rtnData appendBytes:&temp1 length:1];
        if([data characterAtIndex:index + 2] == '=') {
            break;
        }
        Byte temp2 = (byte >> 8) & 255;
        [rtnData appendBytes:&temp2 length:1];
        if([data characterAtIndex:index + 3] == '=') {
            break;
        }
        Byte temp3 = byte & 255;
        [rtnData appendBytes:&temp3 length:1];
        index += 4;
        
    }
    return rtnData;
}

+(int)char2Int:(char)c
{
    if (c >= 'A' && c <= 'Z') {
        return c - 65;
    } else if (c >= 'a' && c <= 'z') {
        return c - 97 + 26;
    } else if (c >= '0' && c <= '9') {
        return c - 48 + 26 + 26;
    } else {
        switch(c) {
            case '+':
                return 62;
            case '/':
                return 63;
            case '=':
                return 0;
            default:
                return -1;
        }
    }
}


const Byte iv[] = {1,2,3,4,5,6,7,8};
+ (NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key
{
    NSString *plaintext = nil;
    NSData *cipherdata = [Base64 decode:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [Base64 encode:data];
    }
    return ciphertext;
}

@end


