//
//  DRVHBrowseNavBar.m
//  FinancialManager
//
//  Created by 杨倩倩 on 2017/5/27.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "DRVHBrowseNavBar.h"
#import "UIView+ViewController.h"

@interface DRVHBrowseNavBar()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, assign) BOOL barHide;

@end

@implementation DRVHBrowseNavBar

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.barHide = NO;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"navTitle"];
    [self addSubview:imageView];
    // leftBtn
    {
        self.leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.leftBtn.frame = CGRectMake(0, 20, 70, 44);
        [self.leftBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.5] forState:(UIControlStateHighlighted)];
        [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [self.leftBtn setImage:[UIImage imageNamed:@"back_white"] forState:(UIControlStateNormal)];
        [self.leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [imageView addSubview:self.leftBtn];
        
    }
    
    // titleLab
    {
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.font = [UIFont boldSystemFontOfSize:autoFontSize(17)];
        self.titleLab.textColor = [UIColor whiteColor];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:self.titleLab];
    }
}
- (void)setBarTitle:(NSString *)barTitle {
    
    _barTitle = barTitle;
    
    self.titleLab.frame = CGRectMake(50, 22, WIDTH - 100, 44);
    self.titleLab.text = barTitle;
}

- (void)leftBtnAction:(UIButton *)sender {
    
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

- (void)changeHideState {
    
    self.barHide = !self.barHide;
    
    if (self.barHide) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, -64, WIDTH, 64);
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 0, WIDTH, 64);
        }];
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
