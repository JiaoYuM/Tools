//
//  BaseSelectViewController.h
//  CashLoan
//
//  Created by jiaoyu on 2017/6/20.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseSelectViewController : BaseViewController
@property(nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)UIScrollView *mainScrollView;

-(void)showCurrentVC:(NSInteger)index;
@end
