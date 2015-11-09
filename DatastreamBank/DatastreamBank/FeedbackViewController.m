//
//  FeedbackViewController.m
//  DatastreamBank
//  我的－意见反馈
//  Created by OsnDroid on 15/10/12.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"意见反馈";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWhiteNav];
    _utv_content.delegate = self;
    _utv_content.textColor = [UIColor lightGrayColor];
    _utv_content.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _utv_content.layer.borderWidth = 0.4;
    _utv_content.layer.cornerRadius = 6;
    _utv_content.layer.masksToBounds = YES;
    _btn_submit.layer.cornerRadius = 6;
    UIImage *sxImg = [UIImage imageNamed:@"bg_white_sxline.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
    sxImg = [sxImg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    _img_bg.image = sxImg;
}


- (IBAction)submit:(id)sender {
    [self send];
}


-(void)send {
    [_utv_content resignFirstResponder];
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在提交";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSString *leavemsg = _utv_content.text;
    NSDictionary *parameters = @{ican_mobile:mobile,@"password":password,@"leavemsg":leavemsg};
    [manager POST:[BaseUrlString stringByAppendingString:@"feedbackadd.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"00"]) {
            [self toastsucess:self.view cotent:resultMsg];
            _utv_content.text=@"请输入您的宝贵意见...";
            _btn_submit.enabled = NO;
            _utv_content.textColor = [UIColor lightGrayColor];
        } else {
            [self alert:@"提示" msg:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示" msg:param];
    }];

}

#pragma mark -  txt代理实现
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _utv_content.text=@"";
    _utv_content.textColor = [UIColor blackColor];
    return YES;
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
       return YES;

}

- (void)textViewDidChange:(UITextView *)textView {

    NSString *content = _utv_content.text;
    if ([content isEqualToString:@""] || content.length==0) {
        [_btn_submit setEnabled:NO];
        [_btn_submit setBackgroundColor:RGBA(204,204,204,1.0)];
        
    }else{
        [_btn_submit setEnabled:YES];
        [_btn_submit setBackgroundColor:RGBA(90, 187, 208, 1.0)];
    }

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
   if ([@"\n" isEqualToString:text] == YES) {
       [self send];
   }
   return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
 


@end
