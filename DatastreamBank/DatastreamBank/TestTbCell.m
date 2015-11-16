//
//  TestTbCell.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/12.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "TestTbCell.h"

@implementation TestTbCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"TestTbCell" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth, 89);
        [self addSubview:view];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)action_ok:(id)sender {
    MyLog(@"------");
}
@end
