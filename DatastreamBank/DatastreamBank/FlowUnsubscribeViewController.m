//
//  FlowUnsubscribeViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/23.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "FlowUnsubscribeViewController.h"
#import "UIButton+WebCache.h"
#import "NSString+Phone.h"
#import "AFHTTPRequestOperationManager.h"

@interface FlowUnsubscribeViewController ()

@property int virtualflow;
@property(nonatomic) float nheight;
@end

@implementation FlowUnsubscribeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"流量退订";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_header.layer.cornerRadius = _btn_header.frame.size.width/2;
    _btn_header.layer.borderColor = [UIColor whiteColor].CGColor;
    _btn_header.layer.borderWidth = 2.0f;
    _btn_header.clipsToBounds = YES;
    
    _btn_ok.layer.cornerRadius = 6;
    _btn_ok.clipsToBounds = YES;
    NSString *param = [NSString stringWithFormat:@"M(可退%@元)",@"0"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:param];
    [str addAttribute:NSForegroundColorAttributeName value:RGBA(254, 135, 6, 1.0) range:NSMakeRange(4,1)];
    _label_canback.attributedText = str;
    
    [self canlayer:_txt_canback left:NO];
    [self canlayer:_txt_name left:YES];
    [self canlayer:_txt_acount left:YES];
    
    _txt_canback.delegate = self;
    _txt_name.delegate = self;
    _txt_acount.delegate = self;
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    _virtualflow = [[UserInfoManager readObjectByKey:ican_virtualflow] intValue];
    NSString *headpath = [UserInfoManager readObjectByKey:ican_headpath];
    self.label_userphone.text = [NSString stringWithFormat:@"账户：%@",mobile];
    self.label_balance.text = [NSString stringWithFormat:@"备胎余额：%dM",_virtualflow];
    if (headpath!=nil && headpath.length>10) {
        NSString *headurl = [BaseUrlString stringByAppendingString:headpath];
        [_btn_header sd_setBackgroundImageWithURL:[NSURL URLWithString:headurl]
                               forState:UIControlStateNormal
                       placeholderImage:[UIImage imageNamed:@"img_header_default.png"]
                                options:SDWebImageDelayPlaceholder
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  //                                                      NSLog(@"%@",error);
                              }];
        
    }

}


#pragma mark - UITextField代理
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([@"\n" isEqualToString:string] == YES) {
        if ([_txt_canback isEqual:textField]) {
            [_txt_acount becomeFirstResponder];
        }
        if ([_txt_acount isEqual:textField]) {
            [_txt_name becomeFirstResponder];
        }
        if ([_txt_name isEqual:textField]) {
            [_txt_name resignFirstResponder];
        }
        return YES;
    }
    if ([_txt_canback isEqual:textField]) {
        if (string.length>0 && ![self isPureInt:string]) {
            [self toast:self.view cotent:@"请输入数字类型"];
            return NO;
        }
        NSString *text = textField.text;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        int tmpflow = [text intValue];
        if (tmpflow > _virtualflow) {
            tmpflow = _virtualflow;
        }
        float floatValue = tmpflow*0.05;
        NSString *priceStr = [NSString stringWithFormat:@"%0.2f", floatValue];
        NSString *param = [NSString stringWithFormat:@"M(可退%@元)",priceStr];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:param];
        NSRange rang = [param rangeOfString:priceStr];
        [str addAttribute:NSForegroundColorAttributeName value:RGBA(254, 135, 6, 1.0) range:NSMakeRange(rang.location,priceStr.length)];
        _label_canback.attributedText = str;
        if ([text intValue] > _virtualflow) {
            _txt_canback.text = @"";
            _txt_canback.text = [NSString stringWithFormat:@"%d",_virtualflow];
            [self toast:self.view cotent:[NSString stringWithFormat:@"你最多只能退%dM",_virtualflow]];
            [_txt_canback resignFirstResponder];
            return NO;
        }

    }
    return YES;
}


-(BOOL)textFieldShouldClear:(UITextField *)textField {
    NSString *param = [NSString stringWithFormat:@"M(可退%@元)",@"0"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:param];
    [str addAttribute:NSForegroundColorAttributeName value:RGBA(254, 135, 6, 1.0) range:NSMakeRange(4,1)];
     _label_canback.attributedText = str;
    return YES;
}

-(void)canlayer:(UITextField *) field left:(BOOL) is{
    field.layer.borderColor = RGBA(233, 233, 233, 1.0).CGColor;
    field.layer.borderWidth = 1.0f;
    field.layer.cornerRadius = 4;
    field.clipsToBounds = YES;
    if(is) {
        field.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        field.leftViewMode = UITextFieldViewModeAlways;
    }
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


- (IBAction)action_ok:(id)sender {
    NSString *canBackM = _txt_canback.text;
    if ([NSString isBlankString:canBackM]) {
        [self toast:self.view cotent:@"请输入退款额度"];
        return;
    }
    if (![self isPureInt:canBackM]) {
        [self toast:self.view cotent:@"请输入纯数字类型"];
        return;
    }
    int backflow = [canBackM intValue];
    int virtualflow = [[UserInfoManager readObjectByKey:ican_virtualflow] intValue];
    if (backflow > virtualflow) {
        [self toast:self.view cotent:@"请输入纯数字类型"];
        return;
    }
    NSString *acount = _txt_acount.text;
    NSString *name = _txt_name.text;
    if ([NSString isBlankString:acount]) {
        [self toast:self.view cotent:@"请输入支付宝账号"];
        return;
    }
    if ([NSString isBlankString:name]) {
        [self toast:self.view cotent:@"请输入支付宝账户姓名"];
        return;
    }
    float floatValue = backflow*0.05;
    NSString *priceStr = [NSString stringWithFormat:@"%0.2f", floatValue];
    NSString *msg = [NSString stringWithFormat:@"亲，您确定要从流量备胎账户退订%@M?\n（注：可折算人民币%@元）",canBackM,priceStr];
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"支付宝退款"
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:@"放弃"
                                           otherButtonTitles:@"继续退订", nil];
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            //退订
            [self unsubscribe];
            break;
        default:
            break;
    }
}

#pragma mark - 退订操作
-(void)unsubscribe {
    [_scrollView resignFirstResponder];
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"提交退款";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSString *acount = _txt_acount.text;
    NSString *name = _txt_name.text;
    NSString *canBackM = _txt_canback.text;
    NSDictionary *parameters = @{ican_mobile:mobile,
                                 ican_password:password,
                                 @"payway":@"alipay",
                                 @"account":acount,
                                 @"virflow":canBackM,
                                 @"name":name
                                 };
    [manager POST:[BaseUrlString stringByAppendingString:@"drawback.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        MyLog(@"%@",responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"00"]) {
            NSString *flow = [responseObject objectForKey:@"flow"];
            self.label_balance.text = [NSString stringWithFormat:@"备胎余额：%@M",flow];
            [UserInfoManager updateWithObject:flow forKey:ican_virtualflow];
            [self alert:@"提示信息" msg:@"退款请求成功，系统将在2-7个工作日内为您退款至相应的账户，请注意查收。"];
        } else {
            [self alert:@"提示信息" msg:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示信息" msg:param];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
