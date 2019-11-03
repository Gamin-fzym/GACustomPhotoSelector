//
//  GACustomAlbumList.h
//  PhotoDemo
//
//  Created by Gamin on 2018/10/29.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GABaseCustomViewController.h"
#import "GACustomSelectPICModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GACustomAlbumList : GABaseCustomViewController

@property (strong, nonatomic) GACustomSelectPICModel *dataModel;

@end

NS_ASSUME_NONNULL_END
