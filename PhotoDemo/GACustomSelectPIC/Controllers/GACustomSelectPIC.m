//
//  GACustomSelectPIC.m
//  PhotoDemo
//
//  Created by Gamin on 2018/10/29.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import "GACustomSelectPIC.h"
#import "GACustomSelectPICCell.h"
#import "GACustomSelectPICModel.h"
#import "GACustomAlbumList.h"
#import "UIView+Toast.h"

@interface GACustomSelectPIC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataMArr;

@end

@implementation GACustomSelectPIC

- (void)dealloc {
    _dataMArr = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片选择器";
    
    [_tableView setSeparatorStyle:NO];
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 获取系统的权限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [self getAllAlbumInfo];
        } else {
            // 提示用户去打开授权
            [self.view makeToast:@"进入设置界面->找到当前应用->打开允许访问相册开关"];
            return;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    GASelectCountShare *shareCount = [GASelectCountShare sharedSelectCountMethod];
    if (shareCount.saveSelectPics && shareCount.saveSelectPics.count > 0) {
        shareCount.selectCount = shareCount.saveSelectPics.count;
    } else {
        shareCount.selectCount = 0;
    }
    shareCount.limitMaxNumber = _tempLimitMax;
}

// 获取相册
- (void)getAllAlbumInfo {
    if (!_dataMArr) {
        _dataMArr = [NSMutableArray new];
    }
    // 获取手机内所有的相册
    PHFetchResult *sysfetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历相册
    for (PHAssetCollection *assetCollection in sysfetchResult) {
        NSString *collectionTitle = assetCollection.localizedTitle;
        NSArray *assets = [self getAssetWithCollection:assetCollection];
        if (!(assets.count > 0)) {
            continue;
        }
        NSMutableArray *selectMArr = [NSMutableArray new];
        for (PHAsset *subAsset in assets) {
            if (subAsset.mediaType == self.selectMediaType) {
                [selectMArr addObject:subAsset];
            }
        }
        GACustomSelectPICModel *model = [GACustomSelectPICModel new];
        model.title = collectionTitle;
        model.count = selectMArr.count;
        model.assetArray = selectMArr;
        [_dataMArr addObject:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

// 获取相册所有图片的信息
- (NSArray *)getAssetWithCollection:(PHAssetCollection *)collection {
    // fetchoptions
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    // search
    NSMutableArray *assetArray = [NSMutableArray array];
    PHFetchResult *assetFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    for (PHAsset *asset in assetFetchResult) {
        [assetArray addObject:asset];
    }
    return assetArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GACustomSelectPICCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GACustomSelectPICCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GACustomSelectPICCell" owner:nil options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    id model;
    if (_dataMArr.count > indexPath.row) {
        model = [_dataMArr objectAtIndex:indexPath.row];
    }
    [cell initWithObject:model IndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GACustomSelectPICCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    GACustomSelectPICModel *model = cell.dataModel;
    if (model) {
        GACustomAlbumList *album = [[GACustomAlbumList alloc] initWithNibName:@"GACustomAlbumList" bundle:nil];
        album.dataModel = model;
        album.delegate = self.delegate;
        [self.navigationController pushViewController:album animated:YES];
    }
}

@end
