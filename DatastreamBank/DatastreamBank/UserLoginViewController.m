//
//  UserLoginViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "UserLoginViewController.h"
#import "RDVTabBarController.h"
#import "AppDelegate.h"


#import "RDVTabBarItem.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "FriendsViewController.h"
#import "MessageViewController.h"
#import "BaseNavigationController.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+Phone.h"
#import "UIDeviceHardware.h"
#define lightGray RGBA(204,204,204,1.0)


int secondsCountDown;
@interface UserLoginViewController ()
@property (nonatomic) NSTimer *timer;

@end

@implementation UserLoginViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_code.layer.cornerRadius = 6;
    _btn_login.layer.cornerRadius = 6;
    _btn_code.clipsToBounds = YES;
    _btn_login.clipsToBounds = YES;
    _txt_phone.delegate = self;
    _txt_code.delegate = self;
}

#pragma mark - UITextField代理
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([@"\n" isEqualToString:string] == YES) {
        [textField resignFirstResponder];
        return YES;
    }
    NSString *text = textField.text;
    //如果string为空，表示删除
    if (string.length > 0) {
        text = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }else{
        text = [textField.text substringToIndex:range.location];
    }
     //手机号判断
    if (textField.tag == 1) {
        if ([NSString isMobileNumber:text]) {
            [_btn_code setEnabled:YES];
            [_btn_code setBackgroundColor:RGBA(124, 206, 183, 1.0)];
        }else{
            [_btn_code setEnabled:NO];
            [_btn_code setBackgroundColor:lightGray];
        }
    }
    //验证码判断
    if (textField.tag == 2) {
        if ([NSString isSixCodeNumber:text]) {
            [_btn_login setEnabled:YES];
            [_btn_login setBackgroundColor:RGBA(87, 187, 211, 1.0)];
        }else{
            [_btn_login setEnabled:NO];
            [_btn_login setBackgroundColor:lightGray];
        }

    }
    return YES;
}


#pragma mark - 按钮事件
- (IBAction)action_login:(id)sender {
    [_txt_code resignFirstResponder];
    [_txt_phone resignFirstResponder];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *imsi = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *phone = [_txt_phone text];
    NSString *code = [_txt_code text];
    UIDeviceHardware *hardware = [[UIDeviceHardware alloc] init];
    NSString *model = [hardware platformString];
    NSDictionary *parameters = @{@"mobile": phone,
                                 @"code":code,
                                 @"imsi":[[UIDevice currentDevice] name],
                                 @"imei":imsi,
                                 @"model":model};
    
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在登录";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];

    [manager POST:[BaseUrlString stringByAppendingString:@"userlogin.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSLog(@"----%@",responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
         if ([result isEqualToString:@"00"]) {
             NSDictionary *userList = [responseObject objectForKey:UserInfo];
             NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
             [defaults setObject:userList forKey:UserInfo];
             [defaults synchronize];
             [self setupViewControllers]; 
         } else {
             NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
             UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                              message:resultMsg
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"确定", nil];
             
             [alert show];
         }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:param
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"确定", nil];
        
        [alert show];
    }];
}

- (IBAction)action_code:(id)sender {
    [_txt_code resignFirstResponder];
    [_txt_phone resignFirstResponder];
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在发送";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"mobile": [_txt_phone text]};
    [manager POST:[BaseUrlString stringByAppendingString:@"code.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSString *result = [responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"00"]) {
            [self toast:self.view cotent:@"短信发送成功"];
            secondsCountDown = 60;
            [_btn_code setEnabled:NO];
            [ _btn_code setTitle:@"(60)重获取" forState:UIControlStateNormal];
            [_btn_code setBackgroundColor:[UIColor lightGrayColor]];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        } else {
            NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:resultMsg
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定", nil];
          
           [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:param
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"确定", nil];
        
        [alert show];
    }];
}

#pragma mark - 提示处理
-(void)toast:(UIView *) view cotent:(NSString *) param{
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    toast.labelText = param;
    toast.mode = MBProgressHUDModeCustomView;
    [self.view addSubview:toast];
    [toast show:YES];
    [toast hide:YES afterDelay:2];
    
}

- (void)updateTimer {
    [ _btn_code setTitle:[NSString stringWithFormat:@"(%d)重获取",secondsCountDown] forState:UIControlStateNormal];
    secondsCountDown--;
    if(secondsCountDown == 0){
        [_btn_code setTitle:@"重发" forState:UIControlStateNormal];
        [self.timer invalidate];
        [_btn_code setEnabled:YES];
        [_btn_code setBackgroundColor:RGBA(124, 206, 183, 1.0)];
    }
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
    [self customizeTabBarForController:tabBarController];
    [tabBarController setTabBarHidden:YES];
    AppDelegate *deleteview =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [UIView transitionFromView:deleteview.window.rootViewController.view
                        toView:tabBarController.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    completion:^(BOOL finished)
     {
          deleteview.window.rootViewController  = tabBarController;
          [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
         
     }];
    
   
}

#pragma mark - 设置item的图标和字体颜色
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
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


#pragma mark - 生命周期处理
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
