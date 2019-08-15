//
//  AlbumModel.h
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/26.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>

@interface AlbumModel : NSObject

@property (nonatomic, strong) PHFetchResult *assetResult;
@property (nonatomic, copy) NSString *title;

@end
