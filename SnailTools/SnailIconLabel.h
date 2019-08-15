//
//  SnailIconLabel.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2016/9/26.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SnailIconLabelModel;

@interface SnailIconLabel : UIControl

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) void(^imageBlock)(void);


// UIEdgeInsets insets = {top, left, bottom, right}
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets; // default = UIEdgeInsetsZero 使用insets.bottom或insets.right来调整间距

@property (nonatomic, assign) BOOL horizontalLayout; // default is NO.

@property (nonatomic, assign) BOOL autoresizingFlexibleSize; // default is NO. 根据内容适应自身高度

@property (nonatomic, assign) CGFloat sizeLimit; // textLabel根据文本计算size时，如果纵向布局则限高，横向布局则限宽

@property (nonatomic, strong) SnailIconLabelModel *model;

- (void)updateLayoutBySize:(CGSize)size finished:(void (^)(SnailIconLabel *item))finished; // 属性赋值后需更新布局

@end

@interface SnailIconLabelModel : NSObject

//以下是接口返回数据
//图片
@property (nonatomic, copy) NSString *imgSrc;
//code
@property (nonatomic, copy) NSString *typeCode;
//id
@property (nonatomic, assign) NSInteger typeId;
//借款名称
@property (nonatomic, copy) NSString *typeName;

+ (instancetype)modelWithTitle:(NSString *)typeName image:(NSString *)imgSrc typeCode:(NSString *)typeCode typeId:(NSInteger)typeId;

@end
