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
#import "UserLoginViewController.h"
#import "NSString+Phone.h"
#import "SDWebImage/SDImageCache.h"
#import <AlipaySDK/AlipaySDK.h>
#import "payRequsestHandler.h"
@interface AppDelegate ()

@end

#pragma mark - 程序生命周期
@implementation AppDelegate


//程序首次已经完成启动时执行，若直接启动，launchOptions中没有数据；否则，launchOptions将包含对应方式的内容
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption {
    [application setStatusBarStyle:UIStatusBarStyleLightContent];//设置全局状态栏颜色
    [application setStatusBarHidden:NO]; //启动的时候设置显示, 启动后要打开
    [WXApi registerApp:APP_ID withDescription:@"流量备胎"];
    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"IoCanImages"];
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:50 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    if ([NSString isMobileNumber:mobile]) {
        //主页面
        [self setupViewControllers];
        [self.window setRootViewController:self.viewController];
        [self.window makeKeyAndVisible];
        [self customizeInterface];
    } else {
        //登录页面
        UserLoginViewController *login = [[UserLoginViewController alloc] init];
        [self.window setRootViewController:login];
        [self.window makeKeyAndVisible];
    }
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

 
-(void) onResp:(BaseResp*)resp {
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                strMsg = @"支付结果：失败！";
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
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

    self.viewController = tabBarController;
  
//    [tabBarController.tabBar.items[2] setBadgeValue:@"9"];
//    [tabBarController.tabBar.items[2] setBadgeTextFont:[UIFont systemFontOfSize:10]];
    [self customizeTabBarForController:tabBarController];
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
   
    [navigationBarAppearance setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

 
@end
