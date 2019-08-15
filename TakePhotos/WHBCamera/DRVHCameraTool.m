//
//  DRVHTakeTool.m
//  testTakePhoto
//
//  Created by 洪宾王 on 17/7/27.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "DRVHCameraTool.h"
#import <AVFoundation/AVFoundation.h>


@interface DRVHCameraTool ()

@property (nonatomic, copy)cameraReturn finishBack;
@property (nonatomic, strong) UIImagePickerController *picker;

@end

static DRVHCameraTool *tool ;

@implementation DRVHCameraTool

+ (instancetype)shareInstance{

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        tool = [[DRVHCameraTool alloc] init];
    });

    return tool;
}

- (void)showCameraInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack {


    if (finishBack) {

        self.finishBack = finishBack;
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    [self setUpImagePicker];

    [vc presentViewController:self.picker animated:YES completion:nil];//进入照相界面
    [vc.view layoutIfNeeded];
}


- (void)setUpImagePicker{

    self.picker = nil;
    self.picker = [[UIImagePickerController alloc] init];//初始化
    self.picker.delegate = self;
    self.picker.allowsEditing = NO;//设置不可编辑

    //判断用户是否允许访问相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        //无权限
        return;
    }

    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.sourceType = sourceType;

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *image = info[UIImagePickerControllerOriginalImage];

    //获取当前时间
    NSDate *localDate = [NSDate date];
    //转化为UNIX时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];
    NSString *imageName = [NSString stringWithFormat:@"%@.png",timeSp];


    NSString *imagePath = [KPATH stringByAppendingPathComponent:imageName];
    NSData *newDate = UIImageJPEGRepresentation(image, 0.5);
    [newDate writeToFile:imagePath atomically:YES];

    if (self.finishBack) {

        self.finishBack(image,imageName,newDate);
    }

    // 退出图片选择控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    // 退出图片选择控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
