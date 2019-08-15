//
//  DRWHProgressView.m
//  CheckGoods
//
//  Created by 洪宾王 on 16/10/20.
//  Copyright © 2016年 viewhigh. All rights reserved.
//

#import "DRVHProgressView.h"

@implementation DRVHProgressView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 60, self.frame.size.height)];

        _bgView.layer.borderColor = [UIColor clearColor].CGColor;
        _bgView.layer.borderWidth =  0.3;
        _bgView.layer.cornerRadius = 8;
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];

        _leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        _leftView.layer.borderColor = [UIColor clearColor].CGColor;
        _leftView.layer.borderWidth =  0.3;
        _leftView.layer.cornerRadius = 8;
        [_leftView.layer setMasksToBounds:YES];
        [self addSubview:_leftView];

        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bgView.frame), 0, 60, self.frame.size.height)];

        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:autoFontSize(15.0)];
        [self addSubview:_progressLabel];
    }
    return self;
}


- (void)setPreset:(CGFloat)present {

    _leftView.frame = CGRectMake(0, 0, _bgView.frame.size.width *present, self.frame.size.height);
}


@end
