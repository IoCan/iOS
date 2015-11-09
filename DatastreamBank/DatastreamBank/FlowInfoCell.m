//
//  FlowInfoCell.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/6.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "FlowInfoCell.h"

@implementation FlowInfoCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"FlowInfoCell" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth, 141);
        [self addSubview:view];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _progressView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _progressView.layer.borderWidth = 0.8f;
    _progressView.layer.cornerRadius = 10;
    _progressView.clipsToBounds = YES;
    _bg_view.layer.borderColor = RGBA(82, 93, 173, 1.0).CGColor;
    _bg_view.layer.borderWidth = 1.2f;
    _bg_view.layer.cornerRadius = 10;
    _bg_view.clipsToBounds = YES;

    if (_initProgress > 0.7) {
        _progressView.progressTintColor = RGBA(238, 129, 100, 1.0);
    }
    [_progressView setProgress:_initProgress];
    if (_initProgress == 0) {
        _label_pre.text = @"0%";
        [_label_pre setLeft:(_progressView.center.x-_label_pre.width/2)];
    } else {
        if (_initProgress < 0.009999) {
             //小于1%的百分比精确度显示，最多精确万分之一
            NSLog(@"%f====%f",_initProgress,0.009999);
             _label_pre.text = [NSString stringWithFormat:@"%0.1f‰",_initProgress *1000];
        } else {
             _label_pre.text = [NSString stringWithFormat:@"%0.0f%%",_initProgress *100];
        }
        CGFloat p_p = _progressView.width * _initProgress;//进度的长度
        CGFloat offx = 0.0f;
        if (p_p > _label_pre.width) {//如果进度超过百分比宽度
            offx = (p_p-_label_pre.width);
            _label_pre.textColor = [UIColor whiteColor];
        } else {
            offx = p_p;
        }
        [_label_pre setLeft:offx];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
