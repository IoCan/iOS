//
//  BtAcountCell.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/25.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BtAcountCell.h"

@implementation BtAcountCell



- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"BtAcountCell" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth/2, 100);
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

@end
