//
//  PhotoBrowseToolBar.m
//  FinancialManager
//
//  Created by 杨倩倩 on 2017/5/25.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "PhotoBrowseToolBar.h"

@implementation PhotoBrowseToolBar{
    
    UILabel *_pageLabel;
    
    UIButton *_saveButton;
    
    VoidBlock _saveBlock;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI{
    //显示分页的label
    CGFloat viewWidth = 50.0f;
    CGFloat viewHeignt = 28.0f;
    CGFloat viewMargin = 5.0f;
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewMargin, 0, viewWidth, viewHeignt)];
    _pageLabel.center = CGPointMake(_pageLabel.center.x, viewHeignt/2.0f);
    _pageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _pageLabel.layer.cornerRadius = 5.0f;
    _pageLabel.layer.masksToBounds = true;
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.font = [UIFont systemFontOfSize:16];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_pageLabel];
    
    //保存按钮
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(self.bounds.size.width - viewWidth - viewMargin, 0, viewWidth, viewHeignt);
    _saveButton.center = CGPointMake(_saveButton.center.x, viewHeignt/2.0f);
    _saveButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _saveButton.layer.cornerRadius = 5.0f;
    _saveButton.layer.masksToBounds = true;
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveImageMethod) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveButton];
    
    self.alpha = 0;
}

-(void)saveImageMethod{
    _saveBlock();
}

-(void)addSaveBlock:(VoidBlock)saveBlock{
    _saveBlock = saveBlock;
}

-(void)setText:(NSString *)text{
    _pageLabel.text = text;
}

-(void)show{
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1;
    }];
}

-(void)hide{
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0;
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
