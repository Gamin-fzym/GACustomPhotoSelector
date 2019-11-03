//
//  GACustomAlbumModel.h
//  PhotoDemo
//
//  Created by Gamin on 2018/10/29.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface GACustomAlbumModel : NSObject

@property (assign, nonatomic) BOOL select;
@property (assign, nonatomic) NSInteger number;
@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) UIImage *image; // 缩略图
@property (strong, nonatomic) UIImage *originalImage; // 原图

@end

NS_ASSUME_NONNULL_END
