//
//  DRVHTakeTool.h
//  testTakePhoto
//
//  Created by 洪宾王 on 17/7/27.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^cameraReturn)(UIImage *image,NSString *imageName,NSData *imageData);


@interface DRVHCameraTool : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

+ (instancetype)shareInstance;

- (void)showCameraInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack;

@end
