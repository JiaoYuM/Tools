//
//  DRVHRightSelectView.h
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/21.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRVHRightSelectView : UIView

+ (void)configCustomPopViewWithFrame:(CGRect)frame imagesArr:(NSArray *)imagesArr dataSourceArr:(NSArray *)dataourceArr anchorPoint:(CGPoint)anchorPoint seletedRowForIndex:(void(^)(NSInteger index))action animation:(BOOL)animation timeForCome:(NSTimeInterval)come timeForGo:(NSTimeInterval)go;
+ (void)removed;

@end
