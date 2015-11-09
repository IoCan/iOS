//
//  FlowInfo.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/6.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowInfo : NSObject

@property(nonatomic,copy) NSString *title;
@property(nonatomic)    float progress;
@property(nonatomic) float used;
@property(nonatomic) float left;

@end
