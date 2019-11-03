//
//  GASelectCountShare.h
//  PhotoDemo
//
//  Created by Gamin on 2018/10/31.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GASelectCountShare : NSObject

@property (assign, nonatomic) NSInteger selectCount; // 选择图片的数量
@property (assign, nonatomic) NSInteger limitMaxNumber; // 限制选择数量
@property (strong, nonatomic) NSMutableArray *saveSelectPics;

+ (id)sharedSelectCountMethod;

@end

NS_ASSUME_NONNULL_END
