//
//  IoContactCell.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/14.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "IoContactCell.h"
#import "NSString+Phone.h"

@implementation IoContactCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"IoContactCell" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth, 67);
        [self addSubview:view];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.img_head.layer.cornerRadius = 20;
    self.img_head.clipsToBounds = YES;
    self.btn_add.layer.cornerRadius = 4.0f;
    self.btn_add.clipsToBounds = YES;
    [self.btn_add addTarget:self action:@selector(action_add:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)action_add:(id)sender {
    [self.delegate click:self.indexPath];
}

-(void)setPhone:(NSString *)phone {
    NSString *tmp = [NSString formatPhoneNum:phone];
    self.label_phone.text = tmp;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
