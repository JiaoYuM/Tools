//
//  DRVHBrowseNavBar.h
//  FinancialManager
//
//  Created by 杨倩倩 on 2017/5/27.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrowseNavBarDelegate <NSObject>

@optional
- (void)leftBtnAction:(UIButton *)sender;
@end

@interface DRVHBrowseNavBar : UIView

@property (nonatomic, strong) id delegate;

@property (nonatomic, copy) NSString *barTitle;

- (void)changeHideState;

@end
