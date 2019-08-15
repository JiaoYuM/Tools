//
//  DRVHCustomCategory.m
//  FinancialManager
//
//  Created by 洪宾王 on 2017/10/9.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "DRVHCustomCategory.h"

@implementation DRVHCustomCategory

@end

// 以下是自定义textField
@implementation DRVHCustomTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;
    iconRect.origin.y += 0.5;
    return iconRect;
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
            self.placeholderLabel  = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 0)];
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
        [self.placeholderLabel  sizeToFit];
        [self sendSubviewToBack:self.placeholderLabel ];
    }
    
    if ([[self text] length] == 0 && [[self placeholder] length] > 0) {
        [[self viewWithTag:999] setAlpha:1];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
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
@end



//如果再有则放置其他内容





