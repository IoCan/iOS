//
//  FeedbackViewController.h
//  DatastreamBank
//  我的模块－意见反馈页面
//  Created by OsnDroid on 15/10/12.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedbackViewController : BaseViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *utv_content;

@property (strong, nonatomic) IBOutlet UIButton *btn_submit;

@property (strong, nonatomic) IBOutlet UIView *view_bg;

- (IBAction)submit:(id)sender;

@end
