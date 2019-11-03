//
//  GASelectCountShare.m
//  PhotoDemo
//
//  Created by Gamin on 2018/10/31.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import "GASelectCountShare.h"

static GASelectCountShare *sharedSelectCount = nil;

@implementation GASelectCountShare

+ (id)sharedSelectCountMethod {
    @synchronized (self){
        if (!sharedSelectCount) {
            sharedSelectCount = [[GASelectCountShare alloc] init];
        }
        return sharedSelectCount;
    }
    return sharedSelectCount;
}

@end
