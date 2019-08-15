//
//  PhotoPreviewNavBar.m
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/27.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "PhotoPreviewNavBar.h"
#import "PhotoPickerButton.h"

@interface PhotoPreviewNavBar()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) PhotoPickerButton *rightBtn;

@property (nonatomic, assign) BOOL barHide;

@end

@implementation PhotoPreviewNavBar

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
//    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.backgroundColor = colorWithHexString(@"#519ddfff");
    self.barHide = NO;
    
    // leftBtn
    {
        self.leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.leftBtn.frame = CGRectMake(0, 20, 70, 44);
        [self.leftBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.5] forState:(UIControlStateHighlighted)];
        
        [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [self.leftBtn setImage:[UIImage imageNamed:@"photopicker_back"] forState:(UIControlStateNormal)];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.leftBtn];
        
    }
    
    // titleLab
    {
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.font = [UIFont systemFontOfSize:16];
        self.titleLab.textColor = [UIColor whiteColor];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLab];
    }
    
    // rightBtn
    {
        self.rightBtn = [[PhotoPickerButton alloc] initWithFrame:CGRectMake(WIDTH - 35, 31, 20, 20)];
        [self.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.rightBtn];
        
    }
}

- (void)setRightBtnTitleIndex:(NSInteger)rightBtnTitleIndex {
    _rightBtnTitleIndex = rightBtnTitleIndex;
    [self.rightBtn setPickedIndex:rightBtnTitleIndex];
    
}

- (void)setLeftBtnTitle:(NSString *)leftBtnTitle {
    
    _leftBtnTitle = leftBtnTitle;
    
    CGFloat titleWidth = [self widthWithString:leftBtnTitle textFontSize:16];
    
    self.leftBtn.frame = CGRectMake(10, 20, titleWidth + 20, 44);
    [self.leftBtn setTitle:leftBtnTitle forState:(UIControlStateNormal)];
}

- (void)setBarTitle:(NSString *)barTitle {
    
    _barTitle = barTitle;
    
    CGFloat titleWidth = [self widthWithString:barTitle textFontSize:16];
    self.titleLab.frame = CGRectMake((WIDTH - titleWidth) * 0.5, 20, titleWidth, 44);
    self.titleLab.text = barTitle;
}

- (void)leftBtnAction:(UIButton *)sender {
    
    UIViewController *vc = [self getCurrentViewController];
    if (vc.navigationController) {
        [vc.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightBtnAction:(UIButton *)sender {
    [self.delegate rightBtnAction:sender];
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


/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}


- (CGFloat)widthWithString:(NSString *)text textFontSize:(CGFloat)size {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(LONG_MAX, 8)options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    return rect.size.width;
}

@end
