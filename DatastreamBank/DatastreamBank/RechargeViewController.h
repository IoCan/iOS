//
//  RechargeViewController.h
//  DatastreamBank
//  首页－备胎账户－充值手机账户
//  Created by OsnDroid on 15/10/26.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
#import "IoContactViewController.h"

@interface RechargeViewController : BaseViewController<SelectedPhoneDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btn_200;

@property (strong, nonatomic) IBOutlet UIButton *btn_500;

@property (strong, nonatomic) IBOutlet UIButton *btn_1024;

@property (strong, nonatomic) IBOutlet UILabel *label_phone;



- (IBAction)action_seluser:(id)sender;
@end
