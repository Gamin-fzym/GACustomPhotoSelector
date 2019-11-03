//
//  CALayer+XibBorderColor.m
//  test
//
//  Created by Gamin on 2017/8/7.
//  Copyright © 2017年 test. All rights reserved.
//

#import "CALayer+XibBorderColor.h"

@implementation CALayer (XibBorderColor)

- (void)setBorderColorWithUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
