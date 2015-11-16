//
//  MsgInfo.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/11.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgInfo : NSObject

@property(nonatomic,assign) int infoid;
@property(nonatomic,assign) int msgId; //
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *type;//消息类型（标示系统消息，备胎消息）
@property(nonatomic,strong) NSString *sType; //子消息类型
@property(nonatomic,strong) NSString *createTime; //
@property(nonatomic,strong) NSString *msgStatus;//消息状态（“N”未读，“Y”已读，“D”删除）
@property(nonatomic,strong) NSString *fdStatus;//好友状态（“N”未同意，“R”已同意，“A”已忽略）


@end
