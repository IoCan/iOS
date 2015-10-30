//
//  BaseViewController.m
//  OsnDroidWeiBo
//
//  Created by OsnDroid on 14-8-2.
//  Copyright (c) 2014年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "RDVTabBarController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.isBackButton = YES;
         self.isCancelButton = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    MyLog(@"vvv----------vvv");
    NSArray *viewControllers = self.navigationController.viewControllers;
 
  
    if (viewControllers.count > 1 && self.isBackButton) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
 
    }
   
    

    if (self.isCancelButton) {

        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(0, 0, 45, 30);
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backItem;
    }
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

  
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    if (self.navigationController.viewControllers.count==1) {
        [self setBlueNav];
        [[self rdv_tabBarController] setTabBarHidden:NO animated:animated];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count==1) {
        //[[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
        [self setBlueNav];
    }else{
        [self setWhiteNav];
//        self.navigationController.navigationBar.hidden = NO;
        [[self rdv_tabBarController] setTabBarHidden:YES animated:animated];
    }
 
}


-(void)cancleAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark 设置nav背景
//设置蓝色顶部
-(void)setBlueNav {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNav:@"navigationbar_background_tall" fontColor:[UIColor whiteColor]];
}

//设置白色顶部
-(void)setWhiteNav {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNav:@"titlebar_white" fontColor:RGBA(74,74,74,1)];
}

-(void)setNav:(NSString *) bgImg fontColor:(UIColor *) color {
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:bgImg];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: color,
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
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    
    [self.navigationController.navigationBar setTintColor:color];

}


-(void)toast:(UIView *) view cotent:(NSString *) param{
    _toast = [[MBProgressHUD alloc] initWithView:view];
    _toast.labelText = param;
    _toast.mode = MBProgressHUDModeText;
    [self.view addSubview:_toast];
    [_toast show:YES];
    [_toast hide:YES afterDelay:2];
}

-(void)toastsucess:(UIView *) view cotent:(NSString *) param{
    _toast = [[MBProgressHUD alloc] initWithView:view];
    _toast.labelText = param;
    _toast.mode = MBProgressHUDModeCustomView;
    _toast.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    _toast.labelText = param;
    [self.view addSubview:_toast];
    [_toast show:YES];
    [_toast hide:YES afterDelay:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
