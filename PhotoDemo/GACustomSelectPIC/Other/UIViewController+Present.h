//
//  UIViewController+Present.h
//  NewDemo
//
//  Created by Gamin on 2019/11/1.
//  Copyright © 2019 Gamin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Present)

// category中不能添加属性,所以使用运行时的方式处理
@property (nonatomic, assign) BOOL GA_automaticallySetModalPresentationStyle;

@end

NS_ASSUME_NONNULL_END
