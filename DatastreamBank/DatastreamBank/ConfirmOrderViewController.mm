//
//  ConfirmOrderViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/27.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIUtils.h"
#import "payRequsestHandler.h"
#import "WXApi.h"
#import "UserInfoDao.h"
#import "MyOrderViewController.h"

//------支付宝------
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
//.m使用
#import "DataSigner.h"
//.mm使用
#import "RSADataSigner.h"

#define alipay @"alipay"
#define wechat @"wechat"

/*============================================================================*/
/*=======================支付宝需要填写商户app申请的===================================*/
/*============================================================================*/

//支付宝配置

// 商户PID
static NSString *alipayPartner = @"2088811488214283";
// 商户收款账号
static NSString *alipaySeller = @"llbeitai@163.com";
// 商户私钥，pkcs8格式
static NSString *aliPayPrivateKey= @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBALRuf882DouwGiCG0SH/NHeoyEG7lCk17KpK8xWPLcgI2yBRWQf9NSK+kINOhAAvD8gwab0rEKU+D8Wq/cRSVOKbqpMlpnxr14vTmu82rxgcTA0AW1iccrE1qm9g9eldpa91htKhSgYCxChE6l3Mn8NpF0g984IrJoobqWWc2ItbAgMBAAECgYBT2WYb7Ysk71m08/IMUoUXdqBZq8pWvHCXUu1Uf41PAI6Unjk5tToUQ2r1Gm/NhhFXfugkuParVAQQYD4+FeTMArj0Cc1BFt7XqjFo8aX62cl4XtYh0UnxrRyykEpcPw264PaxZdrvnb6bUdXDa3yIXUX/7z1jsYOa3qT6gBt0QQJBANhDkUX3eQDFsjKiuOuGL8PbdnBqUkQzgINY4jPXt+FGDvgl931XRj2e+0/SCBgIUj5CXrlQE/mXMG0V+P8JT18CQQDVlXvVDFMRgCS7dHQiA+KhszWX0lsT5Q6++WWG+4Yzu5npKHw4WqnGgUqs//K2AQ0GZh3binVDc/HnmbxTYxGFAkEAqAGtvR4o+cmbyyyQ3h/rwYsf8usWJ/eeset+J2pBZpfHj03ne48ueTal4/e14/2q7sUe03X7Xp3uuAAm5PJ1nwJBAIn+vfZlsxoAiDsRP6NmjTvaVMsV30CYYxGigyVWR1wPXp7VSIUEluKpUH08FS3gufCjc7EP4TnGpMn1e0cJIB0CQQDEF/MUpW/DBvasBhpxuXusx3dpXPI47XjbhUr/bJ2NCmm5mvbBx8JgYD3ns8LjjKRn+xoN4M3VsE11xA9UTB6b";


//static NSString *URLScheme = @"wx778793f74edd0880";

// 服务器异步通知页面
static NSString *alipayNotifServerURL = @"http://202.102.39.91/spare_wheel/libt_jsgx_hlkj_2007.jsp";


@interface ConfirmOrderViewController ()
@property(nonatomic,strong) UIButton *selBtn;
@property(nonatomic,strong) AFHTTPRequestOperation *operation;
@property(nonatomic,strong) NSString *content;
@end

@implementation ConfirmOrderViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"确认订购";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"bg_check.png"];
    image = [image stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    UIImage *selImage = [UIImage imageNamed:@"bg_check_sel2.png"];
    selImage = [selImage stretchableImageWithLeftCapWidth:2 topCapHeight:20];
    [_btn_chk1 setBackgroundImage:image forState:UIControlStateNormal];
    [_btn_chk2 setBackgroundImage:image forState:UIControlStateNormal];
    
    [_btn_chk1 setBackgroundImage:selImage forState:UIControlStateSelected];
    [_btn_chk2 setBackgroundImage:selImage forState:UIControlStateSelected];
    
    [_btn_chk1 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    [_btn_chk2 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    
    _btn_order.layer.cornerRadius = 6;
    _btn_order.clipsToBounds = YES;
    NSInteger flow = [[_dic objectForKey:@"flow"] integerValue];
    NSInteger price = [[_dic objectForKey:@"price"] integerValue];

    _content = [NSString stringWithFormat:@"%ld元包%ldM",(long)price,(long)flow];
    NSString *param = [NSString stringWithFormat:@"亲爱的%@用户，您选择了%@备胎流量，确认顶请选择以下支付方式:",[UserInfoManager readObjectByKey:ican_mobile],_content];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:param];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4];
    NSRange rang = [param rangeOfString:_content];
    [str addAttribute:NSForegroundColorAttributeName value:RGBA(254, 135, 6, 1.0) range:NSMakeRange(rang.location,_content.length)];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    _label_prompt.attributedText = str;
//    [_btn_order addTarget:self action:_delegtesendPay forControlEvents:UIControlEventTouchUpInside]
   
}

