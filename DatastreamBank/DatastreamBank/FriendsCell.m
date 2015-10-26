//
//  FriendsCell.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/19.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "FriendsCell.h"

@implementation FriendsCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"FriendsCell" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth, 81);
        [self addSubview:view];
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.width = ScreenWidth;
    self.contentView.height = 80;
    _btn_head.layer.cornerRadius = _btn_head.frame.size.width/2;
    _btn_head.clipsToBounds = YES;
    self.selectedBackgroundView.backgroundColor = RGBA(255, 250, 246, 1.0);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
