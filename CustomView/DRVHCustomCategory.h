//
//  DRVHCustomCategory.h
//  FinancialManager
//
//  Created by 洪宾王 on 2017/10/9.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

// 以后自定义控件所有的分类写在这里:
// 目前已经定义一个textField的样式;主要是设置了内容,文本的便宜

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,textFiledType) {
    
    textFiledTypeNum = 0,//普通数字
    textFiledTypeStr = 1,//字符串
    textFiledTypePhoneNum = 2//电话号码
    
};

@interface DRVHCustomCategory : NSObject

@end

@interface DRVHCustomTextField : UITextField

@property (nonatomic, assign) textFiledType fieldType;
//最大小数位数
@property (nonatomic, assign) NSInteger maxLimited;
//最大值(数字型)
@property (nonatomic, assign) CGFloat maxValue;
//最大字符数(字符型)
@property (nonatomic, assign) CGFloat maxLenth;
//提示语
@property (nonatomic, copy) NSString *tipMessage;

@end


@interface DRVHCustomTextView : UITextView

//占位文字
@property (nonatomic, copy) NSString *placeholder;
//占位文字颜色
@property (nonatomic, copy) UIColor *placeholderColor;
//占位Lab
@property (nonatomic,strong) UILabel *placeholderLabel;
//可输入的最大长度
@property (nonatomic, assign) NSInteger textMaxLenth;
//超过规定提示信息
@property (nonatomic, copy) NSString *tipMessage;
//当完成编辑时候的回调
@property (nonatomic, copy) void(^textValueEndBlock)(NSString *textValue);
//当编辑时候的回调
@property (nonatomic, copy) void(^textValueChangedBlock)(NSString *textValue);

@end


typedef enum : NSUInteger {
    myVerticalAlignmentNone = 0,
    myVerticalAlignmentCenter,
    myVerticalAlignmentTop,
    myVerticalAlignmentBottom
} myVerticalAlignment;

@interface VerticalCenterTextLabel : UILabel

@property (nonatomic) UIEdgeInsets edgeInsets;
//对其方式
@property (nonatomic) myVerticalAlignment verticalAlignment;

@end

