//
//  MessageInfo.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/11.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgInfo.h"

@interface MessageInfo : NSObject

@property(nonatomic,strong) NSString * fdStatus;
@property(nonatomic,strong) NSString * fdmobile;
@property(nonatomic,strong) MsgInfo * msgInfo;
@property(nonatomic,strong) NSString * changeflow;
@property(nonatomic,strong) NSString * interact;

@end
