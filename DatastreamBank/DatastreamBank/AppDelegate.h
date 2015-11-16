//
//  AppDelegate.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/9/9.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "ConfirmOrderViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;


@end

