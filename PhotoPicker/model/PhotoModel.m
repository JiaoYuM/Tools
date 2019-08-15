//
//  PhotoModel.m
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/26.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

-(id)copyWithZone:(NSZone *)zone {
    
    PhotoModel *modelCopy = [[[self class] allocWithZone:zone] init];
    
    modelCopy.asset = self.asset;
    modelCopy.pickedIndex = self.pickedIndex;
    modelCopy.inAlbumIndex = self.inAlbumIndex;
    
    return modelCopy;
    
}

@end
