//
//  XJAlertView.h
//  CashLoan
//
//  Created by jiaoyu on 2017/3/13.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef void(^CallBlock)(void(^requestState)());
typedef void(^OneParame)(NSInteger alertTage);
@interface XJAlertView : UIView
//通用Alertview
+(void)LCAlertViewWith:(NSString*)title
               message:(NSString*)message
        cancelBtnTitle:(NSString*)cancelTitle
            okBtnTitle:(NSString*)okTitle
              alertTag:(NSInteger)tag
       cancelBtnAction:(OneParame)cancelBlock
           OkBtnAction:(OneParame)okBlock
     presentController:(UIViewController*)presentVC;
//网路加载图
+(void)showHUDAnimationWith:(UIViewController*)popVC requestBlcok:(CallBlock)requestBlock;

/**
 * 全局弹框自动消失
 */
+(void)toastLabel:(NSString*)toastMessage inSuperView:(UIView*)superView;
//金色toast
+(void)alertToast:(NSString*)toastMessage inSuperview:(UIView *)superView;

@end
