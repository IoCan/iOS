//
//  NSString+Phone.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/29.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Phone)

//判断字符串是否为手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//判断字符串是否为6位数字类型
+ (BOOL)isSixCodeNumber:(NSString *)num;
//判断字符串是否为空或nil
+ (BOOL)isBlankString:(NSString *)string;
//格式化手机号，去除所有空格＋86等等信息
+ (NSString *)formatPhoneNum:(NSString *)phone;
//判断字符串是否说整形数字类型
+ (BOOL)isPureInt:(NSString*)string;
//分割手机号15105175425->151 0517 5425
+(NSString *)carveupPhoneNum:(NSString *)phone;

@end
