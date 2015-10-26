//
//  UserLoginViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"

@interface UserLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *btn_code;
@property (strong, nonatomic) IBOutlet UIButton *btn_login;
- (IBAction)action_login:(id)sender;

- (IBAction)action_code:(id)sender;

@end
