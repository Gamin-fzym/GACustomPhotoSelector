//
//  GACustomSelectPICModel.h
//  PhotoDemo
//
//  Created by Gamin on 2018/10/29.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GACustomSelectPICModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSArray *assetArray;
@property (strong, nonatomic) UIImage *firstImage;
@property (strong, nonatomic) UIImage *secondImage;
@property (strong, nonatomic) UIImage *thirdImage;

@end

NS_ASSUME_NONNULL_END
