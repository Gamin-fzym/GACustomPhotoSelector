//
//  GACustomAlbumCell.m
//  PhotoDemo
//
//  Created by Gamin on 2018/10/29.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import "GACustomAlbumCell.h"

@implementation GACustomAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _scrollView.delegate = self;
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView.layer setMasksToBounds:YES];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 3.0;
    _scrollView.minimumZoomScale = 1.0;
}

- (void)releaseAction {
    _dataModel = nil;
    _imageView.image = nil;
    [_markIV setTitle:@"" forState:UIControlStateNormal];
}

- (void)initWithObject:(id)object IndexPath:(NSIndexPath *)indexPath {
    [self releaseAction];
    if (object) {
        _dataModel = (GACustomAlbumModel *)object;
        [_markIV setBackgroundImage:[UIImage imageNamed:@"CustomPicture.bundle/rj_cell_normal"] forState:UIControlStateNormal];
        [_markIV setBackgroundImage:[UIImage imageNamed:@"CustomPicture.bundle/rj_cell_selected"] forState:UIControlStateSelected];
        _markIV.selected = _dataModel.select;
        _scrollView.zoomScale = 1;
        /*
        if (_dataModel.number > 0) {
            [_markIV setTitle:[NSString stringWithFormat:@"%ld",_dataModel.number] forState:UIControlStateNormal];
        }*/
        /*
        BOOL result = NO;
        if (self.targetMark == 1) {
            if (_dataModel.originalImage) {
                _imageView.image = _dataModel.originalImage;
            } else {
                result = YES;
            }
        } else {
            if (_dataModel.image) {
                _imageView.image = _dataModel.image;
            } else {
                result = YES;
            }
        }
        if (result) {
            [self assignmentIV:_imageView Asset:_dataModel.asset];
        }*/
        if (self.targetMark == 1) {
            PHAsset *asset = _dataModel.asset;
            CGSize tempDetailTarget = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
            [self assignmentTarget:tempDetailTarget Asset:asset];
        } else {
            CGSize tempListTarget = CGSizeMake(80*2, 80*2);
            [self assignmentTarget:tempListTarget Asset:_dataModel.asset];
        }
    }
}

- (void)assignmentTarget:(CGSize)target Asset:(PHAsset *)asset {
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:target contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        _imageView.image = result;
    }];
}

- (void)assignmentIV:(UIImageView *)imageView Asset:(PHAsset *)asset {
    CGSize tempListTarget = CGSizeMake(80*2, 80*2);
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:tempListTarget contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.dataModel.image = result;
        if (self.targetMark == 1) {
            
        } else {
            imageView.image = result;
        }
    }];
    CGSize tempDetailTarget = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:tempDetailTarget contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.dataModel.originalImage = result;
        if (self.targetMark == 1) {
            imageView.image = result;
        } else {
            
        }
    }];
}

- (IBAction)tapMarkIVAction:(id)sender {
    UIButton *tempBut = (UIButton *)sender;
    if (tempBut.isSelected) {
        tempBut.selected = NO;
        if (self.selectPicBlock) {
            self.selectPicBlock(_dataModel);
        }
    } else {
        GASelectCountShare *shareCount = [GASelectCountShare sharedSelectCountMethod];
        if (shareCount.selectCount < shareCount.limitMaxNumber) {
            tempBut.selected = YES;
            if (self.selectPicBlock) {
                self.selectPicBlock(_dataModel);
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

// 通过ScrollView的这个代理方法来实现图片的缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView.tag != 2300) {
        NSArray *subViews = [scrollView subviews];
        UIImageView *imageView;
        for (int i = 0 ; i < subViews.count ; i ++) {
            UIView *tempView = [subViews objectAtIndex:i];
            if ([[tempView class] isSubclassOfClass:[UIImageView class]]) {
                imageView = (UIImageView *)tempView;
            }
        }
        return imageView;
    } else {
        return nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGSize contentSize = scrollView.contentSize;
    CGFloat snHeight = [UIScreen mainScreen].bounds.size.height - [GAPublicMethod statusAndNavHeight];
    CGPoint offsetPoint = scrollView.contentOffset;
    CGFloat minYFloat = (contentSize.height - snHeight)/2.0;
    offsetPoint.y = minYFloat;
    scrollView.contentOffset = offsetPoint;
}

@end
