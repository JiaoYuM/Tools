//
//  PhotoPicker.m
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/26.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "PhotoPicker.h"
#import "PhotoPickerNavController.h"

@implementation PhotoPicker
+ (instancetype)sharePhotoPicker {
    
    static PhotoPicker *photoPicker = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!photoPicker) {
            photoPicker = [[PhotoPicker alloc] init];
        }
    });
    return photoPicker;
}

- (void) showPhotoPickerToController:(UIViewController *)controller pickedAssets:(PhotoPickerBlock)photoPickerBlcok {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                    
                case PHAuthorizationStatusNotDetermined:
                {
                    NSLog(@"用户还没有做出选择");
                    break;
                }
                case PHAuthorizationStatusAuthorized:
                {
                    
                    NSLog(@"用户允许当前应用访问相册");
                    PhotoPickerNavController *vc = [[PhotoPickerNavController alloc] init];
                    [controller presentViewController:vc animated:YES completion:nil];
                    self.photoPickerBlock = photoPickerBlcok;
                    
                    break;
                }
                case PHAuthorizationStatusDenied:
                {
                    NSLog(@"用户拒绝当前应用访问相册,我们需要提醒用户打开访问开关");
                    [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"相册不可访问", nil) message:NSLocalizedString(@"请在通用-FinancialManager-相册中打开使用权限",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles: nil] show];
                    return;
                    break;
                }
                case PHAuthorizationStatusRestricted:
                {
                    NSLog(@"家长控制,不允许访问");
                    break;
                }
                default:
                {
                    NSLog(@"default");
                    break;
                }
            }
        });
    }];
}


@end
