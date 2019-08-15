//
//  DRVHPhotoBrowseCell.h
//  FinancialManager
//
//  Created by 杨倩倩 on 2017/5/25.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SingleTapEventBlock)(void);
@interface DRVHPhotoBrowseCell : UICollectionViewCell

@property (nonatomic,strong) id imageData;

@property (nonatomic,assign) NSInteger index;
@property (nonatomic, assign) CGFloat zoomScale;

@property (nonatomic, strong) SingleTapEventBlock singleTapEvent;

//
-(void)saveImage;

@end
