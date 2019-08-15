//
//  PhotoPickerToolBar.h
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/26.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPickerToolBar : UIView
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) BOOL barHide;

- (void)changePickedIndex:(NSInteger) pickedIndex;
- (void)changeHideState;

@end
