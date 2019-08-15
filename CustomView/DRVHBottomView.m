//
//  DRVHBottomView.m
//  OutStoreroom
//
//  Created by jiaoyu on 2017/8/10.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "DRVHBottomView.h"

@interface DRVHBottomView ()
@end
@implementation DRVHBottomView


-(instancetype)initWithFrame:(CGRect)frame buttonName:(NSArray *)labelNameArray iconName:(NSArray *)imageNameArray backgroundColor:(UIColor *)color titleFontSize:(CGFloat)fontSize{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width / labelNameArray.count;
        for (NSInteger i = 0; i < labelNameArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = color;
            button.frame = CGRectMake(i * width, 0, width , frame.size.height);
            [button setTitle:labelNameArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            button.tag = 100 + i;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            if ([imageNameArray objectAtIndexVH:i]) {
                [button setImage:[UIImage imageNamed:[imageNameArray objectAtIndexVH:i]] forState:UIControlStateNormal];
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 6)]; //间隙是12
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
            }
            [self addSubview:button];
        }
        for (NSInteger i = 0; i < labelNameArray.count; i++) {
            UILabel *spaceLine = [[UILabel alloc] initWithFrame:CGRectMake((i+1)*width, 15, 1.5, 20)];
            spaceLine.backgroundColor = [UIColor whiteColor];
            [self addSubview:spaceLine];
        }
    }
    return self;
}

-(void)buttonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBottomAction:)]) {
        [self.delegate clickBottomAction:sender];
    }
}


@end
