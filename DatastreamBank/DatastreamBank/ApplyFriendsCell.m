//
//  ApplyFriendsCell.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "ApplyFriendsCell.h"

@implementation ApplyFriendsCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"ApplyFriendsCell" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth, 101);
        [self addSubview:view];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.img_head.layer.cornerRadius = 25;
    self.img_head.clipsToBounds = YES;
    [self.btn_add addTarget:self action:@selector(action_add:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)setBtnStatus:(NSString *)status {
    if ([@"N" isEqualToString:status]) {
        self.btn_add.enabled = YES;
        [self.btn_add setTitle:@"添加" forState:UIControlStateNormal];
        self.btn_add.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.btn_add.layer.borderWidth = 1.0f;
        self.btn_add.layer.cornerRadius = 4.0f;
        self.clipsToBounds = YES;
    } else if([@"R" isEqualToString:status]) {
        self.btn_add.enabled = NO;
        [self.btn_add setTitle:@"已添加" forState:UIControlStateNormal];
    } else if([@"A" isEqualToString:status]) {
        self.btn_add.enabled = NO;
        [self.btn_add setTitle:@"已忽略" forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)action_add:(id)sender {
    [self.delegate click:self.indexPath];
}
@end
