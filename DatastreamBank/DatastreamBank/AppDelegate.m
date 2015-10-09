//
//  AppDelegate.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/9/9.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "FriendsViewController.h"
#import "MessageViewController.h"
#import "BaseNavigationController.h"

@interface AppDelegate ()

@end

#pragma mark - 程序生命周期
@implementation AppDelegate


//程序首次已经完成启动时执行，若直接启动，launchOptions中没有数据；否则，launchOptions将包含对应方式的内容
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption {
    [application setStatusBarStyle:UIStatusBarStyleLightContent];//设置全局状态栏颜色
    [application setStatusBarHidden:NO]; //启动的时候设置显示, 启动后要打开
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupViewControllers];
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    
    [self customizeInterface];
    return YES;
}

//程序将要失去Active状态时调用，比如按下Home键或有电话信息进来
//对应applicationWillEnterForeground（将进入前台）
//暂停正在执行的任务；禁止计时器；减少OpenGL ES帧率；若为游戏应暂停游戏；总结为一个字：停！
- (void)applicationWillResignActive:(UIApplication *)application {
  
}

//程序已经进入后台时调用，对应applicationDidBecomeActive（已经变成前台），这个方法用来
//释放共享资源；
//保存用户数据（写到硬盘）；
//作废计时器；
//保存足够的程序状态以便下次恢复；
//总结为4个字：释放、保存！
- (void)applicationDidEnterBackground:(UIApplication *)application {
  
}

//程序即将进去前台时调用，对应applicationWillResignActive（将进入后台）。
//这个方法用来撤销applicationWillResignActive中做的改变。
- (void)applicationWillEnterForeground:(UIApplication *)application {
 
}

//程序已经变为Active（前台）时调用。对应applicationDidEnterBackground（已经进入后台）。
//若程序之前在后台，最后在此方法内刷新用户界面。
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

//程序即将退出时调用。记得保存数据，如applicationDidEnterBackground方法一样。
- (void)applicationWillTerminate:(UIApplication *)application {
   
}

#pragma mark - 初始化模块页面

- (void)setupViewControllers {
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
//    [tabBarController setTabBarHidden:YES animated:YES];
    self.viewController = tabBarController;
    
    
    
    [self customizeTabBarForController:tabBarController];
}

#pragma mark - 设置item的图标和字体颜色
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
//  UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
//  NSArray *tabBarItemImages = @[@"icon_undertab_", @"second", @"third"];
    NSDictionary *textAttributes = nil;
    NSDictionary *textAttributes2 = nil;
    UIColor *selcolor = [UIColor colorWithRed:0/255.0
                                       green:175/255.0
                                        blue:209/255.0
                                       alpha:1.0];
    UIColor *color = [UIColor colorWithRed:153/255.0
                                       green:153/255.0
                                        blue:153/255.0
                                       alpha:1.0];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:12],
                           NSForegroundColorAttributeName: color,
                           };
        textAttributes2 = @{
                            NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                            NSForegroundColorAttributeName: selcolor,
                            
                            };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0

        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:12],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
        
        textAttributes2 = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:12],
                           UITextAttributeTextColor: selabel,
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };

#endif
    }

    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:unfinishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_undertab_%lda",index+1]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_undertab_%ld",index+1]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setSelectedTitleAttributes:textAttributes2];
        [item setUnselectedTitleAttributes:textAttributes];
        index++;
    }
}

#pragma mark - 处理navigationbar的属性
- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor whiteColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

 
@end
