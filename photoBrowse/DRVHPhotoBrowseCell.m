//
//  DRVHPhotoBrowseCell.m
//  FinancialManager
//
//  Created by 杨倩倩 on 2017/5/25.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "DRVHPhotoBrowseCell.h"
#import "PhotoPickerManager.h"

static CGFloat maxZoomScale = 2.5f;
static CGFloat minZoomScale = 1.0f;

@interface DRVHPhotoBrowseCell()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation DRVHPhotoBrowseCell
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
    self.scrollView.backgroundColor = [UIColor blackColor];
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

- (void)setImageData:(id)imageData{
    if ([imageData isKindOfClass:[UIImage class]])
        self.imgView.image = imageData;
    else if ([imageData isKindOfClass:[PHAsset class]]){
        
        [[PhotoPickerManager sharePhotoPickerManager] requestImageForPHAsset:imageData targetSize:PHImageManagerMaximumSize imageResult:^(UIImage *image) {
            if (image) {
                self.imgView.image = image;
            }
        }];

        
    }
    else if ([imageData isKindOfClass:[NSString class]])
    {
        NSString *imageUrl = (NSString *)imageData;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeHold_image"]];
    }
    else
        
        NSLog(@"ERROR：图片数据错误 %@", imageData);
}

#pragma mark -
#pragma mark ScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imgView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self updateImageFrame];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scale != 1) {return;}
    CGFloat height = [self imageViewFrame].size.height > _scrollView.bounds.size.height ? [self imageViewFrame].size.height : _scrollView.bounds.size.height + 1;
    _scrollView.contentSize = CGSizeMake(_imgView.bounds.size.width, height);
}
#pragma mark ImageView设置Frame相关方法
-(void)updateImageFrame
{
    CGRect imageFrame = _imgView.frame;
    
    if (imageFrame.size.width < self.bounds.size.width) {
        imageFrame.origin.x = (self.bounds.size.width - imageFrame.size.width)/2.0f;
    }else{
        imageFrame.origin.x = 0;
    }
    
    if (imageFrame.size.height < self.bounds.size.height) {
        imageFrame.origin.y = (self.bounds.size.height - imageFrame.size.height)/2.0f;
    }else{
        imageFrame.origin.y = 0;
    }
    
    if (!CGRectEqualToRect(_imgView.frame, imageFrame)){
        _imgView.frame = imageFrame;
    }
}
-(CGRect)imageViewFrame
{
    if (!_imgView.image) {
        return _scrollView.bounds;
    }
    UIImage *image = _imgView.image;
    CGFloat width = self.bounds.size.width;
    CGFloat height = width * image.size.height/image.size.width;
    CGFloat y = height < self.bounds.size.height ? (self.bounds.size.height - height)/2.0f : 0;
    return CGRectMake(0, y, width, height);
}

- (void)singleTapGestureAction:(UITapGestureRecognizer *)sender {
    
    self.singleTapEvent();
    
}

- (void)doubleTapGestureAction:(UITapGestureRecognizer *)sender {

    //已经放大后 双击还原 未放大则双击放大
        CGFloat zoomScale = _scrollView.zoomScale != minZoomScale ? minZoomScale : maxZoomScale;
        [_scrollView setZoomScale:zoomScale animated:true];
    
}

-(void)saveImage{
    
    if (!self.imgView.image) {return;}
    UIImageWriteToSavedPhotosAlbum(self.imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error != NULL){
        return;
    }
    NSLog(@"图片存储成功");
    [SVProgressHUD showSuccessWithStatus:@"图片存储成功"];
//    [XLImageLoading showAlertInView:self message:@"图片存储成功"];
}



@end
