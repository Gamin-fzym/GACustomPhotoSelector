//
//  GACustomAlbumList.m
//  PhotoDemo
//
//  Created by Gamin on 2018/10/29.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import "GACustomAlbumList.h"
#import "GACustomAlbumCell.h"
#import "GACustomAlbumModel.h"
#import "GAPublicMethod.h"
#import "GACustomAlbumDetails.h"

#define GH_SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define GH_SCREENHIGH  [UIScreen mainScreen].bounds.size.height
// 多少列
#define GH_BRANDSECTION 4
// 列表间隔距离
#define GH_BRANDDEV 1
// cell宽度
#define GH_LISTCELLWIDTH (GH_SCREENWIDTH - (GH_BRANDSECTION-1)*GH_BRANDDEV) / GH_BRANDSECTION

@interface GACustomAlbumList () <UICollectionViewDelegate, UICollectionViewDataSource, GACustomAlbumDetailsDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataMArr;

@end

@implementation GACustomAlbumList

- (void)dealloc {
    _dataMArr = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _dataModel.title;
    
    if (!_dataMArr) {
        _dataMArr = [NSMutableArray new];
    }
    GASelectCountShare *shareCount = [GASelectCountShare sharedSelectCountMethod];
    for (PHAsset *asset in _dataModel.assetArray) {
        GACustomAlbumModel *model = [GACustomAlbumModel new];
        model.asset = asset;
        model.select = NO;
        model.number = 0;
        if (model) {
            for (GACustomAlbumModel *cModel in shareCount.saveSelectPics) {
                if ([cModel.asset isEqual:model.asset]) {
                    model.select = YES;
                    //shareCount.selectCount += 1;
                }
            }
            [_dataMArr insertObject:model atIndex:0];
        }
    }
    self.baseDataMArr = self.dataMArr;
    self.baseCollectionView = self.collectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    [self createRightItem];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataMArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"GACustomAlbumCell";
    UINib *cellNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:CellIdentifier];
    GACustomAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    GACustomAlbumModel *model;
    if (_dataMArr.count > indexPath.row) {
        model = [_dataMArr objectAtIndex:indexPath.row];
    }
    cell.targetMark = 0;
    [cell initWithObject:model IndexPath:indexPath];
    [cell.scrollView setUserInteractionEnabled:NO];
    [cell setSelectPicBlock:^(GACustomAlbumModel * _Nonnull object) {
        [self reloadPicSelectWith:object];
    }];
    return cell;
}

#pragma mark - UICollectionViewDelegate

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(GH_LISTCELLWIDTH, GH_LISTCELLWIDTH);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(GH_BRANDDEV, 0, GH_BRANDDEV, 0);
}

// 两行cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return GH_BRANDDEV;
}

// 两列cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return GH_BRANDDEV;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GACustomAlbumCell *cell = (GACustomAlbumCell *)[collectionView cellForItemAtIndexPath:indexPath];
    GACustomAlbumModel *model = cell.dataModel;
    if (model) {
        GACustomAlbumDetails *details = [[GACustomAlbumDetails alloc] initWithNibName:@"GACustomAlbumDetails" bundle:nil];
        details.curIndex = indexPath.row + 1;
        details.delegate = self.delegate;
        details.dataSource = self;
        [self.navigationController pushViewController:details animated:YES];
    }
}

#pragma mark - GACustomAlbumDetailsDataSource

- (NSMutableArray *)provideDataMArrForVC:(GACustomAlbumDetails *)viewController {
    return self.dataMArr;
}

@end
