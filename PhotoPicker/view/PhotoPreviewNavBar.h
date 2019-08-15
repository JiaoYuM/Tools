//
//  PhotoPreviewNavBar.h
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/27.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoPreviewNavBarDelegate <NSObject>

@optional
- (void)leftBtnAction:(UIButton *)sender;
- (void)rightBtnAction:(UIButton *)sender;

@end

@interface PhotoPreviewNavBar : UIView

@property (nonatomic, strong) id delegate;

@property (nonatomic, assign) NSInteger rightBtnTitleIndex;
@property (nonatomic, copy) NSString *barTitle;
@property (nonatomic, copy) NSString *leftBtnTitle;

- (void)changeHideState;

@end
