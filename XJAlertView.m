//
//  XJAlertView.m
//  CashLoan
//
//  Created by jiaoyu on 2017/3/13.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import "XJAlertView.h"
#import "UIImage+GIF.h"

@implementation XJAlertView
static bool ToastStatue;
#pragma mark -通用的AlertView
+(void)LCAlertViewWith:(NSString*)title message:(NSString*)message cancelBtnTitle:(NSString*)cancelTitle okBtnTitle:(NSString*)okTitle alertTag:(NSInteger)tag
       cancelBtnAction:(void(^)(NSInteger alertTag))cancelBlock OkBtnAction:(void(^)(NSInteger alertTag))okBlock presentController:(UIViewController*)presentVC
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
        alertController.view.tag =     tag + 200;
        if (cancelTitle != nil) {
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:cancelTitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                cancelBlock(alertController.view.tag - 200);
            }];
            [alertController addAction:CancelAction];
        }
        if (okTitle != nil) {
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                okBlock(alertController.view.tag - 200);
            }];
            [alertController addAction:okAction];
        }
        [presentVC presentViewController:alertController animated:YES completion:nil];
    }
#pragma mark - 加载图
+(void)showHUDAnimationWith:(UIViewController*)popVC requestBlcok:(CallBlock)requestBlock{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.backgroundColor = [UIColor clearColor];
    __block UIImageView *imagView;
    imagView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-50, ScreenHeight/2-50, 100, 100)];
    NSString *retinaPath = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:retinaPath];
    UIImage* image = [UIImage sd_animatedGIFWithData:data];
    imagView.backgroundColor = [UIColor clearColor];
    imagView.image = image;
    [view addSubview:imagView];
    [popVC.view.window addSubview:view];
    requestBlock(^(){
        [view removeFromSuperview];
    });
}
#pragma mark -toast弹框
+(void)toastLabel:(NSString*)toastMessage inSuperView:(UIView*)superView {
    if (ToastStatue) {
        return;
    }
    UIView *backView = [[UIView alloc] initWithFrame:superView.bounds];
    ToastStatue = YES;
    backView.backgroundColor = [UIColor clearColor];
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(40, (ScreenHeight-100)/2, 0, 0)];
    messageView.backgroundColor = COLOR(0, 0, 0, 0.6);
    messageView.layer.cornerRadius = 12;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = toastMessage;
    label.font = XJFont(F_11);
    label.textColor = [UIColor whiteColor];
    CGSize size = [UILabel labelWithString:toastMessage font:XJFont(F_11) limitWidth:ScreenWidth-80-100 withPargraphStyle:nil limitHeight:999];
    
    label.width = size.width;
    label.height = size.height;
    messageView.width = label.width+100;
    messageView.height = label.height + 40;
    messageView.center = CGPointMake(backView.width/2, backView.height/2);
    label.center = CGPointMake(messageView.width/2, messageView.height/2);
    
    [messageView addSubview:label];
    [backView addSubview:messageView];
    [superView addSubview:backView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [backView removeFromSuperview];
        ToastStatue = NO;
    });
}
#pragma mark -toast弹框
+(void)alertToast:(NSString*)toastMessage inSuperview:(UIView *)superView{
    if (ToastStatue) {
        return;
    }
    UIView *backView = [[UIView alloc] initWithFrame:superView.bounds];
    ToastStatue = YES;
    backView.backgroundColor = [UIColor clearColor];
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(40, 100, 0, 0)];
    messageView.backgroundColor = MainGoldenColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = toastMessage;
    label.font = XJFont(F_14);
    label.textColor = [UIColor whiteColor];
    CGSize size = [UILabel labelWithString:toastMessage font:XJFont(F_14) limitWidth:ScreenWidth-80 withPargraphStyle:nil limitHeight:999];
    
    label.width = size.width;
    label.height = size.height;
    messageView.width = label.width+40;
    messageView.height = label.height + 22;
    messageView.layer.cornerRadius = messageView.height / 2;
    messageView.center = CGPointMake(backView.width/2, 100);
    label.center = CGPointMake(messageView.width/2, messageView.height/2);
    
    [messageView addSubview:label];
    [backView addSubview:messageView];
    [superView addSubview:backView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [backView removeFromSuperview];
        ToastStatue = NO;
    });
}



@end
