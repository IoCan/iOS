//
//  AppUpdateHelper.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/12.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUpdateHelper : NSObject<UIAlertViewDelegate>

+(void)updateFromAppStore:(UIView *)view;

@end
