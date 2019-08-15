//
//  PhotoPreViewViewController.m
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/27.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "PhotoPreviewController.h"

#import <Photos/Photos.h>

#import "PhotoPreviewNavBar.h"
#import "PhotoPickerToolBar.h"
#import "PhotoPreviewCell.h"

#import "PhotoPicker.h"

@interface PhotoPreviewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PhotoPickerToolBar *toolBar;
@property (nonatomic, strong) PhotoPreviewNavBar *navBar;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableArray *pickedArray;
@property (nonatomic, strong) PhotoModel *operatingModel;

@end

static NSString *ID_PreviewPhotoCell = @"PreviewPhotoCell";


@implementation PhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDatas];
    [self setupViews];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 数据初始化
- (void)setupDatas {
    
    self.pickedArray = [NSMutableArray array];
    
    for (PhotoModel *model in self.previewArray) {
        if (model.isPicked) {
            [self.pickedArray addObject:model];
        }
    }
    [self.collectionView reloadData];
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
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT ) collectionViewLayout:layout];
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[PhotoPreviewCell class] forCellWithReuseIdentifier:ID_PreviewPhotoCell];
        self.collectionView.backgroundColor = [UIColor whiteColor];
      
        self.operatingModel = [self.previewArray lastObject];
        self.collectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        [self.view addSubview:self.collectionView];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.curIndex inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
        
    }
    
    {
        
        self.navBar = [[PhotoPreviewNavBar alloc] init];
        self.navBar.delegate = self;
        self.operatingModel = self.previewArray[self.curIndex];
        
        if (self.title.length == 0) {
            self.navBar.leftBtnTitle = @"";
        }
        self.navBar.barTitle = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)self.curIndex + 1,(unsigned long)self.previewArray.count];
        
        if (self.operatingModel.isPicked) {
            
            [self.navBar setRightBtnTitleIndex:self.operatingModel.pickedIndex];
        }
        [self.view addSubview:self.navBar];
        
    }
    
    // toolBar
    {
        self.toolBar = [[PhotoPickerToolBar alloc] init];
        self.toolBar.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.3];
        self.toolBar.rightBtn.backgroundColor = [UIColor colorWithRed:46/255.0 green:178/255.0 blue:242/255.0 alpha:1];
        [self.toolBar.rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        self.toolBar.leftBtn.hidden = YES;
        [self.toolBar.rightBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:self.toolBar];
    }
}

#pragma mark- UICollectionViewDelegate DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.previewArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID_PreviewPhotoCell forIndexPath:indexPath];
    cell.zoomScale = 1.0;
    PhotoModel *model = self.previewArray[indexPath.item];

    cell.asset = model.asset;
    cell.singleTapEvent = ^(){
        [self.toolBar changeHideState];
        [self.navBar changeHideState];

        if (self.toolBar.barHide) {

            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
            [UIApplication sharedApplication].statusBarHidden = YES;

        }else{
            
            self.collectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
             [UIApplication sharedApplication].statusBarHidden = NO;
        }
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(WIDTH, HEIGHT);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = (NSInteger)scrollView.contentOffset.x / WIDTH;
    
    self.operatingModel = self.previewArray[index];
    
    self.navBar.barTitle = [NSString stringWithFormat:@"%zd/%zd",index  + 1,self.previewArray.count];
    [self.navBar setRightBtnTitleIndex:self.operatingModel.pickedIndex];
    
}

#pragma mark- 点击事件


#pragma mark 单选框点击（SJ...NavBarDelegate）
- (void)rightBtnAction:(UIButton *)sender {
    
    self.operatingModel.isPicked = !self.operatingModel.isPicked;
    
    // 代理传值
    [self.delegate pickedArrayChangeWithModel:self.operatingModel];
    
    if (self.operatingModel.isPicked) {
        
        NSInteger pickedIndex = self.pickedArray.count + 1;
        self.operatingModel.pickedIndex = pickedIndex;
        [self.pickedArray addObject:self.operatingModel];
        [self.navBar setRightBtnTitleIndex:pickedIndex];
    }
    else {
        [self.pickedArray removeObject:self.operatingModel];
        
        self.operatingModel.pickedIndex = 0;
        for (int i = 0; i < self.pickedArray.count; i ++) {
            PhotoModel *model = self.pickedArray[i];
            model.pickedIndex  = i + 1;
        }
        [self.navBar setRightBtnTitleIndex:0];
    }
}

#pragma mark 确定按钮
- (void)sureBtnAction:(UIButton *)sender {
    NSMutableArray *assetArray = [NSMutableArray array];
    for (PhotoModel *model in self.pickedArray) {
        PHAsset *asset = model.asset;
        [assetArray addObject:asset];
    }
    
    PhotoPicker *photoPicker = [PhotoPicker sharePhotoPicker];
    photoPicker.photoPickerBlock(assetArray);
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
