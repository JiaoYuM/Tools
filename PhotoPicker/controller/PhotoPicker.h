//
//  PhotoPicker.h
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/26.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^PhotoPickerBlock)(NSArray <PHAsset *> *assets);

@interface PhotoPicker : NSObject
@property (nonatomic,copy) PhotoPickerBlock photoPickerBlock;

+ (instancetype)sharePhotoPicker;

- (void) showPhotoPickerToController:(UIViewController *)controller pickedAssets:(PhotoPickerBlock)photoPickerBlcok;


@end
