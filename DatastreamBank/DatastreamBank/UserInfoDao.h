//
//  UserInfoDao.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/6.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoDao : NSObject

//刷新本地用户数据
+(void)updateLocalUserInfoFromService;
//更新未读信息状态
+(void)updateUnReadInfoToService:(NSString *)msgStatus
                      parameters:(NSString *)msgid
                         success:(void (^)(NSString * msgid, id responseObject))success
                         failure:(void (^)(NSString * msgid, NSError *error))failure;

@end
