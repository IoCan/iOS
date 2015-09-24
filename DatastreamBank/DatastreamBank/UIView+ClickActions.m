//
//  UIView+ClickActions.m
//  OsnDroidWeiBo
//
//  Created by OsnDroid on 14-9-2.
//  Copyright (c) 2014年 OsnDroid. All rights reserved.
//

#import "UIView+ClickActions.h"

@implementation UIView (ClickActions)

-(UIViewController *)viewController{
    UIResponder *next  = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return  nil;
}

@end
