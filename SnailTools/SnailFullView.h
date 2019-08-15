//
//  SnailFullView.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnailIconLabel.h"

#define ROW_COUNT 3 // 每行显示3个
#define ROWS 2      // 每页显示2行
#define PAGES 1     // 共2页

@interface SnailFullView : UIView

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) NSArray<SnailIconLabelModel *> *models;
@property (nonatomic, strong, readonly) NSMutableArray<SnailIconLabel *> *items;

@property (nonatomic, copy) void (^didClickFullView)(SnailFullView *fullView);
@property (nonatomic, copy) void (^didClickItems)(SnailFullView *fullView, NSInteger index);


- (void)endAnimationsCompletion:(void (^)(SnailFullView *fullView))completion; // 动画结束后执行block

@end
