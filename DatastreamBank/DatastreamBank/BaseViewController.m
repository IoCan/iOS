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
#import "UserLoginViewController.h"


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
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backItem;
        
        
        UIButton *button2 = [[UIButton alloc] init];
        button2.frame = CGRectMake(0, 0, 45, 30);
        [button2 setTitle:@"确定" forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *backItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
        self.navigationItem.rightBarButtonItem = backItem2;
        
    }

  
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


-(void)okAction {
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


//状态栏
-(void)showStatusTip:(BOOL)show title:(NSString *)title{
    if (_tipWindow == nil) {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:13];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.tag = 2015;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"queue_statusbar_progress.png"]];
        imageView.frame = CGRectMake(0, 14, 100, 6);
        imageView.tag = 2014;
        [_tipWindow addSubview:tipLabel];
        [_tipWindow addSubview:imageView];
    }
    UILabel *tipLabel = (UILabel *)[_tipWindow viewWithTag:2015];
    UIImageView *imageView = (UIImageView *)[_tipWindow viewWithTag:2014];
    if (show) {
        tipLabel.text = title;
        _tipWindow.hidden = NO;
        imageView.left = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2];
        [UIView setAnimationRepeatCount:1000];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        imageView.left = ScreenWidth;
        [UIView commitAnimations];
        
    } else {
        imageView.hidden = YES;
        tipLabel.text = title;
        [self performSelector:@selector(removeTip) withObject:nil afterDelay:1.5];
        
    }
}


-(void)removeTip{
    
    _tipWindow.hidden = YES;
}


//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg {
    if ([msg containsString:@"非法操作"]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:@"您的帐号可能在别处登录，请重新登录！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [UserInfoManager clear];
    UserLoginViewController *loginCtrl = [[UserLoginViewController alloc] init];
    AppDelegate *deleteview =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    deleteview.window.rootViewController = loginCtrl;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
