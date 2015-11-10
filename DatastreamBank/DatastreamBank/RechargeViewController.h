//
//  RechargeViewController.h
//  DatastreamBank
//  首页－备胎账户－充值手机账户
//  Created by OsnDroid on 15/10/26.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
#import "THContactPickerViewController.h"

@interface RechargeViewController : BaseViewController<SelectedPhoneDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btn_200;

@property (strong, nonatomic) IBOutlet UIButton *btn_500;

@property (strong, nonatomic) IBOutlet UIButton *btn_1024;

@property (strong, nonatomic) IBOutlet UILabel *label_phone;

@property (strong, nonatomic) IBOutlet UILabel *label_city;

- (IBAction)action_seluser:(id)sender;
@end
