//
//  PhotoPickerCell.h
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/26.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "PhotoModel.h"

typedef void(^PickBtnBlock)(PhotoModel *curPickModel);
typedef void(^ModelChangeBlock)(PhotoModel *modifiedModel);

@interface PhotoPickerCell : UICollectionViewCell

@property (nonatomic, strong) PhotoModel *model;

@property (nonatomic, strong) PickBtnBlock pickBtnBlock;

- (void)modelChangePickedIndex:(NSInteger)pickedIndex;

@end

