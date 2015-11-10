//
//  AuthorityHelper.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/10.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "AuthorityHelper.h"
#import <AddressBook/AddressBook.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation AuthorityHelper


//检测通讯录有没有访问权限
+(void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block {
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         if (error)
                                                         {
                                                             NSLog(@"Error: %@", (__bridge NSError *)error);
                                                         }
                                                         else if (!granted)
                                                         {
                                                             
                                                             block(NO);
                                                         }
                                                         else
                                                         {
                                                             block(YES);
                                                         }
                                                     });  
                                                 });  
    }
    else
    {
        block(YES);
    }
    
}

+(void)CheckMediaTypeVideoAuthorization:(void (^)(bool isAuthorized))block {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusDenied){
        block(YES);
    } else {
        block(NO);
    }
}

@end
