//
//  DRVHBottomView.h
//  OutStoreroom
//
//  Created by jiaoyu on 2017/8/10.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickBottomButtonDelegate <NSObject>

-(void)clickBottomAction:(UIButton *)sender;

@end
@interface DRVHBottomView : UIView

@property(nonatomic,assign)id<ClickBottomButtonDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame buttonName:(NSArray *)labelNameArray iconName:(NSArray *)imageNameArray backgroundColor:(UIColor *)color titleFontSize:(CGFloat)fontSize;
@end
