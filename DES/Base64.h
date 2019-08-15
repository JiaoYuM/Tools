//
//  Base64.h
//  FinancialManager
//
//  Created by 洪宾王 on 2017/12/11.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject
+(NSString *)encode:(NSData *)data;
+(NSData *)decode:(NSString *)data;
+ (NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key;
+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key;
@end
