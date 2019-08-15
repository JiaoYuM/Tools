//
//  PhotoPreViewCell.m
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/27.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "PhotoPreviewCell.h"
#import "PhotoPickerManager.h"

@interface PhotoPreviewCell() <UIScrollViewDelegate>



@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation PhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 4.0;
    self.scrollView.minimumZoomScale = 1.0;
    
    self.scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT);
    [self.contentView addSubview:self.scrollView];
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.imgView];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureAction:)];
    [self.scrollView addGestureRecognizer:singleTapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureAction:)];
    [doubleTapGesture setNumberOfTapsRequired:2]; // Default is 1
    [self.scrollView addGestureRecognizer:doubleTapGesture];
    
    // 如果满足双击条件，单击事件触发失败，防止双击时单击事件同时被触发
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
}

- (void)setAsset:(PHAsset *)asset {
    
    _asset = asset;
    
    [[PhotoPickerManager sharePhotoPickerManager] requestImageForPHAsset:asset targetSize:PHImageManagerMaximumSize imageResult:^(UIImage *image) {
        if (image) {
            self.imgView.image = image;
//            CGFloat scale_H = HEIGHT / image.size.height;
//            CGFloat scale_W = WIDTH / image.size.width;
//            
//            CGSize size;
//            if (scale_H > scale_W) {
//                size = CGSizeMake(WIDTH, scale_W * image.size.height);
//            }
//            else  if (scale_H < scale_W) {
//                size = CGSizeMake(scale_H * image.size.width, HEIGHT);
//            }
//            self.imgView.frame = CGRectMake(0, 0, size.width, size.height);
            self.imgView.center = self.scrollView.center;
        }
    }];
}


- (void)setZoomScale:(CGFloat)zoomScale {
    _zoomScale = zoomScale;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.zoomScale = zoomScale;
    }];
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGSize viewSize = self.imgView.frame.size;
    CGPoint centerPoint = CGPointZero;
    
    if (viewSize.width<=CGRectGetWidth(self.bounds) && viewSize.height<=CGRectGetHeight(self.bounds)) {
        centerPoint = CGPointMake(CGRectGetWidth(self.bounds)*0.5f, CGRectGetHeight(self.bounds)*0.5f);
        
    }else if (viewSize.width>=CGRectGetWidth(self.bounds) && viewSize.height>=CGRectGetHeight(self.bounds) ){
        centerPoint = CGPointMake(scrollView.contentSize.width*0.5f, scrollView.contentSize.height*0.5f);
        
    }else if (viewSize.width<=CGRectGetWidth(self.bounds) && viewSize.height>=CGRectGetHeight(self.bounds) ){
        centerPoint = CGPointMake(CGRectGetWidth(self.bounds)*0.5f, scrollView.contentSize.height*0.5f);
        
    }else if (viewSize.width>=CGRectGetWidth(self.bounds) && viewSize.height<=CGRectGetHeight(self.bounds)){
        centerPoint = CGPointMake(scrollView.contentSize.width*0.5f, CGRectGetHeight(self.bounds)*0.5f);
    }
    self.imgView.center = centerPoint;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}

- (void)singleTapGestureAction:(UITapGestureRecognizer *)sender {
    
    self.singleTapEvent();
    
}

- (void)doubleTapGestureAction:(UITapGestureRecognizer *)sender {
    if (self.zoomScale == 4) {
        self.zoomScale = 1;
    }else {
        CGFloat newScale = self.zoomScale * 2.0f;
        self.zoomScale = newScale;
    }
    
}


@end
