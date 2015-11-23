//
//  PresentViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/15.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "PresentViewController.h"
#import "NSString+Phone.h"
#import "AFHTTPRequestOperationManager.h"

@interface PresentViewController ()

@property int virtualflow;

@end

@implementation PresentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"确认赠送";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_cancle.layer.cornerRadius = 4;
    _btn_ok.layer.cornerRadius = 4;
    _btn_ok.clipsToBounds = YES;
    _btn_cancle.clipsToBounds = YES;
    [self updateLine];
    _txt_flow.delegate = self;
    NSString *name = [UserInfoManager readObjectByKey:ican_nickname];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    _virtualflow = [[UserInfoManager readObjectByKey:ican_virtualflow] intValue];
    if ([NSString isBlankString:name]) {
        name = mobile;
    }
    NSString *content = [NSString stringWithFormat:@"亲爱的%@，您的备胎余额为%dM，确定要为%@用户赠送",name,_virtualflow,_fdmobile];
    _label_content.text = content;
}

-(void)updateLine{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor lightGrayColor] CGColor]];
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:7],[NSNumber numberWithInt:3],nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, ScreenWidth,0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [[self.ShapeView layer] addSublayer:shapeLayer];
}

#pragma mark - UITextField代理
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([@"\n" isEqualToString:string] == YES) {
        [_txt_flow resignFirstResponder];
        return YES;
    }
    if ([_txt_flow isEqual:textField]) {
        if (string.length>0 && ![NSString isPureInt:string]) {
            return NO;
        }
        NSString *text;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
//        int tmpflow = [text intValue];
//        if (tmpflow > _virtualflow) {
//            tmpflow = _virtualflow;
//        }
        if ([text intValue] > _virtualflow) {
            _txt_flow.text = @"";
            _txt_flow.text = [NSString stringWithFormat:@"%d",_virtualflow];
            [self toast:self.view cotent:[NSString stringWithFormat:@"你最多只能赠送%dM",_virtualflow]];
            [_txt_flow resignFirstResponder];
            return NO;
        }
        
    }
    return YES;
}

#pragma mark - 赠送操作
-(void)present {
    [_txt_flow resignFirstResponder];
    NSString *flownum = _txt_flow.text;
    int n = [flownum intValue];
    if (n < 5) {
        [self toast:self.view cotent:@"赠送流量最低5M"];
        return;
    }
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在赠送";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    //接口赠送 presentvirflow.do
    //参数 mobile password fdmobile flownum
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSDictionary *parameters = @{ican_mobile:mobile,
                                 ican_password:password,
                                 @"fdmobile":_fdmobile,
                                 @"flownum":flownum
                                 };
    [manager POST:[BaseUrlString stringByAppendingString:@"presentvirflow.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
//        MyLog(@"%@",responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"00"]) {
//            NSLog(@"%@",[responseObject objectForKey:@"scorefull"]);
//            NSLog(@"%@",[responseObject objectForKey:@"resultMsg"]);
            NSInteger virflow = [[responseObject objectForKey:@"virflow"] integerValue];
            [UserInfoManager updateWithInteger:virflow forKey:ican_virtualflow];
            [UserInfoManager updateWithObject:[responseObject objectForKey:@"score"] forKey:ican_score];
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:resultMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
        } else {
            [self alert:@"提示信息" msg:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示信息" msg:param];
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
   [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)action_ok:(id)sender {
    [self present];
}

- (IBAction)action_cancle:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 生命周期
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
