//
//  UIView+ViewController.m
//  WXWeibo
//
//  Created by JayWon on 15/10/30.
//  Copyright (c) 2015年 JayWon. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

-(UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    
    UIViewController *vCtrol = nil;
    do {
        
        if ([next isKindOfClass:[UIViewController class]]) {
            vCtrol = (UIViewController *)next;
            return vCtrol;
        }
        
        next =  next.nextResponder;
    } while (next != nil);
    
    return vCtrol;

}

@end
