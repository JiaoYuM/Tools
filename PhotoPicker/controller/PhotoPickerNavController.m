//
//  PhotoPickerNavController.m
//  AssetInventory
//
//  Created by 杨倩倩 on 2017/4/26.
//  Copyright © 2017年 viewhigh. All rights reserved.
//

#import "PhotoPickerNavController.h"
#import "PhotoAlbumsController.h"


@interface PhotoPickerNavController ()

@end

@implementation PhotoPickerNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:colorWithHexString(@"#519ddfff")];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    PhotoAlbumsController *vc = [[PhotoAlbumsController alloc] init];
    vc.title = @"相册";
    [self pushViewController:vc animated:NO];
    


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
