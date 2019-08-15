//
//  UIViewController+BackButtonHandler.h
//  FinancialManager
//
//  Created by 洪宾王 on 17/7/29.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

//  注释:适用于所有页面的点击返回/策划返回事件;

#import <UIKit/UIKit.h>


@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>


@end
