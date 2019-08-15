//
//  PhotoAlbumsController.m
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/26.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "PhotoAlbumsController.h"
#import "PhotoPickerController.h"
#import "AlbumModel.h"
#import "PhotoPickerManager.h"
#import "PhotoAlbumCell.h"

@interface PhotoAlbumsController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

/**
 *  相册数组
 */
@property (nonatomic, strong) NSMutableArray *albumArray;

@end

static NSString *ID_PhotoAlbumCell = @"PhotoAlbumCell";


@implementation PhotoAlbumsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDatas];
    [self setupViews];
    
    
    PhotoPickerController *ctrl = [[PhotoPickerController alloc] init];
    AlbumModel *model = self.albumArray[0];
    //model = self.albumArray[0];
    
    ctrl.assetResult = model.assetResult;
    [self.navigationController pushViewController:ctrl animated:NO];
}



#pragma mark 数据初始化
- (void)setupDatas {
    
    [[PhotoPickerManager sharePhotoPickerManager] requestAlbumsWithType:PHAssetCollectionTypeSmartAlbum albumResult:^(NSArray *albumArray) {
        self.albumArray = [albumArray mutableCopy];
    }];
    [self.tableView reloadData];
}

#pragma mark 视图初始化
- (void)setupViews {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarBtnAction:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:autoFontSize(17)],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    // tableView
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH,HEIGHT) style:(UITableViewStyleGrouped)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[PhotoAlbumCell class] forCellReuseIdentifier:ID_PhotoAlbumCell];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.tableView];
    }
    
}

#pragma mark- UITableViewDelegate DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_PhotoAlbumCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[PhotoAlbumCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID_PhotoAlbumCell];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AlbumModel *model = self.albumArray[indexPath.row];
    
    cell.title = [NSString stringWithFormat:@"%@（%lu）",model.title,(long)model.assetResult.count];
    [[PhotoPickerManager sharePhotoPickerManager] requestImageForPHAsset:model.assetResult[0] targetSize:CGSizeMake(55, 55) imageResult:^(UIImage *image) {
        cell.img = image;
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPickerController *vc = [[PhotoPickerController alloc] init];
    AlbumModel *model = self.albumArray[indexPath.row];
    vc.assetResult = model.assetResult;
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightBarBtnAction:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

