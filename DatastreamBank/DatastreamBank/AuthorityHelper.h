//
//  AuthorityHelper.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/10.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorityHelper : NSObject


+(void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block;


+(void)CheckMediaTypeVideoAuthorization:(void (^)(bool isAuthorized))block;


@end
