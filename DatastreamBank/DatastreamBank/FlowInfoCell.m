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
        CGRect f = _label_pre.frame;
        f.origin.x = _progressView.center.x-_label_pre.width/2;
        _label_pre.text = @"0%";
        _label_pre.frame = f;
        _label_pre.textColor = [UIColor grayColor];
        
    } else {
        if (_initProgress < 0.0099999999) {
             //小于1%的百分比精确度显示，最多精确万分之一
             _label_pre.text = [NSString stringWithFormat:@"%0.1f‰",_initProgress *1000];
        } else {
             _label_pre.text = [NSString stringWithFormat:@"%0.0f%%",_initProgress *100];
        }
        CGFloat p_width = _progressView.width;
        CGFloat p_p = p_width * _initProgress;//进度的长度
        if (p_p > _label_pre.width) {//如果进度超过百分比宽度
            CGRect f = _label_pre.frame;
            f.origin.x = (p_p-_label_pre.width);
            _label_pre.textColor = [UIColor whiteColor];
            _label_pre.frame = f;
        } else {
            CGRect f = _label_pre.frame;
            f.origin.x = p_p;
            _label_pre.textColor = [UIColor grayColor];
            _label_pre.frame = f;
        }
    }
    

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
