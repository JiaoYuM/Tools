//
//  PhotoPreViewViewController.h
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/27.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PhotoModel.h"

@protocol PhotoPreviewControllerDelegate <NSObject>

@optional;

- (void)pickedArrayChangeWithModel:(PhotoModel *)model;

@end

@interface PhotoPreviewController : UIViewController

@property (nonatomic, strong) NSMutableArray *previewArray;
@property (nonatomic, assign) NSInteger curIndex;

@property (nonatomic, strong) id<PhotoPreviewControllerDelegate> delegate;

@end
