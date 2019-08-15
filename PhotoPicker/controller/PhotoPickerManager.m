//
//  PhotoPickerManager.m
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/26.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "PhotoPickerManager.h"
#import "AlbumModel.h"

@interface PhotoPickerManager()

@end


@implementation PhotoPickerManager

+ (instancetype)sharePhotoPickerManager {
    
    static PhotoPickerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[PhotoPickerManager alloc] init];
        }
    });
    return manager;
}

- (void)requestImageForPHAsset:(PHAsset *)asset targetSize:(CGSize)targetSize imageResult:(ImageBlcok)imageBlock {
    
    // 使用PHImageManager从PHAsset中请求图片
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            imageBlock(result);
        }
    }];
    
}

- (void)requestAlbumsWithType:(PHAssetCollectionType)type albumResult:(AlbumBlock)albumBlock {
    
    // 列出所有相册智能相册
    PHFetchResult *assetCollectionResult = [PHAssetCollection fetchAssetCollectionsWithType:type subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    
    NSMutableArray *albumArray = [NSMutableArray array];
    // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
    for (NSInteger i = 0; i < assetCollectionResult.count; i++) {
        
        // 获取一个相册（PHAssetCollection）
        PHCollection *collection = assetCollectionResult[i];
        if ([collection class] == [PHAssetCollection class]) {
            
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            NSString *titleName = assetCollection.localizedTitle;
            //去掉视频的选取
            if (assetResult.count != 0 && ![titleName isEqualToString:@"Videos"]) {
                
                AlbumModel *model = [[AlbumModel alloc] init];
                model.title = collection.localizedTitle;
                model.assetResult = assetResult;
                
                [albumArray addObject:model];
            }
        }
        albumBlock(albumArray);
    }
    
}

@end
