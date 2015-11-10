//
//  BaseViewController.h
//  OsnDroidWeiBo
//
//  Created by OsnDroid on 14-8-2.
//  Copyright (c) 2014年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface BaseViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic,strong) MBProgressHUD *toast;

@property(nonatomic,assign)BOOL isBackButton;
@property(nonatomic,assign)BOOL isCancelButton;
@property(nonatomic,strong)UIWindow *tipWindow;


-(void)setWhiteNav;
-(void)setBlueNav;
-(void)toast:(UIView *) view cotent:(NSString *) param;
-(void)toastsucess:(UIView *) view cotent:(NSString *) param;
//状态栏
-(void)showStatusTip:(BOOL)show title:(NSString *)title;
-(void)okAction;

- (void)alert:(NSString *)title msg:(NSString *)msg;



@end
