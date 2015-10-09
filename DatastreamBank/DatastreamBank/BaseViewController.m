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

    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count==1) {
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count==1) {
        //[[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    }else{
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }
 
}


-(void)cancleAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
}




 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
