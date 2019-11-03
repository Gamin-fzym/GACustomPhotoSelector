//
//  GAPublicMethod.h
//  PhotoDemo
//
//  Created by Gamin on 2018/10/30.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GAPublicMethod : NSObject

// 将UIColor转换成图片
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 * 适配iPhone X的安全区域
 * isUse = 1 表示使用安全区域
 * isUse = 0 表示不使用安全区域
 */
+ (void)adaptationSafeAreaWith:(UIScrollView *)sv useArea:(NSInteger)isUse;

// 状态栏+导航栏高度
+ (float)statusAndNavHeight;

@end

NS_ASSUME_NONNULL_END
