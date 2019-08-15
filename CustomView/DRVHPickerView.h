//
//  DRVHPickerView.h
//  FinancialManager
//
//  Created by jiaoyu on 2017/7/10.
//  Copyright © 2017年 viewhigh. All rights reserved.
//
// 注释: pickView选择方法: 用于如地点,内容滚动选取;


#import <UIKit/UIKit.h>


typedef void (^DatatimeSelect)(NSString *dateStr, NSInteger typeId);
typedef void (^DataTimeCancel)(void);
@interface DRVHPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)NSArray *datasourceArr;
@property(nonatomic,strong)NSArray *keyDataArray;
@property (nonatomic,copy)NSString *dateStr;
@property (nonatomic,assign)NSInteger chooseType;
@property (strong, nonatomic) DatatimeSelect selectBlock;
@property (strong, nonatomic) DataTimeCancel cancelBlock;


- (instancetype)initWithFrame:(CGRect)frame;
-(void)selectedAtRow:(NSInteger)row inComponent:(NSInteger)component;
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end
