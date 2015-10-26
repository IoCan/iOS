//
//  UserLoginViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "UserLoginViewController.h"
#import "RDVTabBarController.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_code.layer.cornerRadius = 6;
    _btn_login.layer.cornerRadius = 6;
    _btn_code.clipsToBounds = YES;
    _btn_login.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}






- (IBAction)action_login:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)action_code:(id)sender {
}
@end
