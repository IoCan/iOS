//
//  BenefitsCell.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BenefitsCell.h"

@implementation BenefitsCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"BenefitsCell" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth/2, 100);
        [self addSubview:view];
        
    }
    return self;
}



-(void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame =CGRectMake(0, 0, ScreenWidth/2, 100);
    _view_content.layer.borderColor = RGBA(91, 190, 211, 1.0).CGColor;
    _view_content.layer.borderWidth = 2;
    _view_content.layer.cornerRadius = 6;
//    _view_content.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _view_content.clipsToBounds = YES;
    UIImage *image = [UIImage imageNamed:@"item_benefit_top.png"];
//    UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
//    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
   [_img_topbg setImage:[image stretchableImageWithLeftCapWidth:6 topCapHeight:6]];
//    [_img_topbg setImage:image];
}

-(void)setSelected:(BOOL)selected {
    if (selected) {
        _view_content.backgroundColor = RGBA(246, 246, 246, 1.0);
        
    } else {
       _view_content.backgroundColor = [UIColor whiteColor];
    }
    
}

-(void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        _view_content.backgroundColor = RGBA(246, 246, 246, 1.0);
        
    } else {
        _view_content.backgroundColor = [UIColor whiteColor];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

@end
