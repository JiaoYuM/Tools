//
//  NSDictionary+Addition.m
//  JinRongProject
//
//  Created by ZXY on 2017/3/13.
//  Copyright © 2017年 91JinRong. All rights reserved.
//

#import "NSDictionary+Addition.h"
#import "NSObject+Runtime.h"

@implementation NSMutableDictionary (Addition)

+(void)load{
    Class dictCls = NSClassFromString(@"__NSDictionaryM");
    [dictCls swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(LC_setObject:forKey:)];
}
/**
 * 防止setObject:forKey为nil的时候闪退
 */
- (void)LC_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject)
        return;
    [self LC_setObject:anObject forKey:aKey];
}
@end


@implementation NSDictionary (Addition)
+(void)load{
    
}
@end
