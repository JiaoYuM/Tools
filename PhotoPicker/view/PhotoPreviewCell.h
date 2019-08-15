//
//  PhotoPreViewCell.h
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/27.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Photos/Photos.h>

typedef void(^SingleTapEventBlock)(void);

@interface PhotoPreviewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) CGFloat zoomScale;

@property (nonatomic, strong) SingleTapEventBlock singleTapEvent;

@end
