//
//  DRWHProgressView.h
//  CheckGoods
//
//  Created by 洪宾王 on 16/10/20.
//  Copyright © 2016年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRVHProgressView : UIView

@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *leftView;

- (void)setPreset:(CGFloat)present;


@end
