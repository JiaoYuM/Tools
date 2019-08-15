//
//  DRVHCustomCategory.m
//  FinancialManager
//
//  Created by 洪宾王 on 2017/10/9.
//  Copyright © 2017年 viewhigh. All rights reserved.
//



#import "DRVHCustomCategory.h"
#import "NSString+extend.h"

@implementation DRVHCustomCategory

@end

@interface UITextField()<UITextFieldDelegate>

@end
// 以下是自定义textField
@implementation DRVHCustomTextField {
    BOOL isHaveDian;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;
    iconRect.origin.y += 0.5;
    return iconRect;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        //默认是数字
        self.fieldType = textFiledTypeNum;
    }
    return self;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.fieldType == textFiledTypeNum) {
        
        if ([textField.text doubleValue] == 0) {
            [textField setText:@""];
        }else{
            if ([textField.text doubleValue] == [textField.text integerValue]) {
                [textField setText: [NSString stringWithFormat:@"%zd",[textField.text integerValue]]];
            }
        }
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableString  *futureString = [NSMutableString stringWithString:textField.text];
    //计算变化值之前的字符串长度和变化后的字符串长度
    NSString *orginStr = futureString.mutableCopy;
    [futureString  insertString:string atIndex:range.location];
    
    // NSLog(@"%@",futureString);
    
    if (self.fieldType == textFiledTypeStr) {
        
        //控制字符
        if (futureString.length > self.maxLenth && string.length != 0) {
            
            if (self.tipMessage.length == 0) {
                [SVProgressHUD showInfoWithStatus:@"字数达到上限"];
            }else {
                [SVProgressHUD showInfoWithStatus:self.tipMessage];
            }
            return  NO;
        }
    }else if (self.fieldType == textFiledTypePhoneNum) {
        
        // 代理方法检测电话号码输入长度,本次不对前缀158,等判断,仅仅判断
        
        if([orginStr hasPrefix:@"1"]){
            
            if (futureString.length > 11) {
                [SVProgressHUD showErrorWithStatus:@"手机格式不正确"];
                return NO;
            }
        }else {
            
            if (futureString.length > 13) {
                [SVProgressHUD showErrorWithStatus:@"电话号码格式不正确"];
                return NO;
            }
        }
        
    }else {
        
        if (self.maxValue == 0) {
            //如果外面不设置金额,默认10个9
            self.maxValue = 9999999999;
        }
        //控制数字型
        if ([futureString doubleValue] > self.maxValue && string.length != 0) {
            
            if (self.tipMessage.length == 0) {
                [SVProgressHUD showInfoWithStatus:@"请输入正确位数"];
            }else {
                [SVProgressHUD showInfoWithStatus:self.tipMessage];
            }
            return NO;
            
            // if (orginStr.length == futureString.length) { };
        }
        //2018-01-23 新增
        if ([futureString hasPrefix:@"."]) {
            return NO;
        }else if ([futureString hasPrefix:@"0"] && futureString.length == 2 && ![string isEqualToString:@"0"] && ![string isEqualToString:@"."]) {
            //如果是以0开头的,并且不是小数;那么默认取后面的数值
            textField.text = string;
            return NO;
        }else if ([futureString hasPrefix:@"0"] && futureString.length == 2 && [string isEqualToString:@"0"]){
            //如果输入2个00,默认是0
            return NO;
        }
        
        if ([textField.text containsString:@"."] && [string isEqualToString:@"."]) {
            return NO;
        }
        
        if ([futureString containsString:@"."]) {
            
            if (self.maxLimited == 0) {
                //如果外面不设置长度,默认设置成2位;否则就是对外的属性长度
                self.maxLimited = 2;
            }
            
            NSRange douRange = [futureString rangeOfString:@"."];
            //小数点后面的位数
            NSString *residueStr = [futureString substringFromIndex:(NSInteger)douRange.location];
            
            if ((residueStr.length - 1) > self.maxLimited && string.length != 0) {
                
                return NO;
            }
        }
    }
    
    if ([NSString isInputRuleNotBlank:string]) {
        return  YES;
    }
    if ([string containsEmoji]) {
        return NO;
    }
    
    
    return YES;
}

@end

@interface UITextView()<UITextViewDelegate>

@end

//以下是自定义textView
@implementation DRVHCustomTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.placeholder = @"请输入...";
        self.placeholderColor = [UIColor lightGrayColor];
        self.delegate = self;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    if ([[self placeholder] length] > 0) {
        if (self.placeholderLabel == nil) {
            self.placeholderLabel  = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 21)];
            self.placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.placeholderLabel.numberOfLines = 0;
            self.placeholderLabel.font = self.font;
            self.placeholderLabel.backgroundColor = [UIColor clearColor];
            self.placeholderLabel.alpha = 0;
            self.placeholderLabel.tag = 999;
            [self addSubview:self.placeholderLabel ];
        }
        
        self.placeholderLabel.text = self.placeholder;
        self.placeholderLabel.textColor = self.placeholderColor;
        //        [self.placeholderLabel  sizeToFit];
        [self sendSubviewToBack:self.placeholderLabel ];
    }
    
    if (([[self text] length] == 0 && [[self placeholder] length] > 0) || self.placeholderLabel.alpha != 0) {
        
        [[self viewWithTag:999] setAlpha:1];
        
    }else {
        
        [[self viewWithTag:999] setAlpha:0];
    }
}

//编辑中调动
- (void)textViewDidChange:(UITextView *)textView {
    
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(textView.text);
    }
    
    if ([[self placeholder] length] == 0) {
        return;
    }
    if ([[self text] length] == 0) {
        [[self viewWithTag:999] setAlpha:1];
    }
    else {
        [[self viewWithTag:999] setAlpha:0];
    }
    
}

//编辑完毕调用
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (self.textValueEndBlock) {
        self.textValueEndBlock(textView.text);
    }
}


//控制输入的内容
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSMutableString  *futureString = [NSMutableString stringWithString:textView.text];
    [futureString  insertString:text atIndex:range.location];
    
    NSInteger default_length = 0;
    
    if (self.textMaxLenth == 0 ) {
        default_length = 200;
    }else {
        default_length = self.textMaxLenth;
    }
    
    //控制字符
    if (futureString.length > default_length && text.length != 0) {
        
        if (self.tipMessage.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"字数达到上限"];
        }else {
            [SVProgressHUD showInfoWithStatus:self.tipMessage];
        }
        return  NO;
    }
    
    //这个判断放在前面
    if ([NSString isInputRuleNotBlank:text]) {
        
        return YES;
    }
    if ([text containsEmoji]) {
        
        return NO;
    }
    
    return YES;
}

@end


//对于文字对其方式
@implementation VerticalCenterTextLabel

- (void)setVerticalAlignment:(myVerticalAlignment)verticalAlignment
{
    _verticalAlignment= verticalAlignment;
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect
{
    if (_verticalAlignment == myVerticalAlignmentNone)
    {
        [super drawTextInRect:UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets)];
    }
    else
    {
        CGRect textRect = [self textRectForBounds:UIEdgeInsetsInsetRect(rect, self.edgeInsets) limitedToNumberOfLines:self.numberOfLines];
        [super drawTextInRect:textRect];
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (_verticalAlignment) {
        case myVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
            
        case myVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
            
        case myVerticalAlignmentCenter:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
            break;
            
        default:
            break;
    }
    return textRect;
}
@end



//如果再有则放置其他内容





