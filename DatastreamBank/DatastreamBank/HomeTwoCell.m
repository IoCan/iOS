//
//  HomeTwoCell.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "HomeTwoCell.h"

@implementation HomeTwoCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"HomeTwoCell" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth/2, 90);
        [self addSubview:view];
        
    }
    return self;
}

-(void)setSelected:(BOOL)selected {
    if (selected) {
        self.backgroundView.backgroundColor = RGBA(255, 255, 241, 1.0);
        
    } else {
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }

}

-(void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        self.backgroundView.backgroundColor = RGBA(255, 255, 241, 1.0);

    } else {
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    
}



-(void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame =CGRectMake(0, 0, ScreenWidth/2, 90);

//    self.contentView.backgroundColor = [UIColor redColor];
//    _bgview.bounds = self.contentView.bounds;

//    self.contentView.backgroundColor = [UIColor redColor];
//    self.frame =  CGRectMake(0, 0, ScreenWidth/2-1, 90);
//    NSLog(@"%f---",self.frame.size.width);
}

- (void)awakeFromNib {
    // Initialization code
}

@end
