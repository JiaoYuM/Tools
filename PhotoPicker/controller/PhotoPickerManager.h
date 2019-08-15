//
//  PhotoPickerManager.h
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/26.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^ImageBlcok)(UIImage *image);

typedef void(^AlbumBlock)(NSArray *albumArray);

@interface PhotoPickerManager : NSObject

+ (instancetype)sharePhotoPickerManager;

- (void)requestImageForPHAsset:(PHAsset *)asset targetSize:(CGSize)targetSize imageResult:(ImageBlcok)imageBlock;
- (void)requestAlbumsWithType:(PHAssetCollectionType)type albumResult:(AlbumBlock)albumBlock;

@end

