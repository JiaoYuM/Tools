//
//  SnailFullView.m
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "SnailFullView.h"

@interface SnailFullView () <UIScrollViewDelegate> {
    CGFloat _gap, _space;
}

@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *pageViews;

@end

@implementation SnailFullView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullViewClicked:)]];

        [self commonInitialization];
    }
    return self;
}

- (void)commonInitialization {

    _scrollContainer = [[UIScrollView alloc] init];
    _scrollContainer.bounces = NO;
    _scrollContainer.pagingEnabled = YES;
    _scrollContainer.showsHorizontalScrollIndicator = NO;
    _scrollContainer.delaysContentTouches = YES;
    _scrollContainer.delegate = self;
    [self addSubview:_scrollContainer];

    //单元格尺寸大小
    _itemSize = CGSizeMake(WIDTH/3, 80);
    _scrollContainer.size = CGSizeMake(WIDTH, _itemSize.height * ROWS + 60);
    _scrollContainer.contentSize = CGSizeMake(PAGES * WIDTH, _scrollContainer.height);
    
    _pageViews = @[].mutableCopy;
    for (NSInteger i = 0; i < PAGES; i++) {
        UIImageView *pageView = [[UIImageView alloc] init];
        pageView.size = _scrollContainer.size;
        pageView.x = i * WIDTH;
        pageView.userInteractionEnabled = YES;
        [_scrollContainer addSubview:pageView];
        [_pageViews addObject:pageView];
    }
}

- (void)setModels:(NSArray<SnailIconLabelModel *> *)models {
    
    _items = @[].mutableCopy;
    WeakSelf(SnailFullView);
    [_pageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSInteger i = 0; i < ROWS * ROW_COUNT; i++) {
            NSInteger l = i % ROW_COUNT;
            NSInteger v = i / ROW_COUNT;
            
            SnailIconLabel *item = [[SnailIconLabel alloc] init];
            [imageView addSubview:item];
            [self->_items addObject:item];
            item.tag = i + idx * (ROWS *ROW_COUNT);
            if (item.tag < models.count) {
                [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)]];
                item.model = [models objectAtIndex:item.tag];
                item.iconView.userInteractionEnabled = NO;
                item.textLabel.font = [UIFont systemFontOfSize:autoFontSize(11.0)];
                item.textLabel.textColor = colorWithString(@"#525252");
                [item updateLayoutBySize:weakSelf.itemSize finished:^(SnailIconLabel *item) {
                    item.x = self->_space + (weakSelf.itemSize.width) * l;
                    item.y = (weakSelf.itemSize.height) * v + 15;
                }];
            }
        }
    }];
    
    [self startAnimationsCompletion:NULL];
}

- (void)fullViewClicked:(UITapGestureRecognizer *)recognizer {
    __weak typeof(self) _self = self;
    [self endAnimationsCompletion:^(SnailFullView *fullView) {
        if (nil != self.didClickFullView) {
            _self.didClickFullView((SnailFullView *)recognizer.view);
        }
    }];
}

- (void)itemClicked:(UITapGestureRecognizer *)recognizer  {
    if (ROWS * ROW_COUNT - 1 == recognizer.view.tag) {
        [_scrollContainer setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
    } else {
        if (nil != self.didClickItems) {
            self.didClickItems(self, recognizer.view.tag);
        }
    }
}

- (void)startAnimationsCompletion:(void (^ __nullable)(BOOL finished))completion {
    
    [_items enumerateObjectsUsingBlock:^(SnailIconLabel *item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.alpha = 0;
        item.transform = CGAffineTransformMakeTranslation(0, ROWS * self.itemSize.height);
        [UIView animateWithDuration:0.65
                              delay:idx * 0.035
             usingSpringWithDamping:0.6
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             item.alpha = 1;
                             item.transform = CGAffineTransformIdentity;
                         } completion:completion];
    }];
}

- (void)endAnimationsCompletion:(void (^)(SnailFullView *))completion {
    
    [_items enumerateObjectsUsingBlock:^(SnailIconLabel * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIView animateWithDuration:0
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             item.alpha = 0;
                             item.transform = CGAffineTransformMakeTranslation(0, ROWS * self.itemSize.height);
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 if (idx == self->_items.count - 1) {
                                     completion(self);
                                 }
                             }
                         }];
    }];
}

@end
