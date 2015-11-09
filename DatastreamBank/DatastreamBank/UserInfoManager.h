//
//  UserInfoManager.h
//  DatastreamBank
//  登录用户信息管理
//  Created by OsnDroid on 15/10/31.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject


+(BOOL)saveDic:(NSDictionary *)dic;

+(id)readObjectByKey:(NSString *)key;

+(NSDictionary *)readUserInfo;

+(BOOL)clear;

+(BOOL)isFirstLoad;

+(BOOL)updateWithObject:(id)obj forKey:(NSString *)key;

+(BOOL)updateWithBool:(BOOL)boolValue forKey:(NSString *)key;

+(BOOL)updateWithFloat:(float)floatValue forKey:(NSString *)key;

+(BOOL)updateWithInteger:(NSInteger)intValue forKey:(NSString *)key;

@end
