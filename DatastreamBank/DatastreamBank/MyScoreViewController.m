//
//  MyScoreViewController.m
//  DatastreamBank
//  我的模块－我的积分
//  Created by OsnDroid on 15/10/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "MyScoreViewController.h"
#import "WebViewController.h"
#import "ScoreTakeViewController.h"
#import "UserInfoManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserInfoManager.h"

@interface MyScoreViewController ()
@property(nonatomic,strong) UIAlertView *change1alert;
@property(nonatomic,strong) UIAlertView *change2alert;
@property(nonatomic,strong) AFHTTPRequestOperation *operation;
@end

@implementation MyScoreViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的积分";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_takescore.layer.cornerRadius = 5.0f;
    _btn_scorerule.layer.cornerRadius = 5.0f;
    UIImage *sxImg = [UIImage imageNamed:@"bg_white_sxline.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
    sxImg = [sxImg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    _img_change.image = sxImg;
    _img_changerule.image = sxImg;
   
    _view_changebg1.layer.borderWidth =2.0f;
    _view_changebg1.layer.backgroundColor = UIColor.whiteColor.CGColor;
    UIColor *selcolor = RGBA(91, 190, 211, 1.0);
    
    _view_changebg1.layer.borderColor = selcolor.CGColor;
    _view_changebg2.layer.borderWidth = 2.0f;
    _view_changebg2.layer.backgroundColor = UIColor.whiteColor.CGColor;
    _view_changebg2.layer.borderColor = selcolor.CGColor;
    _btn_change1.layer.cornerRadius = 5.0f;
    _btn_change2.layer.cornerRadius = 5.0f;
    _img_userhead.layer.cornerRadius = _img_userhead.width/2;
    _img_userhead.layer.borderColor = [UIColor whiteColor].CGColor;
    _img_userhead.layer.borderWidth = 2;
    _img_userhead.clipsToBounds = YES;
    NSString *score = [UserInfoManager readObjectByKey:ican_score];
    NSString *headpath = [UserInfoManager readObjectByKey:ican_headpath];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *headurl = [BaseUrlString stringByAppendingString:headpath];
    [_img_userhead sd_setImageWithURL:[NSURL URLWithString:headurl]];
    self.label_userphone.text = [NSString stringWithFormat:@"账户：%@",mobile];
    self.label_userscore.text = [NSString stringWithFormat:@"当前积分：%@",score];
    

}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _view_allbg.height =540;
    _scrollView.contentSize = _view_allbg.frame.size;
    
   
}



#pragma mark - 按钮事件处理
- (IBAction)actionChange1:(id)sender {
    if (self.change1alert == nil) {
        self.change1alert  = [[UIAlertView alloc] initWithTitle: @"积分兑换"
                                                     message:@"您需要消耗500积分来换取50M流量"
                                                    delegate:self
                                           cancelButtonTitle:@"继续兑换"
                                           otherButtonTitles:@"放弃", nil];
    }
    [self.change1alert show];
}

- (IBAction)actionChange2:(id)sender {
    if (self.change2alert == nil) {
        self.change2alert  = [[UIAlertView alloc] initWithTitle: @"积分兑换"
                                                     message:@"您需要消耗500积分来换取5元话费"
                                                    delegate:self
                                           cancelButtonTitle:@"继续兑换"
                                           otherButtonTitles:@"放弃", nil];
    }
    [self.change2alert show];
}


- (IBAction)actionTake:(id)sender {
    ScoreTakeViewController *scoreCtrl = [[ScoreTakeViewController alloc] init];
    [self.navigationController pushViewController:scoreCtrl animated:YES];
    
}

- (IBAction)actionRule:(id)sender {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"jf_rule" ofType:@"html"];
    WebViewController *webView = [[WebViewController alloc] initWithUrl:filePath];
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - 弹窗事件处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:self.change1alert]) {
        switch (buttonIndex) {
            case 0:
                //兑换50m流量
                [self scoreChange:@"toflow"];
                break;
            case 1:
                break;
            default:
                break;
        }
    }
    
    if ([alertView isEqual:self.change2alert]) {
        switch (buttonIndex) {
            case 0:
                //兑换5元话费
                NSLog(@"兑换5元话费..");
                [self scoreChange:@"toexpen"];
                break;
            case 1:
                break;
            default:
                break;
        }
    }
}

#pragma mark - 提交兑换操作
-(void)scoreChange:(NSString *) type {
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在兑换";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                                 ican_password:[UserInfoManager readObjectByKey:ican_password],
                                 @"type":type};
    self.operation = [manager POST:[BaseUrlString stringByAppendingString:@"socreconvert.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSLog(@"%@",responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"00"]) {
            NSInteger score = [[responseObject objectForKey:@"score"] integerValue];
            [UserInfoManager updateWithInteger:score forKey:ican_score];
            self.label_userscore.text = [NSString stringWithFormat:@"当前积分：%ld",score];
        }
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"积分兑换"
                                                         message:resultMsg
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"确定", nil];
        
        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",(long)error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:param
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"确定", nil];
        
        [alert show];
    }];

}

#pragma mark - 生命周期处理
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    if(self.operation != nil) {
        [self.operation cancel];
    }
}

@end
