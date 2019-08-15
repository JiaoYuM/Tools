//
//  PhotoPickerController.h
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/26.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoPickerController : UIViewController

@property (nonatomic, strong) PHFetchResult *assetResult;
@end
