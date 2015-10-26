//
//  BtAcountHeadView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/25.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BtAcountHeadView.h"

@implementation BtAcountHeadView

- (void)awakeFromNib {
    // Initialization code
}


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
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"BtAcountHeadView" owner:self options:nil][0];
        view.frame = CGRectMake(0, 0, ScreenWidth, 100);
//        self.frame =  CGRectMake(0, 0, ScreenWidth, 100);
        [self addSubview:view];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _btn_header.layer.cornerRadius = _btn_header.frame.size.width/2;
    _btn_header.clipsToBounds = YES;
 
}


@end
