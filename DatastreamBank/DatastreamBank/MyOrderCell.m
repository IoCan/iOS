//
//  MyOrderCell.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"MyOrderCell" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth, 121);
        [self addSubview:view];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.width = ScreenWidth;
    self.contentView.height = 120;
    _view_bg.backgroundColor = [UIColor whiteColor];
    _view_bg.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _view_bg.layer.borderWidth = 0.4;
    _view_bg.layer.cornerRadius = 6;
    _view_bg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
