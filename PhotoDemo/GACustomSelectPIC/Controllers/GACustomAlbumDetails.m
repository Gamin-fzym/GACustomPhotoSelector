//
//  GACustomAlbumDetails.m
//  PhotoDemo
//
//  Created by Gamin on 2018/10/30.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import "GACustomAlbumDetails.h"
#import "GACustomAlbumCell.h"
#import "GACustomAlbumModel.h"
#import "GAPublicMethod.h"

@interface GACustomAlbumDetails () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) NSMutableArray *dataMArr;

@end

@implementation GACustomAlbumDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    //float aa =  [GAPublicMethod statusAndNavHeight];
    _topConstraint.constant = [GAPublicMethod statusAndNavHeight];
    [GAPublicMethod adaptationSafeAreaWith:_collectionView useArea:1];
    self.baseCollectionView = _collectionView;
    [self createRightItem];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.dataMArr = [self.dataSource provideDataMArrForVC:self];
    self.baseDataMArr = _dataMArr;
    self.title = [NSString stringWithFormat:@"%ld/%lu",(long)self.curIndex,_dataMArr.count];
    [_collectionView reloadData];
    
    [self.view layoutIfNeeded];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.curIndex-1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionLeft) animated:NO];
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
    cell.targetMark = 1;
    [cell initWithObject:model IndexPath:indexPath];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.heightConstraint.constant = 32.0;
    cell.markIV.superview.layer.cornerRadius = 32.0/2.0;
    cell.topConstraint.constant = 10.0;
    cell.rightConstraint.constant = 10.0;
    [cell setSelectPicBlock:^(GACustomAlbumModel * _Nonnull object) {
        [self reloadPicSelectWith:object];
    }];
    return cell;
}

#pragma mark - UICollectionViewDelegate

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-[GAPublicMethod statusAndNavHeight]);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 两行cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 两列cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float offsetx = scrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width/2.0;
    self.curIndex = (offsetx/[UIScreen mainScreen].bounds.size.width) + 1;
    self.title = [NSString stringWithFormat:@"%ld/%lu",(long)self.curIndex,_dataMArr.count];
}

@end
