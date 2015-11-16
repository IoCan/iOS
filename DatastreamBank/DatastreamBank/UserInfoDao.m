//
//  UserInfoDao.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/6.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "UserInfoDao.h"
#import "AFHTTPRequestOperationManager.h"

@implementation UserInfoDao

+(void)updateLocalUserInfoFromService {
 
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSDictionary *parameters = @{ican_mobile:mobile,ican_password:password};
    [manager POST:[BaseUrlString stringByAppendingString:@"userquery.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"00"]) {
            NSDictionary *userList = [responseObject objectForKey:UserInfo];
            [UserInfoManager saveDic:userList];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

}

+(void)updateUnReadInfoToService:(NSString *)msgStatus
                      parameters:(NSString *)msgid
                         success:(void (^)(NSString * msgid, id responseObject))success
                         failure:(void (^)(NSString * msgid, NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSDictionary *parameters = @{ican_mobile:mobile,
                                 ican_password:password,
                                 @"msgid":msgid,
                                 @"msgstatus":msgStatus};
    [manager POST:[BaseUrlString stringByAppendingString:@"sysmessageupdate.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(msgid,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(msgid,error);
    }];
}

@end
