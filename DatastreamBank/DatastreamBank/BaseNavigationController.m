//
//  BaseNavigationController.m
//  OsnDroidWeiBo
//
//  Created by OsnDroid on 14-8-2.
//  Copyright (c) 2014年 OsnDroid. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[super loadView];
    //self.navigationBar.alpha = 0.98f;
    // 设置为半透明
    //self.navigationBar.translucent = YES;

    float version = WXHLOSVersion();
    //判断是否存在这个方法
//    if([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//    }
//     ThemeManager *tm = [ThemeManager shareInstance];
//    NSString *path = tm.themeName;
//    if (path) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//
//    } else {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//
//    }
//    NSString *str = [NSString stringWithFormat:@"--version%f",version];

//    MyLog(str);
    if (version>=5.0) {
        //ios5.0以上的系统
       UIImage *image = [UIImage imageNamed:@"navigationbar_background.png"];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        //ios5.0以下的系统
    }
}

- (void)dealloc {
     

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = YES;
	[super pushViewController:viewController animated:animated];
}

@end
