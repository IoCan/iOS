//
//  BenefitsFootView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BenefitsFootView.h"

@implementation BenefitsFootView

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
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"BenefitsFootView" owner:self options:nil][0];
        view.frame = CGRectMake(0, 0, ScreenWidth, 140);
        [self addSubview:view];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    _view1.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _view1.layer.borderWidth = 0.4;
    _view1.layer.cornerRadius = 6;
    _view1.layer.masksToBounds = YES;
    
    _view2.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _view2.layer.borderWidth = 0.4;
    _view2.layer.cornerRadius = 6;
    _view2.layer.masksToBounds = YES;
}


 



@end
