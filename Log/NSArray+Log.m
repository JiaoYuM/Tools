//
//  NSArray+Log.m
//  OES
//
//  Created by jiaoyu on 2018/8/6.
//  Copyright © 2018年 viewhigh. All rights reserved.
//

#import "NSArray+Log.h"
#import "NSString+Log.h"

@implementation NSArray (Log)

// NSLog 显示
//- (NSString *)descriptionWithLocale:(id)locale{
//
//    return self.description.unicodeString;
//}

// po 输入显示
- (NSString *)debugDescription{
    
    return self.description.unicodeString;
}
@end
