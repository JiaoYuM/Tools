//
//  DRVHRightSelectView.m
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/21.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "DRVHRightSelectView.h"

@interface DRVHRightSelectView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void(^action)(NSInteger index);
@property (nonatomic, strong) NSArray *imagesArr;
@property (nonatomic, strong) NSArray *dataSourceArr;
@property (nonatomic, assign) BOOL animation;
@property (nonatomic, assign) NSTimeInterval come;
@property (nonatomic, assign) NSTimeInterval go;
@end

static DRVHRightSelectView *backgroundView;
static UITableView *tableView;
static UIImageView *arrowsImage;
@implementation DRVHRightSelectView
/*
 * frame               设定tableView的位置
 * imagesArr           图片数组
 * dataSourceArr       文字信息数组
 * anchorPoint         tableView进行动画时候的锚点
 * action              通过block回调 确定菜单中 被选中的cell
 * animation           是否有动画效果
 * come                菜单出来动画的时间
 * go                  菜单收回动画的时间
 */
+ (void)configCustomPopViewWithFrame:(CGRect)frame imagesArr:(NSArray *)imagesArr dataSourceArr:(NSArray *)dataourceArr anchorPoint:(CGPoint)anchorPoint seletedRowForIndex:(void(^)(NSInteger index))action animation:(BOOL)animation timeForCome:(NSTimeInterval)come timeForGo:(NSTimeInterval)go{
    if (backgroundView) {
        [DRVHRightSelectView removed];
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景色
    backgroundView = [[DRVHRightSelectView alloc] initWithFrame:window.bounds];
    backgroundView.action = action;
    backgroundView.imagesArr = imagesArr;
    backgroundView.dataSourceArr = dataourceArr;
    backgroundView.animation = animation;
    backgroundView.come = come;
    backgroundView.go = go;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.1;
    //添加手势 点击背景能够回收菜单
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:backgroundView action:@selector(handleRemoved)];
    [backgroundView addGestureRecognizer:tap];
    [window addSubview:backgroundView];
    
    //tableView
    tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    //禁止滑动
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = backgroundView;
    tableView.dataSource = backgroundView;
    tableView.layer.anchorPoint = anchorPoint;
    tableView.layer.cornerRadius = 5;
    tableView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
    
    if (animation) {
        [UIView animateWithDuration:come animations:^{
            tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
    [window addSubview:tableView];
    arrowsImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 35, 64, 15, 10)];
    arrowsImage.image = [UIImage imageNamed:@"triangle"];
    [window addSubview:arrowsImage];
}

+ (void)removed {
    if (backgroundView.animation) {
        backgroundView.alpha = 0;
        [UIView animateWithDuration:backgroundView.go animations:^{
            tableView.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
            [arrowsImage removeFromSuperview];
            arrowsImage = nil;
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            backgroundView = nil;
            
            [tableView removeFromSuperview];
            tableView = nil;
            
        }];
    }
}

- (void)handleRemoved {
    if (backgroundView) {
        [DRVHRightSelectView removed];
    }
   
}

#pragma mark ---- UITableViewDelegateAndDatasource --
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifile = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifile];
    if (!cell) {
        //选择普通的tableviewCell 左边是图片 右边是文字
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifile];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:autoFontSize(14)];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 5, cell.contentView.frame.size.width, 0.5)];
        line.tag = 20001;
        line.backgroundColor = colorWithHexString(@"#E3E8EFff");
        [cell.contentView addSubview:line];
    }
    cell.imageView.image = [UIImage imageNamed:_imagesArr[indexPath.row]];
    cell.textLabel.text = _dataSourceArr[indexPath.row];
    if (indexPath.row == _imagesArr.count - 1) {
        UILabel *lab = [cell viewWithTag:20001];
        lab.hidden = YES;
    }else{
        UILabel *lab = [cell viewWithTag:20001];
        lab.hidden = NO;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.frame.size.height / _dataSourceArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (backgroundView.action) {
        //利用block回调 确定选中的row
        _action(indexPath.row);
        [DRVHRightSelectView removed];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
