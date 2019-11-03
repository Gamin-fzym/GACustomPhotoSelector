//
//  GABaseCustomViewController.h
//  PhotoDemo
//
//  Created by Gamin on 2018/10/30.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GACustomAlbumModel.h"
#import "GACustomSelectProtocol.h"
#import "GASelectCountShare.h"

NS_ASSUME_NONNULL_BEGIN

@interface GABaseCustomViewController : UIViewController

@property (assign, nonatomic) NSInteger curIndex; // 选择某一条图片进入详情
@property (weak, nonatomic) UICollectionView *baseCollectionView;
@property (weak, nonatomic) NSMutableArray *baseDataMArr;
@property (weak, nonatomic) id <GACustomSelectProtocol> delegate;

// 导航栏创建右测按钮
- (void)createRightItem;

// 按顺序获取选择的图组
- (NSMutableArray *)getSortSelectWithMArr:(NSMutableArray *)tempDataMArr;

// 选择图片后刷新列表
- (void)reloadPicSelectWith:(GACustomAlbumModel *)object;

// 通过资源获取图片的数据
- (void)fetchImageWithAsset:(id)asset imageBlock:(void(^)(UIImage *image))imageBlock;

@end

NS_ASSUME_NONNULL_END
