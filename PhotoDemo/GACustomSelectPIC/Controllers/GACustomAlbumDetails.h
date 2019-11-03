//
//  GACustomAlbumDetails.h
//  PhotoDemo
//
//  Created by Gamin on 2018/10/30.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GABaseCustomViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class GACustomAlbumDetails;

@protocol GACustomAlbumDetailsDataSource <NSObject>

@required
// 提供图组
- (NSMutableArray *)provideDataMArrForVC:(GACustomAlbumDetails *)viewController;

@end

@interface GACustomAlbumDetails : GABaseCustomViewController

@property (weak, nonatomic) id <GACustomAlbumDetailsDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
