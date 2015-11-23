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


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth, 112);
        [self addSubview:view];
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0, 0, ScreenWidth, 112);
    _label_state.layer.borderColor = RGBA(209, 209, 209, 1).CGColor;
    _label_state.layer.backgroundColor = RGBA(209, 209, 209, 1).CGColor;
    _label_state.layer.borderWidth = 2.0f;
    _label_state.layer.cornerRadius = 5.0f;
    _label_state.clipsToBounds = YES;
}



-(void)setState:(NSString *)state {
    if ([state isEqualToString:@"N"]) {
        _label_state.textColor = [UIColor redColor];
        _label_state.text = @"未读";
    }else if ([state isEqualToString:@"Y"]) {
        _label_state.text = @"已读";
        _label_state.textColor = [UIColor whiteColor];
    }else if ([state isEqualToString:@"D"]) {
        _label_state.text = @"已删除";
        _label_state.textColor = [UIColor whiteColor];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
