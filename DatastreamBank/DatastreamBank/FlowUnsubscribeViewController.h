//
//  FlowUnsubscribeViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/23.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"

@interface FlowUnsubscribeViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btn_header;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIButton *btn_ok;

@property (strong, nonatomic) IBOutlet UILabel *label_userphone;
@property (strong, nonatomic) IBOutlet UILabel *label_balance;
@property (strong, nonatomic) IBOutlet UILabel *label_canback;

@property (strong, nonatomic) IBOutlet UITextField *txt_canback;
@property (strong, nonatomic) IBOutlet UITextField *txt_acount;
@property (strong, nonatomic) IBOutlet UITextField *txt_name;

- (IBAction)action_ok:(id)sender;
@end
