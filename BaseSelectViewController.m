//
//  BaseSelectViewController.m
//  CashLoan
//
//  Created by jiaoyu on 2017/6/20.
//  Copyright © 2017年 jiaoyu. All rights reserved.
//

#import "BaseSelectViewController.h"
#import "HMSegmentedControl.h"
@interface BaseSelectViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)HMSegmentedControl *segmentedControl;
@end

@implementation BaseSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //导航菜单
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.titleArray];
    segmentedControl.frame = CGRectMake(0, 0, ScreenWidth, 45);
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionIndicatorHeight = 2.0f;
    segmentedControl.selectionIndicatorColor = SElECTED_COLOR;
    UIFont *font = [UIFont systemFontOfSize:F_16];
    UIColor *titleColor = C_153;
    segmentedControl.titleTextAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:titleColor};
    UIColor *selectColor = SElECTED_COLOR;
    segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:selectColor};
    WeakSelf(BaseSelectViewController);
    [segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.mainScrollView setContentOffset:CGPointMake(ScreenWidth *index, 0) animated:YES];
        [weakSelf showCurrentVC:index];
    }];
    self.segmentedControl = segmentedControl;
    [self.view addSubview:segmentedControl];
    
    [self createMainScrollView];

}
#pragma mark -- 主滑动视图
-(void)createMainScrollView{
    //创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height);
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.titleArray.count, 0);
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
}
#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSLog(@"%ld",index);
    [self showCurrentVC:index];
    [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
}

-(void)showCurrentVC:(NSInteger)index{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
