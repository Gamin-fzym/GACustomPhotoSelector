//
//  UIViewController+Present.m
//  NewDemo
//
//  Created by Gamin on 2019/11/1.
//  Copyright © 2019 Gamin. All rights reserved.
//

#import "UIViewController+Present.h"
#import <objc/runtime.h>

static const char *GA_automaticallySetModalPresentationStyleKey;

@implementation UIViewController (Present)

+ (void)load {
    /*
    * OBJC_EXPORT Method _Nullable class_getInstanceMethod(Class _Nullable cls, SEL _Nonnull name)
    * 返回给定类的指定实例方法。
    * @param cls  您要检查的类。
    * @param name 您要检索的方法的选择器。
    * @return     对应于由指定的选择器的实现的方法
    * 由\e cls指定的类的\e name, 或者\c NULL 如果指定的类或其名称
    * 超类不包含具有指定选择器的实例方法。
    * @note 该函数在超类中搜索实现，而\ c class_copyMethodList则不。
    */
    Method originAddObserverMethod = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, @selector(GA_presentViewController:animated:completion:));
    /*
    * OBJC_EXPORT void method_exchangeImplementations(Method _Nonnull m1, Method _Nonnull m2)
    * 交换两种方法的实现。
    * @param m1方法 与第二种方法交换。
    * @param m2方法 与第一种方法交换。
    * @note  这是以下内容的原子版本：
    * \ code
    * IMP IMP1 = method_getImplementation（M1）;
    * IMP imp2 = method_getImplementation（m2）;
    * method_setImplementation（m1，imp2）;
    * method_setImplementation（m2，imp1）;
    * \ endcode
    */
    method_exchangeImplementations(originAddObserverMethod, swizzledAddObserverMethod);
}

// 设置GA_automaticallySetModalPresentationStyle
- (void)setGA_automaticallySetModalPresentationStyle:(BOOL)GA_automaticallySetModalPresentationStyle {
    objc_setAssociatedObject(self, GA_automaticallySetModalPresentationStyleKey, @(GA_automaticallySetModalPresentationStyle), OBJC_ASSOCIATION_ASSIGN);
}

// 获取GA_automaticallySetModalPresentationStyle
- (BOOL)GA_automaticallySetModalPresentationStyle {
    id obj = objc_getAssociatedObject(self, GA_automaticallySetModalPresentationStyleKey);
    if (obj) {
        return [obj boolValue];
    }
    return [self GA_judgeAutoSetModalPresentationStyle];
}

// 判断是否需要自动设置模式显示样式 并不是所有继承于UIViewController的类都要处理
- (BOOL)GA_judgeAutoSetModalPresentationStyle {
//    if ([self isKindOfClass:[UIImagePickerController class]] || [self isKindOfClass:[UIAlertController class]]) {
//        return NO;
//    }
    return YES;
}

// 用于替换presentViewController:animated:completion:的新方法
- (void)GA_presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    if (@available(iOS 13.0, *)) {
        if (viewController.GA_automaticallySetModalPresentationStyle) {
            viewController.modalPresentationStyle = UIModalPresentationFullScreen;
            viewController.modalInPresentation = YES;
        }
        [self GA_presentViewController:viewController animated:animated completion:completion];
    } else {
        // Fallback on earlier versions
        [self GA_presentViewController:viewController animated:animated completion:completion];
    }
}

@end
