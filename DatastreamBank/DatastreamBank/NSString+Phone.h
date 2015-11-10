//
//  NSString+Phone.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/29.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Phone)


+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)isSixCodeNumber:(NSString *)num;

+ (BOOL)isBlankString:(NSString *)string;

+ (NSString *)formatPhoneNum:(NSString *)phone;
@end
