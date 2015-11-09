//
//  UserInfoSettingCell.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/31.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "UserInfoSettingCell.h"

@implementation UserInfoSettingCell

-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(ScreenWidth-96, 10, 60, 60);
    self.imageView.layer.cornerRadius = 6;
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x =20;
    self.textLabel.frame = tmpFrame;

}

@end
