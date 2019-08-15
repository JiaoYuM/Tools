//
//  DRVHNetworkView.m
//  failureport
//
//  Created by 洪宾王 on 2018/2/2.
//  Copyright © 2018年 viewhigh. All rights reserved.
//

#import "DRVHNetworkView.h"
#import "UILabel+setSpaceLabel.h"

@implementation DRVHNetworkView


- (instancetype)initWithFrame:(CGRect)frame type:(placeholderViewType)placeholderType message:(NSString *)message delegate:(id)delegate
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        _placeholderType = placeholderType;
        _delegate = delegate;
        self.userInteractionEnabled = YES;
        [self setUpUIWithMessage:message];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame placeholderY:(CGFloat)placeholderY scale:(CGFloat)scale type:(placeholderViewType)placeholderType message:(NSString *)message delegate:(id)delegate {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        _placeholderType = placeholderType;
        _delegate = delegate;
        [self setUpUIWithPlaceholderY:placeholderY scale:scale message:message];
    }
    return self;
}


/** UI搭建 */
- (void)setUpUIWithMessage:(NSString *)message{
    
    //-1 默认类似居中显示
    if (self.placeholderType == placeholderViewTypeNoNetwork ) {
        //创建没有网络的视图
        [self creatNetBreakViewWithPlaceholderY:-1 scale:1 message:message];
        
    }else if (self.placeholderType == placeholderViewTypeEmpty) {
        //创建空数据
        [self creatEmptyViewWithPlaceholderY:-1 scale:1 message:message];
        
    }else if (self.placeholderType == placeholderViewTypeSearchDataEmpty){
        
        //创建搜索页面空数据
        [self creatSearchDataEmptyViewWithPlaceholderY:-1 message:message];
    }
}

/** UI搭建 */
- (void)setUpUIWithPlaceholderY:(CGFloat)placeholderY scale:(CGFloat)scale message:(NSString *)message{
    
    //placeholderY 按照指定高度进行显示
    if (self.placeholderType == placeholderViewTypeNoNetwork ) {
        //创建没有网络的视图
        [self creatNetBreakViewWithPlaceholderY:placeholderY scale:scale message:message];
        
    }else if (self.placeholderType == placeholderViewTypeEmpty) {
        //创建空数据
        [self creatEmptyViewWithPlaceholderY:placeholderY scale:scale message:message];
        
    }else if (self.placeholderType == placeholderViewTypeSearchDataEmpty ) {
        //创建搜索页面空数据
        [self creatSearchDataEmptyViewWithPlaceholderY:placeholderY message:message];
    }
}

- (void)creatNetBreakViewWithPlaceholderY:(CGFloat)placeholderY scale:(CGFloat)scale message:(NSString *)message {
    
    // 404图片放中间
    CGFloat imageW = 243 * scale;
    CGFloat imageH = 226 * scale;
    
    NSLog(@"%f",self.width);
    CGFloat imageX = (self.width - imageW) * 0.5;
    
    CGFloat imageY = 0;
    if (placeholderY == -1) {
        //这里减去40的目的是无网络的图片太小了,上面留了一大片的空白;
        imageY = (self.height - imageH) * 0.5 - kNavAndStatusHeight - 40;
    }else {
        
        imageY = placeholderY;
    }
    
    UIImageView *noNetworkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    [self addSubview:noNetworkImageView];
    noNetworkImageView.image = [UIImage imageNamed:@"icon_netBreak"];
    
    
    //提示语
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.font = [UIFont systemFontOfSize:15.0f];
    tipLab.textColor = colorWithString(@"#999999");
    self.tipLab = tipLab;
    
    if ( message == nil) {
        tipLab.text = @"信号可能跑到外太空去了哦~";
    }else {
        tipLab.text = message;
    }
    
    [UILabel  changeWordSpaceForLabel:tipLab WithSpace:1.0];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.frame = CGRectMake(0, CGRectGetMaxY(noNetworkImageView.frame), WIDTH, 30);
    [self addSubview:tipLab];
    
    
    // 重新查看按钮
    UIButton *checkButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLab.frame) + 24, 115, 34)];
    checkButton.centerX = self.width / 2;
    [self addSubview:checkButton];
    [checkButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    checkButton.backgroundColor = colorWithString(@"#ffcc41");
    [checkButton setTitle:@"刷 新" forState:UIControlStateNormal];
    [checkButton setTitleColor:colorWithString(@"#483f28") forState:UIControlStateNormal];
    checkButton.layer.cornerRadius = 17;
    checkButton.layer.masksToBounds = YES;
    checkButton.layer.borderColor = colorWithString(@"#ffe59e").CGColor;
    [checkButton addTarget:self action:@selector(checkNetworkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}



- (void)creatEmptyViewWithPlaceholderY:(CGFloat)placeholderY scale:(CGFloat)scale  message:(NSString *)message {
    
    //这里默认乘以0.8的目的是图片本身比较大,放大镜一样,所以默认比例是1,如果外面传入比例,将在指定的比例上在乘以0.8
    CGFloat imageW = 278.5 * scale * 0.8;
    CGFloat imageH = 299 * scale * 0.8;
    
    CGFloat imageX = (self.width - imageW) * 0.5;
    
    CGFloat imageY = 0;
    
    if (placeholderY == -1) {
        
        imageY = (self.height - imageH) * 0.5 - kNavAndStatusHeight;
    }else {
        
        imageY = placeholderY;
    }
    
    // 404图片放中间
    UIImageView *noNetworkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    [self addSubview:noNetworkImageView];
    noNetworkImageView.image = [UIImage imageNamed:@"icon_dataEmpty"];
    noNetworkImageView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkNetworkButtonClicked)];
    [noNetworkImageView addGestureRecognizer:tap];
    
    //提示语
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.font = [UIFont systemFontOfSize:15.0f];
    tipLab.textColor = colorWithString(@"#999999");
    self.tipLab = tipLab;
    
    tipLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkNetworkButtonClicked)];
    [tipLab addGestureRecognizer:tap2];
    
    if (message == nil) {
        tipLab.text = @"您暂时没有数据哦~";
    }else {
        tipLab.text = message;
    }
    
    [UILabel  changeWordSpaceForLabel:tipLab WithSpace:1.0];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.frame = CGRectMake(0, CGRectGetMaxY(noNetworkImageView.frame), WIDTH, 30);
    [self addSubview:tipLab];
}

- (void)creatSearchDataEmptyViewWithPlaceholderY:(CGFloat)placeholderY message:(NSString *)message{
    
    
    CGFloat messageLabY = 0;
    if (placeholderY == -1) {
        
        messageLabY = self.height  * 0.5 - kNavAndStatusHeight - 40;
        
    }else {
        
        messageLabY = placeholderY;
    }
    
    UILabel * messageLab = [[UILabel alloc] init];
    messageLab.frame = CGRectMake(0, messageLabY, WIDTH, 20);
    
    if (message == nil) {
        messageLab.text = @"没有检索到任何数据";
    }else {
        messageLab.text = message;
    }
    
    messageLab.textColor = colorWithString(@"#999999");
    messageLab.font = [UIFont systemFontOfSize:13.0];
    messageLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:messageLab];
    
}

/** 重新查看按钮点击 */
- (void)checkNetworkButtonClicked{
    
    if ([self.delegate respondsToSelector:@selector(placeholderViewReloadButtonDidClick:)]) {
        
        [self.delegate placeholderViewReloadButtonDidClick:self];
    }
}


@end

