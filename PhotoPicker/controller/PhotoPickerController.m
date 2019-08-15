//
//  PhotoPickerController.m
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/26.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "PhotoPickerController.h"
#import "PhotoModel.h"
#import "PhotoPickerToolBar.h"
#import "PhotoPickerCell.h"
#import "PhotoPicker.h"
#import "PhotoPreviewController.h"

#define Image_W (WIDTH - 15.0) / 4.0

@interface PhotoPickerController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PhotoPreviewControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PhotoPickerToolBar *toolBar;
/**
 *  所有照片
 */
@property (nonatomic, strong) NSMutableArray<PhotoModel *> *photoArray;
/**
 *  选择的照片
 */
@property (nonatomic, strong) NSMutableArray<PhotoModel *> *pickedArray;
@end

static NSString *ID_PickPhotoCell = @"PickPhotoCell";
@implementation PhotoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDatas];
    [self setupViews];
//    self.title = @"相机胶卷";
    // Do any additional setup after loading the view.
}

#pragma mark 数据初始化
- (void)setupDatas {
    // photoArray
    {
        self.photoArray = [NSMutableArray array];
        
        for (PHAsset *asset in self.assetResult) {
            PhotoModel *model = [[PhotoModel alloc] init];
            model.asset = asset;
            model.inAlbumIndex = self.photoArray.count;
            model.pickedIndex = 0;
            model.isPicked = NO;
            [self.photoArray addObject:model];
        }
        [self.collectionView reloadData];
    }
    // pickedArray
    {
        self.pickedArray = [NSMutableArray array];
    }
}

#pragma mark 视图初始化
- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.title.length == 0) {
        self.title = @"所有照片";
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarBtnAction:)];
    
    // collectionView
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.0f;
        layout.minimumInteritemSpacing = 0.0f;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, WIDTH, HEIGHT - 49) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[PhotoPickerCell class] forCellWithReuseIdentifier:ID_PickPhotoCell];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.pagingEnabled = NO;
        [self.view addSubview:self.collectionView];
    }
    
    // toolBar
    {
        self.toolBar = [[PhotoPickerToolBar alloc] init];
        [self.toolBar.leftBtn addTarget:self action:@selector(previewPhotoAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.toolBar.rightBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:self.toolBar];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- UICollectionViewDelegate DataSource
#pragma mark-
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID_PickPhotoCell forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor yellowColor];
    
    PhotoModel *model = self.photoArray[indexPath.row];
    [cell setModel:model];
    
    __weak typeof(cell) weakCell = cell;
    
    cell.pickBtnBlock = ^(PhotoModel *curPickModel) {
        [self changeCell:weakCell WithModel:curPickModel];
    };
    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Image_W, Image_W);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPreviewController *vc = [[PhotoPreviewController alloc] init];
    vc.delegate = self;
    vc.curIndex = indexPath.row;
    vc.previewArray = [self.photoArray mutableCopy];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- 点击事件
#pragma mark-

#pragma mark 预览
- (void)previewPhotoAction:(UIButton *)sender {
    
    if (self.pickedArray.count > 0) {
        
        PhotoPreviewController *vc = [[PhotoPreviewController alloc] init];
        vc.delegate = self;
//        vc.curIndex = self.pickedArray.count - 1;
        vc.curIndex = 0;
        vc.previewArray = [self.pickedArray mutableCopy];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 取消
- (void)rightBarBtnAction:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 确定
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

#pragma mark- 其他方法
#pragma mark-

#pragma mark 通过改变改变model值，改变cell状态
- (void)pickedArrayChangeWithModel:(PhotoModel *)model {
    
    NSIndexPath *changedIndexP =[NSIndexPath indexPathForItem:model.inAlbumIndex inSection:0];
    PhotoPickerCell *changedCell = (PhotoPickerCell *)[self.collectionView cellForItemAtIndexPath:changedIndexP];
    [self changeCell:changedCell WithModel:model];
}



- (void)changeCell:(PhotoPickerCell *)changedCell WithModel:(PhotoModel *)changedModel {
    
    if (changedModel.isPicked) {
        
        [changedCell modelChangePickedIndex:self.pickedArray.count + 1];
        [self.pickedArray addObject:changedModel];
        
    }
    else {
        
        [self.pickedArray removeObject:changedModel];
        
        // 更新剩下选择的图片
        for (int i = 0; i < self.pickedArray.count; i ++) {
            
            PhotoModel *otherPickedModel = self.pickedArray[i];
            
            if (otherPickedModel.pickedIndex > changedModel.pickedIndex) {
                
                otherPickedModel.pickedIndex -= 1;
                
                NSIndexPath *indexP =[NSIndexPath indexPathForItem:otherPickedModel.inAlbumIndex inSection:0];
                PhotoPickerCell *otherCell = (PhotoPickerCell *)[self.collectionView cellForItemAtIndexPath:indexP];
                
                [otherCell modelChangePickedIndex:otherPickedModel.pickedIndex];
                
            }
        }
        // 更新 取消选择的图片
        [changedCell modelChangePickedIndex:0];
    }
    
    // 更改工具栏状态信息
    [self.toolBar changePickedIndex:self.pickedArray.count];
}


@end
