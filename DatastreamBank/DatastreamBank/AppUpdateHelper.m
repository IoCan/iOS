//
//  AppUpdateHelper.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/12.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "AppUpdateHelper.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"


@implementation AppUpdateHelper

+(void)updateFromAppStore:(UIView *)view {
    NSString *url = @"http://itunes.apple.com/lookup?id=903331047";
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:view];
    toast.labelText = @"正在检查";
    toast.mode = MBProgressHUDModeIndeterminate;
    [view addSubview:toast];
    [toast show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSLog(@"%@",responseObject);
        NSArray *configData = [responseObject valueForKey:@"results"];
        NSString *version;
        for (id config in configData)
        {
            version = [config valueForKey:@"version"];
        }
        NSString *localVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (![version isEqualToString:localVersion])
        {
            UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"有新版本!" message: @"亲，新版上线了哦～" delegate:view cancelButtonTitle:@"取消" otherButtonTitles: @"更新", nil];
            [createUserResponseAlert show];
        } else {
            MBProgressHUD *toastsuccess = [[MBProgressHUD alloc] initWithView:view];
            toastsuccess.labelText = @"已经是最新的了！";
            toastsuccess.mode = MBProgressHUDModeText;
            [view addSubview:toast];
            [toastsuccess show:YES];
            [toastsuccess hide:YES afterDelay:2];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",(long)error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"提示" message: param delegate:nil cancelButtonTitle:nil  otherButtonTitles: @"确定", nil];
        [createUserResponseAlert show];
    }];
 
  
  
}


@end
