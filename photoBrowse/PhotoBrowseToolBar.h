//
//  PhotoBrowseToolBar.h
//  FinancialManager
//
//  Created by 杨倩倩 on 2017/5/25.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>
static CGFloat ToolBarHeight = 35.0f;

typedef void(^VoidBlock)(void);
@interface PhotoBrowseToolBar : UIView
@property (nonatomic, copy) NSString *text;

-(void)addSaveBlock:(VoidBlock)saveBlock;

-(void)show;

-(void)hide;


@end
