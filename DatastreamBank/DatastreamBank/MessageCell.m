//
//  MessageCell.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/17.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}





-(void)layoutSubviews {
    [super layoutSubviews];
    _btn_state.layer.borderColor = RGBA(209, 209, 209, 1).CGColor;
    _btn_state.layer.backgroundColor = RGBA(209, 209, 209, 1).CGColor;
    _btn_state.layer.borderWidth = 2.0f;
    _btn_state.layer.cornerRadius = 5.0f;
    _btn_state.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _btn_state.enabled = NO;
    _btn_state.clipsToBounds = YES;
   
//    _label_state.textColor = [UIColor redColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
