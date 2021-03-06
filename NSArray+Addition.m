//
//  NSArray+Addition.m
//  JinRongProject
//
//  Created by ZXY on 2017/3/10.
//  Copyright © 2017年 91JinRong. All rights reserved.
//

#import "NSArray+Addition.h"
#import "NSObject+Runtime.h"

@implementation NSMutableArray (Addition)
+(void)load{
    Class arrayCls = NSClassFromString(@"__NSArrayM");
    [arrayCls swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(LC_insertObject:atIndex:)];
}
/**
 * 对于addObject的闪退保护
 */
-(void)LC_insertObject:(id)anObject  atIndex:(NSUInteger)index{
    if (!anObject) {
        return;
    }
    [self LC_insertObject:anObject atIndex:index];
}

-(id)objectAtIndexLC:(NSInteger)index{
    if (index >= [self count]) {
        return nil;
    }
    id value = [self objectAtIndex:index];
    if ([[value class] isSubclassOfClass:[NSNull class]]) {
        return nil;
    }
    return value;
}
@end

@implementation NSArray (Addition)
-(id)objectAtIndexLC:(NSInteger)index{
    if (index >= [self count]) {
        return nil;
    }
    id value = [self objectAtIndex:index];
    if ([[value class] isSubclassOfClass:[NSNull class]]) {
        return nil;
    }
    return value;
}
+(void)load{
    Class arrayClass0 = NSClassFromString(@"__NSArray0");
    [arrayClass0 swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(objectAtSafeIndex0:)];
    
    Class arrayClassI = NSClassFromString(@"__NSArrayI");
    [arrayClassI swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(objectAtSafeIndexI:)];
    
    Class arrayClassM = NSClassFromString(@"__NSArrayM");
    [arrayClassM swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(objectAtSafeIndexM:)];
    
    Class arrayCSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
    [arrayCSingleObjectArrayI swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(objectAtSafeIndexMs:)];
}
-(id)objectAtSafeIndex0:(NSUInteger)index
{
    NSAssert(YES, @"数组为空0");
    return nil;
}
-(id)objectAtSafeIndexI:(NSUInteger)index
{
    if (index<self.count) {
        return [self objectAtSafeIndexI:index];
    }
    return nil;
//    NSAssert(NO, @"数组为空I");
//    return nil;
}
-(id)objectAtSafeIndexM:(NSUInteger)index
{
    if (index<self.count) {
        return [self objectAtSafeIndexM:index];
    }
    return nil;
//    NSAssert(NO, @"数组为空M");
//    return nil;
}
-(id)objectAtSafeIndexMs:(NSUInteger)index
{
    if (index<self.count) {
        return [self objectAtSafeIndexMs:index];
    }
    return nil;
//    NSAssert(NO, @"数组为空Ms");
//    return nil;
}
@end
