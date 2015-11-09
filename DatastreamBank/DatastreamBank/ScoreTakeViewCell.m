//
//  ScoreTakeViewCell.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/14.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "ScoreTakeViewCell.h"

@implementation ScoreTakeViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"ScoreTakeViewCell" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth, 101);
        [self addSubview:view];
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.width = ScreenWidth;
    self.contentView.height = 100;
    _view_bg.backgroundColor = [UIColor whiteColor];
    _view_bg.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _view_bg.layer.borderWidth = 0.4;
    _view_bg.layer.cornerRadius = 6;
    _view_bg.layer.masksToBounds = YES;
}


//-(void)setSelected:(BOOL)selected {
//    if (selected) {
//        _view_bg.backgroundColor = [UIColor lightGrayColor];
//        
//    } else {
//        _view_bg.backgroundColor = [UIColor whiteColor];
//    }
//    
//}
//
//-(void)setHighlighted:(BOOL)highlighted {
//    if (highlighted) {
//        _view_bg.backgroundColor = [UIColor lightGrayColor];
//        
//    } else {
//        _view_bg.backgroundColor = [UIColor whiteColor];
//    }
//    
//}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
