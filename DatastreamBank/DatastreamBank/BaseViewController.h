//
//  BaseViewController.h
//  UIViewController 基子类
//
//  Created by OsnDroid on 14-8-2.
//  Copyright (c) 2014年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface BaseViewController : UIViewController

//加载提示
@property (nonatomic,strong) MBProgressHUD *toast;
//是否有返回按钮
@property(nonatomic,assign)BOOL isBackButton;
//push到模态页面是否含有取消按钮
@property(nonatomic,assign)BOOL isCancelButton;
//顶部状态修改window
@property(nonatomic,strong)UIWindow *tipWindow;

//设置白色导航背景
-(void)setWhiteNav;
//设置蓝绿色的导航背景
-(void)setBlueNav;
//提示toast
-(void)toast:(UIView *) view cotent:(NSString *) param;
//成功带图标的提示
-(void)toastsucess:(UIView *) view cotent:(NSString *) param;
//状态栏修改提示
-(void)showStatusTip:(BOOL)show title:(NSString *)title;
-(void)okAction;
//弹窗提示
- (void)alert:(NSString *)title msg:(NSString *)msg;



@end
