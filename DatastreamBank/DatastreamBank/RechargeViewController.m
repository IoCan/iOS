//
//  RechargeViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/26.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "RechargeViewController.h"
#import "NSString+Phone.h"
#import "AFHTTPRequestOperationManager.h"
#define OPr_CM @"移动"
#define OPr_CU @"联通"
#define enableColor RGBA(243, 243, 243, 1.0)

@interface RechargeViewController ()
@property (strong, nonatomic) UIButton *selBtn;
@property (strong,nonatomic) NSString *topupphone;//需要充值的手机号
@end

@implementation RechargeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"充至手机账户";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [_btn_200 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    [_btn_500 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    [_btn_1024 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    _topupphone = [UserInfoManager readObjectByKey:ican_mobile];
    _label_phone.text = [NSString carveupPhoneNum:_topupphone];
    [self checkOperator:[UserInfoManager readObjectByKey:ican_operator]];
    
}

-(void)initView {
    _btn_200.backgroundColor = [UIColor whiteColor];
    _btn_500.backgroundColor = [UIColor whiteColor];
    _btn_1024.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"bg_check_blue.png"];
    image = [image stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    UIImage *selImage = [UIImage imageNamed:@"bg_check_sel.png"];
    selImage = [selImage stretchableImageWithLeftCapWidth:2 topCapHeight:30];
    [_btn_200 setBackgroundImage:image forState:UIControlStateNormal];
    [_btn_500 setBackgroundImage:image forState:UIControlStateNormal];
    [_btn_1024 setBackgroundImage:image forState:UIControlStateNormal];
    
    
    [_btn_200 setBackgroundImage:selImage forState:UIControlStateSelected];
    [_btn_500 setBackgroundImage:selImage forState:UIControlStateSelected];
    [_btn_1024 setBackgroundImage:selImage forState:UIControlStateSelected];
    
    //90 189 210
    UIColor *ncolor = RGBA(90, 189, 210, 1.0);
    UIColor *scolor = RGBA(255, 120, 2, 1.0);
    [_btn_200 setTitleColor:scolor forState:UIControlStateSelected];
    [_btn_200 setTitleColor:ncolor forState:UIControlStateNormal];
    [_btn_500 setTitleColor:scolor forState:UIControlStateSelected];
    [_btn_500 setTitleColor:ncolor forState:UIControlStateNormal];
    [_btn_1024 setTitleColor:scolor forState:UIControlStateSelected];
    [_btn_1024 setTitleColor:ncolor forState:UIControlStateNormal];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //充值
        NSString *flow = [self getFlowByStr:_selBtn.titleLabel.text];
        [self recharge:flow];
    }

}

-(void)checkboxClick:(UIButton*)btn{
    if (_selBtn) {
        _selBtn.selected = !_selBtn.selected;
    }
    _selBtn = btn;
    btn.selected=!btn.selected;//每次点击都改变按钮的状态
    
    if(btn.selected){
        NSString *msg;
        if ([_topupphone isEqualToString:[UserInfoManager readObjectByKey:ican_mobile]]) {
            msg = [NSString stringWithFormat:@"你确定要给你当前登录的账号充值%@流量？",btn.titleLabel.text];
        } else {
            msg = [NSString stringWithFormat:@"你确定要给“%@”账号充值%@流量？",_topupphone,btn.titleLabel.text];
        }
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        [alter show];
    }
    //在此实现不打勾时的方法
    
}

-(NSString *)getFlowByStr:(NSString *) str {
    NSString *flow;
    if ([str isEqualToString:@"200M"]) {
        flow = @"200";
    } else if ([str isEqualToString:@"500M"]) {
        flow = @"500";
    } else if ([str isEqualToString:@"1G"]) {
        flow = @"1024";
    }
    return flow;
}

-(void)addImage:(NSString *)imagename bindN:(UIButton *) btn {
    UIImage *image = [UIImage imageNamed:imagename];
    image = [image stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
}

-(void)checkOperator:(NSString *) operator {
    if ([NSString isBlankString:operator]) {
        return;
    }
    if ([operator isEqualToString:OPr_CM]) {
        _btn_200.enabled = NO;
        _btn_200.backgroundColor = enableColor;
        [self addImage:@"bg_check.png" bindN:_btn_200];
        [_btn_200 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else if ([operator isEqualToString:OPr_CU]) {
        _btn_1024.enabled = NO;
        _btn_1024.backgroundColor = enableColor;
        [self addImage:@"bg_check.png" bindN:_btn_1024];
        [_btn_1024 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [self initView];
    }
    
}



-(void)selectedPhone:(NSString *)values {
     _topupphone = values;
     _label_phone.text = [NSString carveupPhoneNum:values];
    [self loadOpertor:values];
}


- (IBAction)action_seluser:(id)sender {
    IoContactViewController *ctrl = [[IoContactViewController alloc] init];
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - 网络请求
-(void)loadOpertor:(NSString *)phone {
    NSLog(@"%@",phone);
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"号码校验";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{ican_mobile:phone};
    [manager POST:[BaseUrlString stringByAppendingString:@"operator.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"00"]) {
            [self checkOperator:[responseObject objectForKey:@"operator"]];
            
        } else {
            [self alert:@"提示" msg:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示" msg:param];
    }];
}

-(void)recharge:(NSString *)flow {

    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在充值";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    NSString *fdmobile = _topupphone;
    if ([_topupphone isEqualToString:[UserInfoManager readObjectByKey:ican_mobile]]) {
        fdmobile = @"";
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSDictionary *parameters = @{ican_mobile:mobile,
                                 ican_password:password,
                                 @"flow":flow,
                                 @"fdmobile":fdmobile};
    [manager POST:[BaseUrlString stringByAppendingString:@"virtualtophone.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"00"]) {
            NSString *msg;
            if ([resultMsg isEqualToString:@"00000"]) {
                int f = [flow intValue];
                int l = [[UserInfoManager readObjectByKey:ican_virtualflow] intValue];
//                NSString *a = [NSString stringWithFormat:@"%d",(l-f)];
                [UserInfoManager updateWithInteger:(l-f) forKey:ican_virtualflow];
                msg = [NSString stringWithFormat:@"您已经成功充值%@流量至手机账户，操作正在进行中，具体到账时间以短信通知为准，请注意查看。",_selBtn.titleLabel.text];
            }else if([resultMsg isEqualToString:@"10001"]) {
                msg = @"该手机尚不支持充值";
            }else if([resultMsg isEqualToString:@"10003"]) {
                msg = @"非法参数";
            }else if([resultMsg isEqualToString:@"10010"]) {
                msg = @"号码欠费";
            }else if([resultMsg isEqualToString:@"10016"]) {
                msg = @"不能重复订购";
            }else {
                msg = @"系统异常，正在抢修...";
            }
            [self alert:@"提示" msg:msg];
        } else {
            [self alert:@"提示" msg:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示" msg:param];
    }];
    
}


#pragma mark - 生命周期
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
