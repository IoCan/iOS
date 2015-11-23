//
//  GuideViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/20.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "GuideViewController.h"
#import "MainViewController.h"
#import "RDVTabBarController.h"
#import "AppDelegate.h"
#import "UserLoginViewController.h"
#import "NSString+Phone.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.contentSize = CGSizeMake(ScreenWidth*4, ScreenHeight);
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    _scrollView.delegate = self;
    [self createPages];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

- (void)createPages {

    UIImageView *view1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UIImageView *view2 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight)];
    UIImageView *view3 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, ScreenHeight)];
    UIImageView *view4 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*3, 0, ScreenWidth, ScreenHeight)];
    [view4 setUserInteractionEnabled:YES];
    UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2-80, ScreenHeight - 100, 160, 38)];
    [btn setTitle:@"立即开玩" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.titleLabel.tintColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 2.0f;
    btn.layer.borderWidth = 1;
    btn.enabled = YES;
    [btn addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.clipsToBounds = YES;
    [view4 addSubview:btn];
    [view1 setImage:[UIImage imageNamed: @"guide1"]];
    [view2 setImage:[UIImage imageNamed: @"guide2"]];
    [view3 setImage:[UIImage imageNamed: @"guide3"]];
    [view4 setImage:[UIImage imageNamed: @"guide4"]];
    [_scrollView addSubview:view1];
    [_scrollView addSubview:view2];
    [_scrollView addSubview:view3];
    [_scrollView addSubview:view4];
   
}

-(void)open:(id)sender {
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    if ([NSString isMobileNumber:mobile]) {
        RDVTabBarController *tabBarController = [[[MainViewController alloc] init] setupViewControllers];
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

    } else {
        //登录页面
         UserLoginViewController *login = [[UserLoginViewController alloc] init];
        AppDelegate *deleteview =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        deleteview.window.rootViewController  = login;
//        [UIView transitionFromView:deleteview.window.rootViewController.view
//                            toView:login.view
//                          duration:1.0
//                           options:UIViewAnimationOptionTransitionCrossDissolve
//                        completion:^(BOOL finished)
//         {
//             deleteview.window.rootViewController  = login;
//         }];
      
    }
    
}

- (void)changePage:(id)sender {
    long page = _pageControl.currentPage;
    // update the scroll view to the appropriate page
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark - 生命周期
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

 

@end
