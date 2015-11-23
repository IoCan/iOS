//
//  MainViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/20.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "MainViewController.h"

#import "RDVTabBarItem.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "FriendsViewController.h"
#import "MessageViewController.h"
#import "BaseNavigationController.h"

@interface MainViewController ()

@end

@implementation MainViewController




#pragma mark - 初始化模块页面
- (RDVTabBarController *)setupViewControllers {
    UIViewController *firstViewController = [[HomeViewController alloc] init];
    UIViewController *firstNavigationController = [[BaseNavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    
    UIViewController *secondViewController = [[MessageViewController alloc] init];
    UIViewController *secondNavigationController = [[BaseNavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[FriendsViewController alloc] init];
    UIViewController *thirdNavigationController = [[BaseNavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    UIViewController *fourViewController = [[MineViewController alloc] init];
    UIViewController *fourNavigationController = [[BaseNavigationController alloc]
                                                  initWithRootViewController:fourViewController];
    
    
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController,fourNavigationController]];
    
    [self customizeTabBarForController:tabBarController];
    return tabBarController;
}

#pragma mark - 设置item的图标和字体颜色
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    //  UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    //  NSArray *tabBarItemImages = @[@"icon_undertab_", @"second", @"third"];
    NSDictionary *textAttributes = nil;
    NSDictionary *textAttributes2 = nil;
    
    UIColor *selcolor = RGBA(0, 175, 209, 1.0);
    UIColor *color = RGBA(153, 153, 153, 1.0);
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        textAttributes = @{
                           NSFontAttributeName: [UIFont systemFontOfSize:10],
                           NSForegroundColorAttributeName: color,
                           };
        textAttributes2 = @{
                            NSFontAttributeName:[UIFont systemFontOfSize:10],
                            NSForegroundColorAttributeName: selcolor,
                            
                            };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont systemFontOfSize:10],
                           UITextAttributeTextColor: color,
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
        
        textAttributes2 = @{
                            UITextAttributeFont: [UIFont systemFontOfSize:10],
                            UITextAttributeTextColor: selcolor,
                            UITextAttributeTextShadowColor: [UIColor clearColor],
                            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                            };
        
#endif
    }
    
    NSInteger index = 1;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:unfinishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_undertab_%lda",(long)index]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_undertab_%ld",(long)index]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setSelectedTitleAttributes:textAttributes2];
        [item setUnselectedTitleAttributes:textAttributes];
        index++;
    }
}





@end
