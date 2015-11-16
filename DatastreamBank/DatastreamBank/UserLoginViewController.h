//
//  UserLoginViewController.h
//  DatastreamBank
//  登录页面
//  Created by OsnDroid on 15/10/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//


@interface UserLoginViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btn_code;
@property (strong, nonatomic) IBOutlet UIButton *btn_login;
@property (strong, nonatomic) IBOutlet UITextField *txt_phone;
@property (strong, nonatomic) IBOutlet UITextField *txt_code;

@property (strong, nonatomic) IBOutlet UIView *top_view;

- (IBAction)action_login:(id)sender;
- (IBAction)action_code:(id)sender;

@end
