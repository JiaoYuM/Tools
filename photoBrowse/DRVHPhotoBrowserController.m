//
//  DRVHPhotoBrowserController.m
//  FinancialManager
//
//  Created by 杨倩倩 on 2017/5/25.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "DRVHPhotoBrowserController.h"
#import "PhotoPickerToolBar.h"
#import "PhotoPreviewNavBar.h"
#import "PhotoPreviewCell.h"
#import "DRVHPhotoBrowseCell.h"
#import "PhotoBrowseToolBar.h"
#import "DRVHBrowseNavBar.h"

@interface DRVHPhotoBrowserController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PhotoBrowseToolBar *toolBar;
@property (nonatomic,strong) DRVHBrowseNavBar *navBar;

@end
static NSString *cellId = @"PhotoCell";
@implementation DRVHPhotoBrowserController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"图片浏览";
    [self setupViews];
    self.view.backgroundColor = [UIColor blackColor];
    
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark 视图初始化
- (void)setupViews {
    
    // collectionView
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        layout.itemSize = CGSizeMake(WIDTH, HEIGHT);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(WIDTH, HEIGHT);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT ) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.bounces = NO;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[DRVHPhotoBrowseCell class] forCellWithReuseIdentifier:cellId];
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        
        [self.view addSubview:self.collectionView];
        [self.collectionView reloadData];
       
    }
    // toolBar
    {
         _toolBar = [[PhotoBrowseToolBar alloc] initWithFrame:CGRectMake(0, HEIGHT - ToolBarHeight, self.view.bounds.size.width, ToolBarHeight)];
        self.toolBar.text = [NSString stringWithFormat:@"%zd/%zd",self.curIndex + 1,self.previewArray.count];
        [self.toolBar show];
            __weak typeof(self)weekSelf = self;
            [_toolBar addSaveBlock:^{
                [weekSelf saveImage];
            }];
        [self.view addSubview:self.toolBar];
    }
    self.navBar = [[DRVHBrowseNavBar alloc] init];
    self.navBar.delegate = self;
    self.navBar.barTitle = @"图片浏览";
    [self.view addSubview:self.navBar];

     [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.curIndex inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
}

#pragma mark- UICollectionViewDelegate DataSource
#pragma mark-
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.previewArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DRVHPhotoBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
   cell.zoomScale = 1.0;
    cell.imageData = self.previewArray[indexPath.row];
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    cell.singleTapEvent = ^(){
        if (self.toolBar.alpha == 0) {
            [self.toolBar show];
         self.collectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        [UIApplication sharedApplication].statusBarHidden = NO;

        }else{
            [self.toolBar hide];

            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
            [UIApplication sharedApplication].statusBarHidden = YES;
        }
        [self.navBar changeHideState];
        
    };
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = (NSInteger)scrollView.contentOffset.x / WIDTH;
    self.toolBar.text = [NSString stringWithFormat:@"%zd/%zd",index + 1,self.previewArray.count];
    self.curIndex = index;
    
}

#pragma mark- 点击事件

#pragma mark -
#pragma mark 存储图片方法
-(void)saveImage{
    DRVHPhotoBrowseCell *item = (DRVHPhotoBrowseCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.curIndex inSection:0]];
    [item saveImage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
