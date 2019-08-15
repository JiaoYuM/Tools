//
//  DRVHPickerView.m
//  FinancialManager
//
//  Created by jiaoyu on 2017/7/10.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "DRVHPickerView.h"

@interface DRVHPickerView ()
@property (nonatomic,strong)UIToolbar *actionToolbar;
@end

@implementation DRVHPickerView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 216)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickerView];
        self.backgroundColor = [UIColor whiteColor];
        _actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        _actionToolbar.barStyle = UIBarStyleDefault;
        [_actionToolbar sizeToFit];
        
        _actionToolbar.layer.borderWidth = 0.35f;
        _actionToolbar.layer.borderColor = [[UIColor colorWithWhite:.8 alpha:1.0] CGColor];
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(actionCancel:)];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(actionDone:)];
        
        [_actionToolbar setItems:[NSArray arrayWithObjects:cancelItem,flexSpace,doneItem, nil] animated:YES];
        [self addSubview:_actionToolbar];
        
    }
    
    return self;
}

-(void)setDatasourceArr:(NSArray *)datasourceArr{
    _datasourceArr = datasourceArr;
    [self.pickerView reloadComponent:0];
}

-(void)setKeyDataArray:(NSArray *)keyDataArray{
    _keyDataArray = keyDataArray;

}
#pragma mark --UIPickerViewDelegate
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    
    return 1;
}
//行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.datasourceArr.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return self.pickerView.width;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *l = (UILabel *)view;
    if (!l) {
        l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
    }
    l.backgroundColor = [UIColor clearColor];
    [l setFont:[UIFont systemFontOfSize:23]];
    UIColor *textColor = [UIColor blackColor];
    l.text = self.datasourceArr[row];
    l.textColor = textColor;
    return l;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.dateStr = self.datasourceArr[row];
    self.chooseType = [self.keyDataArray[row] integerValue];
}
- (void)actionCancel:(id)sender
{
    if (_cancelBlock) {
        _cancelBlock();
    }
    [self hidden];
}

- (void)actionDone:(id)sender
{
    //    [self hidden];
    //确定
    if (_selectBlock) {
        _selectBlock(self.dateStr,self.chooseType);
    }
    [self hidden];
    
}

-(void)Dismiss
{
    [UIView animateWithDuration:0.35  animations:^{
        [self setFrame:CGRectMake(0,
                                  800+ self.frame.size.height,
                                  self.frame.size.width,
                                  216)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)hidden{
    if (!self.superview) {
        return;
    }
    [self Dismiss];
}

-(void)selectedAtRow:(NSInteger)row inComponent:(NSInteger)component{
    [_pickerView selectRow:row inComponent:component animated:NO];
}



@end
