//
//  MineHeadView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/12.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "MineHeadView.h"

@implementation MineHeadView


/**
 *  初始化xib页面
 *
 *  @param frame 页面位置大小
 *
 *  @return UIView
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"MineHeadView" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth, 160);
        [self addSubview:view];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, ScreenWidth, 160);
    UIImage *buttonImage = [UIImage imageNamed:@"mine_btn_bg.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
    buttonImage = [buttonImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.btn_addfriend setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.btn_infosetting setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.btn_addfriend setImage:[UIImage imageNamed:@"mine_icon_add"] forState:UIControlStateHighlighted];
    [self.btn_infosetting setImage:[UIImage imageNamed:@"mine_icon_set"] forState:UIControlStateHighlighted];
}

 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
