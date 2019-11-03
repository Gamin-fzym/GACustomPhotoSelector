//
//  GACustomSelectPICCell.m
//  PhotoDemo
//
//  Created by Gamin on 2018/10/29.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import "GACustomSelectPICCell.h"

@implementation GACustomSelectPICCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)releaseAction {
    _dataModel = nil;
    _firstIV.hidden = NO;
    _secondIV.hidden = YES;
    _thirdIV.hidden = YES;
    _titleLab.text = @"";
    _contentLab.text = @"";
}

- (void)initWithObject:(id)object IndexPath:(NSIndexPath *)indexPath {
    [self releaseAction];
    if (object) {
        _dataModel = (GACustomSelectPICModel *)object;
        _titleLab.text = _dataModel.title;
        _contentLab.text = [NSString stringWithFormat:@"%ld",_dataModel.count];
        _markIV.image = [UIImage imageNamed:@"CustomPicture.bundle/right-jiantou-black"];
        
        NSArray *assets = _dataModel.assetArray;
        if (_dataModel.count >= 3) {
            _secondIV.hidden = NO;
            _thirdIV.hidden = NO;
            if (_dataModel.firstImage) {
                self.firstIV.image = _dataModel.firstImage;
            } else {
                [self assignmentIV:self.firstIV Asset:assets.lastObject];
            }
            if (_dataModel.secondImage) {
                self.secondIV.image = _dataModel.secondImage;
            } else {
                [self assignmentIV:self.secondIV Asset:[assets objectAtIndex:assets.count-2]];
            }
            if (_dataModel.thirdImage) {
                self.thirdIV.image = _dataModel.thirdImage;
            } else {
                [self assignmentIV:self.thirdIV Asset:[assets objectAtIndex:assets.count-3]];
            }
        } else if (_dataModel.count >= 2) {
            _secondIV.hidden = NO;
            if (_dataModel.firstImage) {
                self.firstIV.image = _dataModel.firstImage;
            } else {
                [self assignmentIV:self.firstIV Asset:assets.lastObject];
            }
            if (_dataModel.secondImage) {
                self.secondIV.image = _dataModel.secondImage;
            } else {
                [self assignmentIV:self.secondIV Asset:[assets objectAtIndex:assets.count-2]];
            }
        } else if (_dataModel.count >= 1) {
            if (_dataModel.firstImage) {
                self.firstIV.image = _dataModel.firstImage;
            } else {
                [self assignmentIV:self.firstIV Asset:assets.lastObject];
            }
        }
    }
}

- (void)assignmentIV:(UIImageView *)imageView Asset:(PHAsset *)asset {
    // 这个方法的回调是在主线程中回调的
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(80*2, 80*2) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        imageView.image = result;
        if (imageView.tag == 1000) {
            self.dataModel.firstImage = result;
        } else if (imageView.tag == 1001) {
            self.dataModel.secondImage = result;
        } else if (imageView.tag == 1002) {
            self.dataModel.thirdImage = result;
        }
    }];
}

@end
