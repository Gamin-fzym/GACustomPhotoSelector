//
//  GABaseCustomViewController.m
//  PhotoDemo
//
//  Created by Gamin on 2018/10/30.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import "GABaseCustomViewController.h"
#import "GAPublicMethod.h"
#import "UIImage+FixOrientation.h"
#import "GACustomSelectPIC.h"

@interface GABaseCustomViewController ()

@end

@implementation GABaseCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftItem];
}

- (void)createLeftItem {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, 44, 44);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;// 水平左对齐
    [btn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"CustomPicture.bundle/left-return-black"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)returnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createRightItem {
    NSString *tempTitle = @"下一步";
    UIColor *tempTitleColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    UIColor *tempBGColor = [UIColor whiteColor];
    UIColor *tempBoColor = tempTitleColor;
    GASelectCountShare *shareCount = [GASelectCountShare sharedSelectCountMethod];
    if (shareCount.selectCount > 0) {
        tempTitle = [NSString stringWithFormat:@"下一步(%ld)",(long)shareCount.selectCount];
        tempTitleColor = [UIColor whiteColor];
        tempBGColor = [UIColor colorWithRed:42/255.0 green:123/255.0 blue:254/255.0 alpha:1];
        tempBoColor = tempBGColor;
    }
    
    UIButton *sureBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBut addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBut.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [sureBut.layer setMasksToBounds:YES];
    [sureBut.layer setCornerRadius:5];
    [sureBut.layer setBorderWidth:1];
    [sureBut.layer setBorderColor:[sureBut.titleLabel.textColor CGColor]];
    [sureBut.layer setBorderColor:[tempBoColor CGColor]];
    [sureBut setTitle:tempTitle forState:UIControlStateNormal];
    [sureBut setTitleColor:tempTitleColor forState:UIControlStateNormal];
    [sureBut setBackgroundImage:[GAPublicMethod createImageWithColor:tempBGColor] forState:UIControlStateNormal];
    [sureBut setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureBut];
}

- (void)nextAction:(id)sender {
    GASelectCountShare *shareCount = [GASelectCountShare sharedSelectCountMethod];
    if (shareCount.selectCount <= 0) {
        return;
    }
    if (self.delegate) {
        NSMutableArray *saveMArr = shareCount.saveSelectPics;
        if (!saveMArr) {
            saveMArr = [NSMutableArray new];
        }
        NSMutableArray *selectMArr = [self getSortSelectWithMArr:self.baseDataMArr];
        for (int i = 0 ; i < selectMArr.count ; i ++) {
            GACustomAlbumModel *sModel = [selectMArr objectAtIndex:i];
            BOOL result = YES;
            for (int j = 0 ; j < saveMArr.count ; j ++) {
                GACustomAlbumModel *tModel = [saveMArr objectAtIndex:j];
                if ([sModel.asset isEqual:tModel.asset]) {
                    result = NO;
                }
            }
            if (result) {
                [saveMArr addObject:sModel];
            }
        }
        shareCount.saveSelectPics = saveMArr;
        [self.delegate customSelectAssets:saveMArr];
    }
    
    NSArray *navs = [self.navigationController viewControllers];
    NSInteger firstIndex = 0;
    for (int i = 0 ; i < navs.count ; i ++) {
        UIViewController *vc = [navs objectAtIndex:i];
        if ([vc isKindOfClass:[GACustomSelectPIC class]]) {
            firstIndex = i;
            break;
        }
    }
    if (firstIndex > 0) {
        UIViewController *frontVC = [navs objectAtIndex:firstIndex-1];
        [self.navigationController popToViewController:frontVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSMutableArray *)getSortSelectWithMArr:(NSMutableArray *)tempDataMArr {
    // 取出选择的图片
    NSMutableArray *selectMArr = [NSMutableArray new];
    for (int i = 0 ; i < tempDataMArr.count ; i ++) {
        GACustomAlbumModel *model = [tempDataMArr objectAtIndex:i];
        if (model.select) {
            [selectMArr addObject:model];
        }
    }
    // 排序选择的图片
    NSMutableArray *sortSelectMArr = [NSMutableArray new];
    NSInteger sCount = selectMArr.count;
    for (int i = 0 ; i < sCount ; i ++) {
        GACustomAlbumModel *minModel;
        for (int j = 0 ; j < selectMArr.count ; j ++) {
            GACustomAlbumModel *model = [selectMArr objectAtIndex:j];
            if (!minModel) {
                minModel = model;
            } else {
                if (model.number < minModel.number) {
                    minModel = model;
                }
            }
        }
        [sortSelectMArr addObject:minModel];
        [selectMArr removeObject:minModel];
    }
    return sortSelectMArr;
}

- (void)reloadPicSelectWith:(GACustomAlbumModel *)object {
    GASelectCountShare *shareCount = [GASelectCountShare sharedSelectCountMethod];
    if (object.select) {
        object.select = NO;
        shareCount.selectCount -= 1;
        if (object.number > 0) {
            NSInteger index = object.number;
            NSMutableArray *selectMArr = [self getSortSelectWithMArr:self.baseDataMArr];
            for (int i = 0 ; i < selectMArr.count ; i ++) {
                GACustomAlbumModel *model = [selectMArr objectAtIndex:i];
                if (model.number > index) {
                    model.number -= 1;
                }
            }
        }
        object.number = 0;
        
        NSMutableArray *saveMArr = shareCount.saveSelectPics;
        for (int i = 0 ; i < saveMArr.count ; i ++) {
            GACustomAlbumModel *sModel = [saveMArr objectAtIndex:i];
            if ([object.asset isEqual:sModel.asset]) {
                [saveMArr removeObject:sModel];
            }
        }
        shareCount.saveSelectPics = saveMArr;
    } else {
        if (shareCount.selectCount >= shareCount.limitMaxNumber) {
            return;
        }
        object.select = YES;
        shareCount.selectCount += 1;
        object.number = shareCount.selectCount;
    }
    //[self.baseCollectionView reloadData];
    [self createRightItem];
}

- (void)fetchImageWithAsset:(id)asset imageBlock:(void(^)(UIImage *image))imageBlock {
    GACustomAlbumModel *model = (GACustomAlbumModel *)asset;
    PHAsset *pAsset = (PHAsset *)model.asset;
    [[PHImageManager defaultManager] requestImageDataForAsset:pAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        image = [image fixOrientation];
        if (imageBlock) {
            imageBlock(image);
        }
    }];
}

@end
