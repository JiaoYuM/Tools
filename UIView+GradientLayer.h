//
//  UIView+GradientLayer.h
//  CashLoan
//
//  Created by jiaoyu on 2017/3/27.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GradientLayer)
//渐变色
+(CAGradientLayer *)confirmShadowColorWithColors:(NSArray *)colors layerWidth:(CGFloat)width layerHeight:(CGFloat)height;

@end
