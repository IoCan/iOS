//
//  CALayer+RuntimeAttribute.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/15.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

@import QuartzCore;

@interface CALayer (IBConfiguration)

@property(nonatomic, assign) UIColor* borderIBColor;
@property(nonatomic, assign) UIColor* shadowIBColor;

@end