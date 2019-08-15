//
//  DRVHNetworkView.h
//  failureport
//
//  Created by 洪宾王 on 2018/2/2.
//  Copyright © 2018年 viewhigh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, placeholderViewType) {
    //**不用任何显示*/
    placeholderSetNull = 1,
    /** 没网 */
    placeholderViewTypeNoNetwork = 2,
    //** 数据为空/
    placeholderViewTypeEmpty = 3,
    //**搜索数据为空/
    placeholderViewTypeSearchDataEmpty = 4
    
};

#pragma mark - @protocol

@class DRVHNetworkView;

@protocol DRVHNetworkViewDelegate <NSObject>

@optional
/** 占位图的重新加载按钮点击时回调 */
- (void)placeholderViewReloadButtonDidClick:(DRVHNetworkView *)placeholderView;

@end

@interface DRVHNetworkView : UIView
///** 占位图类型（只读） */
@property (nonatomic, assign)placeholderViewType placeholderType;
/** 占位图的代理方 */
@property (nonatomic, weak) id <DRVHNetworkViewDelegate> delegate;
//提示lab
@property (nonatomic,strong) UILabel *tipLab;

/** 构造方法 */
- (instancetype)initWithFrame:(CGRect)frame
                         type:(placeholderViewType)placeholderType message:(NSString *)message
                     delegate:(id)delegate;

/**根据传入的高度,变形*/
- (instancetype)initWithFrame:(CGRect)frame placeholderY:(CGFloat)placeholderY scale:(CGFloat)scale type:(placeholderViewType)placeholderType message:(NSString *)message delegate:(id)delegate ;

@end

