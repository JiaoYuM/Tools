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

@interface DRVHCustomCategory : NSObject

@end

@interface DRVHCustomTextField : UITextField

@end


@interface DRVHCustomTextView : UITextView

//占位文字
@property (nonatomic, copy) NSString *placeholder;
//占位文字颜色
@property (nonatomic, copy) UIColor *placeholderColor;
//占位Lab
@property (nonatomic,strong) UILabel *placeholderLabel;


@end