-(void)checkboxClick:(UIButton*)btn{
    if (_selBtn) {
        _selBtn.selected = !_selBtn.selected;
    }
    _selBtn = btn;
    btn.selected=!btn.selected;//每次点击都改变按钮的状态
    
    if(btn.selected){
        
    }else{
        
        //在此实现打勾时的方法
        
    }
    
    //在此实现不打勾时的方法
    
}
 

- (IBAction)action_ok:(id)sender {
    if (_btn_chk1.isSelected) {
        NSLog(@"支付宝...");
        [self createorder:alipay goodsId:[_dic objectForKey:@"id"]];
    } else if(_btn_chk2.isSelected) {
        NSLog(@"微信支付...");
        [self createorder:wechat goodsId:[_dic objectForKey:@"id"]];
    } else {
        [self toast:self.view cotent:@"请选择一种支付方式"];
    }
}

-(void)createorder: (NSString *) payway goodsId:(NSString *) vaules{
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在加载";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    NSString *nowdate = [UIUtils stringFromFomate:[NSDate date] formate:@"yyyyMMddHHmmss"];
    NSString *ordernum = [nowdate stringByAppendingFormat:@"%d",[self getRandomNumber:100 to:999]];
    NSLog(@"%@",ordernum);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                                 ican_password:[UserInfoManager readObjectByKey:ican_password],
                                 @"payway":payway,
                                 @"ordernum":ordernum,
                                 @"paytype":@"btaccount",
                                 @"proid":vaules};
    self.operation = [manager POST:[BaseUrlString stringByAppendingString:@"createorder.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        @try {
            NSString *result = [responseObject objectForKey:@"result"];
            if ([@"00" isEqualToString:result]) {
                if ([payway isEqualToString:alipay]) {
                     [self payAlipay:ordernum];
                } else {
                    [self payWechat:ordernum];
                }
               
            } else {
                NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
                [self toast:self.view cotent:resultMsg];
            }
        }
        @catch (NSException *exception) {

        }
        @finally {
            
        }
        
        
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

-(void)payAlipay:(NSString *) tn {

    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = alipayPartner;
    order.seller = alipaySeller;
    order.tradeNO = tn; //订单ID（由商家自行制定）
    order.productName = [@"备胎－购买" stringByAppendingString:_content];//_content; //商品标题
    order.productDescription = [@"流量购买-" stringByAppendingString:_content]; //商品描述
    NSString *price =[NSString stringWithFormat:@"%ld",(long)[[_dic objectForKey:@"price"] integerValue]];
    order.amount = price; //商品价格
    order.notifyURL = alipayNotifServerURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
 
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
     //[[RSADataSigner alloc] initWithPrivateKey:orderSpec];
    id<DataSigner> signer = //[[RSADataSigner alloc] initWithPrivateKey:aliPayPrivateKey];
    CreateRSADataSigner(aliPayPrivateKey);

    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        @try {
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:APP_ID callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                if ([resultDic[@"resultStatus"] intValue]==9000) {
                    //进入充值列表页面
                    NSLog(@"支付成功");
                    [UserInfoDao updateLocalUserInfoFromService];
                   
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else{
                    NSString *resultMes = resultDic[@"memo"];
                    resultMes = (resultMes.length<=0?@"支付失败":resultMes);
                    [self alert:@"提示" msg:resultMes];
                }
            }];
        }
        @catch (NSException *exception) {
             NSLog(@"%@",exception.description);
            [self alert:@"Error" msg:exception.description];
            
        }
        @finally {

        }
       
    }
   
}

- (void)payWechat:(NSString *)tn
{
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:tn dic:_dic title:_content];
    @try {
        if(dict == nil){
            //错误提示
            NSString *debug = [req getDebugifo];
            [self alert:@"提示信息" msg:debug];
        }else{
//            NSLog(@"-------\n%@\n\n",[req getDebugifo]);
            //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
            
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
        }

    }
    @catch (NSException *exception) {

    }
    @finally {
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if ([alertView.message containsString:@"成功"]) {
        MyOrderViewController *mCtrl = [[MyOrderViewController alloc] init];
        [self.navigationController pushViewController:mCtrl animated:YES];
        [self.navigationController popViewControllerAnimated:NO];
    }
}


-(int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to-from + 1)));
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
