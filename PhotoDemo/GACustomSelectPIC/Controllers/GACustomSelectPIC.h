//
//  GACustomSelectPIC.h
//  PhotoDemo
//
//  Created by Gamin on 2018/10/29.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GABaseCustomViewController.h"
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface GACustomSelectPIC : GABaseCustomViewController

@property (assign, nonatomic) NSInteger tempLimitMax; // 限制选择数量
@property (assign, nonatomic) PHAssetMediaType selectMediaType; // 选择文件类型 图片、视频、音频

@end

NS_ASSUME_NONNULL_END
