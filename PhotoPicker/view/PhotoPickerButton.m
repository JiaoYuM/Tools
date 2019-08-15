//
//  PhotoPickerButton.m
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/27.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "PhotoPickerButton.h"

@implementation PhotoPickerButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self s_setupViews];
    }
    return  self;
}

- (void)s_setupViews {
    
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) * 0.5;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.backgroundColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:0.6];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

- (void)setPickedIndex:(NSInteger)pickedIndex{
    
    if (pickedIndex != 0) {
        self.backgroundColor = [UIColor colorWithRed:46/255.0 green:178/255.0 blue:242/255.0 alpha:1];
        [self setTitle:[NSString stringWithFormat:@"%ld",(long)pickedIndex] forState:(UIControlStateNormal)];
    }
    else {
        self.backgroundColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:0.6];
        [self setTitle:@"" forState:(UIControlStateNormal)];
    }
}


@end

