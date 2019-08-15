//
//  PhotoPickerButton.h
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/27.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonTouchedBlock)(void);

@interface PhotoPickerButton : UIButton

@property (nonatomic, assign) NSInteger pickedIndex;

@property (nonatomic, strong) ButtonTouchedBlock  touchedBlock;

@end
