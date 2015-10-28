//
//  HomeProgress2View.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/28.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "HomeProgress2View.h"

@implementation HomeProgress2View

/**
 *  初始化xib页面
 *
 *  @param frame 页面位置大小
 *
 *  @return UIView
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"HomeProgress2View" owner:self options:nil][0];
        view.frame = frame;
        self.frame = frame;
        [self addSubview:view];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
 
}

@end
