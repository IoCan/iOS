//
//  ConfirmOrderViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/27.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"


@interface ConfirmOrderViewController : BaseViewController<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btn_chk1;
@property (strong, nonatomic) IBOutlet UIButton *btn_chk2;
@property (strong, nonatomic) IBOutlet UIButton *btn_order;
@property (strong, nonatomic) IBOutlet UILabel *label_prompt;

- (IBAction)action_ok:(id)sender;
@property (strong,nonatomic) NSMutableDictionary *dic;



@end
