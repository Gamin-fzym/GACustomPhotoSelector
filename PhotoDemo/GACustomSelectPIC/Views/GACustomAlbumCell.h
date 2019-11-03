//
//  GACustomAlbumCell.h
//  PhotoDemo
//
//  Created by Gamin on 2018/10/29.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "GACustomAlbumModel.h"
#import "GASelectCountShare.h"
#import "GAPublicMethod.h"

NS_ASSUME_NONNULL_BEGIN

@interface GACustomAlbumCell : UICollectionViewCell <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *markIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) GACustomAlbumModel *dataModel;
@property (assign, nonatomic) NSInteger targetMark; // 0:列表 1:详情
typedef void (^tapSelectPicBlock)(GACustomAlbumModel *object);
@property (strong, nonatomic) tapSelectPicBlock selectPicBlock;

- (void)initWithObject:(id)object IndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
