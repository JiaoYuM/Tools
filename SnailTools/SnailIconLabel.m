//
//  SnailIconLabel.m
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/9/26.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "SnailIconLabel.h"

@implementation SnailIconLabel

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _iconView = [[UIImageView alloc] init];
        _iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToVc)];
        [_iconView addGestureRecognizer:tap];
        [self addSubview:_iconView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.userInteractionEnabled = NO;
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor darkGrayColor];
        _textLabel.font = [UIFont systemFontOfSize:11];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
        
        _horizontalLayout = NO;
        _autoresizingFlexibleSize = NO;
    }
    return self;
}

/// 水平布局
- (void)horizontalLayoutSubviews {
    
    CGFloat sideLength = self.frame.size.height - self.imageEdgeInsets.top - self.imageEdgeInsets.bottom;
    _iconView.frame = CGRectMake(self.imageEdgeInsets.left, self.imageEdgeInsets.top, sideLength, sideLength);
    
    if (_textLabel.text.length > 0) {
        
        CGFloat x = CGRectGetMaxX(_iconView.frame) + self.imageEdgeInsets.right;
        CGFloat h = self.frame.size.height;
        CGSize size = [_textLabel sizeThatFits:CGSizeMake(MAXFLOAT, h)];
        CGFloat y = (self.frame.size.height - size.height) / 2;
        
        if (_autoresizingFlexibleSize) {
            if (_sizeLimit > 0) { // 限宽
                if (size.width > _sizeLimit) size.width = _sizeLimit;
            }
            _textLabel.frame = CGRectMake(x, y, size.width, size.height);
            
            CGRect frame = self.frame;
            frame.size.width = _textLabel.frame.origin.x + _textLabel.frame.size.width;
            self.frame = frame;
        } else {
            _textLabel.frame = CGRectMake(x, y, size.width, size.height);
        }
        
    } else {
        if (_autoresizingFlexibleSize) {
            CGRect frame = self.frame;
            frame.size.width = frame.size.height;
            self.frame = frame;
        }
    }
}

- (void)jumpToVc {

    if (self.imageBlock) {
        self.imageBlock();
    }
}

/// 纵向布局
- (void)verticalLayoutSubviews {


    CGFloat imagW = 40;
    CGFloat imageLeft = (self.frame.size.width - imagW) * 0.5;

    _iconView.frame = CGRectMake(imageLeft, self.imageEdgeInsets.top, 40, 40);

    if (_textLabel.text.length > 0) {
        
        CGFloat y = CGRectGetMaxY(_iconView.frame) + 5;
        CGFloat w = self.frame.size.width;
        
        if (!_autoresizingFlexibleSize) {
            _textLabel.frame = CGRectMake(0, y, w, 21);
        } else {
         
            CGSize size = [_textLabel sizeThatFits:CGSizeMake(w, 21)];
            CGFloat x = (self.frame.size.width - size.width) / 2;
            if (_sizeLimit > 0) { // 限高
                if (size.height > _sizeLimit) size.height = _sizeLimit;
            }
            _textLabel.frame = CGRectMake(x, y, size.width, size.height);
            
            CGRect frame = self.frame;
            frame.size.height = _textLabel.frame.origin.y + _textLabel.frame.size.height;
            self.frame = frame;
        }
        
    } else {
        if (_autoresizingFlexibleSize) {
            CGRect frame = self.frame;
            frame.size.height = frame.size.width;
            self.frame = frame;
        }
    }
}

- (void)setModel:(SnailIconLabelModel *)model {

    _textLabel.text = model.typeName;
     NSString * url = [getBaseUrl() stringByAppendingString:model.imgSrc];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"moren"]];

    self.typeId = model.typeId;
    self.typeName = model.typeName;
}

- (void)updateLayoutBySize:(CGSize)size finished:(void (^)(SnailIconLabel *))finished {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    if (_horizontalLayout) {
        [self horizontalLayoutSubviews];
    } else {
        [self verticalLayoutSubviews];
    }
    finished(self);
}

@end

@implementation SnailIconLabelModel

+ (instancetype)modelWithTitle:(NSString *)typeName image:(NSString *)imgSrc typeCode:(NSString *)typeCode typeId:(NSInteger)typeId {

    SnailIconLabelModel *model = [[SnailIconLabelModel alloc] init];
    model.typeName = typeName;
    model.typeId = typeId;
    model.imgSrc = imgSrc;
    model.typeCode = typeCode;

    return model;
}

@end
