//
//  NSString+Phone.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/29.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "NSString+Phone.h"

@implementation NSString (Phone)

//判断验证码6位数
+ (BOOL)isSixCodeNumber:(NSString *)num {
    NSString * six = @"\\d{6}";
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", six];
    return [regextest evaluateWithObject:num] == YES;
}

///// 手机号码的有效性判断
//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(6[0-9]|9[0-9]|7[0-9]|5[0-9]|3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString *CU = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString *CT = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)formatPhoneNum:(NSString *)phone {
    if ([phone hasPrefix:@"86"]) {
        NSString *formatStr = [phone substringWithRange:NSMakeRange(2, [phone length]-2)];
        return formatStr;
    }
    else if ([phone hasPrefix:@"+86"])
    {
        if ([phone hasPrefix:@"+86·"]) {
            NSString *formatStr = [phone substringWithRange:NSMakeRange(4, [phone length]-4)];
            return formatStr;
        }
        else
        {
            NSString *formatStr = [phone substringWithRange:NSMakeRange(3, [phone length]-3)];
            return formatStr;
        }
    }
    else if ([phone rangeOfString:@"-"].length > 0)
    {

        //1. 去除掉首尾的空白字符和换行字符
        phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //2. 去除掉其它位置的空白字符和换行字符
        phone = [phone stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"－" withString:@""];
        return phone;
    }
    return phone;
}

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


+(NSString *)carveupPhoneNum:(NSString *)phone {
    NSString *formatStr = phone;
    if ([self isMobileNumber:phone]) {
        NSRange rang = {0,3};
        NSRange rang1 = {3,4};
        NSRange rang2 = {7,4};
        formatStr = [NSString stringWithFormat:@"%@ %@ %@",[phone substringWithRange:rang],[phone substringWithRange:rang1],[phone substringWithRange:rang2]];
    }
    return formatStr;
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
