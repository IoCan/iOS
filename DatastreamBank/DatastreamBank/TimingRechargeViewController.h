//
//  TimingRechargeViewController.h
//  DatastreamBank
//  首页－备胎账户－定时生效
//  Created by OsnDroid on 15/10/26.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"

@interface TimingRechargeViewController : BaseViewController<UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UIButton *btn_200;

@property (strong, nonatomic) IBOutlet UIButton *btn_500;

@property (strong, nonatomic) IBOutlet UIButton *btn_1024;

@property (strong, nonatomic) IBOutlet UILabel *label_cityop;

@property (strong, nonatomic) IBOutlet UILabel *label_phone;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
