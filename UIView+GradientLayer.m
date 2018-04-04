//
//  UIView+GradientLayer.m
//  CashLoan
//
//  Created by jiaoyu on 2017/3/27.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import "UIView+GradientLayer.h"
#import "UIColor+hexVaule.h"
@implementation UIView (GradientLayer)
+(CAGradientLayer *)confirmShadowColorWithColors:(NSArray *)colors layerWidth:(CGFloat)width layerHeight:(CGFloat)height{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, width, height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    NSMutableArray *p_allColors = [NSMutableArray array];
    [colors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Class class = NSClassFromString(@"UIColor");
        UIColor *color0 = [class colorWithHexString:obj];
        [p_allColors addObject:(id)[color0 CGColor]];
    }];
    gradientLayer.colors = p_allColors;
    return gradientLayer;
}

@end
