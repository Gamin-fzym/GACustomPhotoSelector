//
//  GAPublicMethod.m
//  PhotoDemo
//
//  Created by Gamin on 2018/10/30.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import "GAPublicMethod.h"
#import <Photos/Photos.h>
#import "UIImage+FixOrientation.h"

@implementation GAPublicMethod

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (void)adaptationSafeAreaWith:(UIScrollView *)sv useArea:(NSInteger)isUse {
#ifdef __IPHONE_11_0
    if ([sv respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (isUse) {
            if (@available(iOS 11.0, *)) {
                sv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                if ([[sv class] isSubclassOfClass:[UITableView class]]) {
                    UITableView *tv = (UITableView *)sv;
                    [tv setInsetsContentViewsToSafeArea:NO];
                }
            } else {
                // Fallback on earlier versions
            }
        } else {
            if (@available(iOS 11.0, *)) {
                sv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
            } else {
                // Fallback on earlier versions
            }
        }
    }
#endif
}

+ (float)statusAndNavHeight {
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navHeight = [UINavigationController new].navigationBar.frame.size.height;
    return statusHeight + navHeight;
}

@end
