//
//  PresentViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/15.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"

@interface PresentViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btn_ok;
@property (strong, nonatomic) IBOutlet UIButton *btn_cancle;
- (IBAction)action_ok:(id)sender;
- (IBAction)action_cancle:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *ShapeView;
@property (strong, nonatomic) IBOutlet UILabel *label_content;
@property (strong, nonatomic) IBOutlet UITextField *txt_flow;

@property (strong,nonatomic) NSString *fdmobile;

@end
