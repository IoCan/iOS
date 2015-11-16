//
//  TimingRechargeViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/26.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "TimingRechargeViewController.h"
#import "NSString+Phone.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIUtils.h"
#define OPr_CM @"移动"
#define OPr_CU @"联通"
#define enableColor RGBA(243, 243, 243, 1.0)

@interface TimingRechargeViewController ()

@property (strong, nonatomic) UIButton *selBtn;
@property (strong,nonatomic) UIButton *okBtn;
@property (strong,nonatomic) NSString * selectedDate;

@end

@implementation TimingRechargeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"定时生效";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    _okBtn = [[UIButton alloc] init];
    _okBtn.frame = CGRectMake(0, 0, 45, 30);
    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_okBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    [_okBtn setTitleColor:RGBA(74,74,74,1) forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_okBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    _okBtn.hidden = YES;
    
    [_btn_200 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    [_btn_500 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    [_btn_1024 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    
    
    _label_phone.text = [NSString carveupPhoneNum:[UserInfoManager readObjectByKey:ican_mobile]];
    _label_cityop.text = [[[UserInfoManager readObjectByKey:ican_address] stringByAppendingString:@" "] stringByAppendingString:[UserInfoManager readObjectByKey:ican_operator]];
    [self checkOperator:[UserInfoManager readObjectByKey:ican_operator]];
    _datePicker.maximumDate = [self getPriousorLaterDateFromDate:[NSDate date] withMonth:2];
    _datePicker.minimumDate = [self getPriousorLaterDateFromDate:[NSDate date] withDay:1];
    self.selectedDate = [UIUtils stringFromFomate:_datePicker.minimumDate formate:@"yyyy-MM-dd"];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
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

-(void)dateChanged:(id)sender{
    UIDatePicker * control = (UIDatePicker*)sender;
    self.selectedDate = [UIUtils stringFromFomate:control.date formate:@"yyyy-MM-dd"];
}


-(void)checkboxClick:(UIButton*)btn{
    if (_selBtn) {
        _selBtn.selected = !_selBtn.selected;
    }
    _selBtn = btn;
    btn.selected=!btn.selected;//每次点击都改变按钮的状态
    
    if(btn.selected){
        _okBtn.hidden = NO;
    }
    //在此实现不打勾时的方法
    
}

-(void)okAction {
    NSString *msg = [NSString stringWithFormat:@"您确定冻结%@备胎流量用于%@号使用生效？",_selBtn.titleLabel.text,_selectedDate];
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //充值
        NSString *flow = [self getFlowByStr:_selBtn.titleLabel.text];
        [self recharge:flow];
    }
    
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

-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withDay:(int)day {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

-(void)recharge:(NSString *)flow {
    
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在请求";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSDictionary *parameters = @{ican_mobile:mobile,
                                 ican_password:password,
                                 @"flow":flow,
                                 @"nexttime":_selectedDate};
    [manager POST:[BaseUrlString stringByAppendingString:@"nextmonth.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"00"]) {
            NSString *flow = [responseObject objectForKey:@"flow"];
            [UserInfoManager updateWithObject:flow forKey:ican_virtualflow];
            [self toastsucess:self.view cotent:resultMsg];
        } else {
            [self alert:@"提示" msg:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示" msg:param];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
