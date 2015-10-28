//
//  HomeProgressView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/28.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "HomeProgressView.h"

@implementation HomeProgressView

/**
 *  初始化xib页面
 *
 *  @param frame 页面位置大小
 *
 *  @return UIView
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"HomeProgessView" owner:self options:nil][0];
        view.frame = frame;
        self.frame = frame;
        [self addSubview:view];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    _view1.layer.cornerRadius = _view1.width/2;
    
    
    _view1.layer.shadowColor = [UIColor whiteColor].CGColor;
    _view1.layer.shadowOffset = CGSizeMake(10, 10);
    _view1.layer.shadowOpacity = 0.3;
    _view1.layer.shadowRadius = _view1.width/2+50;
    _view1.clipsToBounds = YES;
    
    
    
    _view2.layer.cornerRadius = _view2.width/2;
    //
    //    _view2.layer.shadowColor = [UIColor whiteColor].CGColor;
    //    _view2.layer.shadowOffset = CGSizeMake(10, 10);
    //    _view2.layer.shadowOpacity = 0.3;
    //    _view2.layer.shadowRadius = _view1.width/2+50;
    _view2.clipsToBounds = YES;
    
    
    _view3.layer.cornerRadius = _view3.width/2;
    _view3.layer.shadowColor = [UIColor redColor].CGColor;
    _view3.layer.shadowOffset = CGSizeMake(50, 50);
    _view3.clipsToBounds = YES;
    
    self.progress.progressColor = RGBA(54, 246, 226, 0.3);
    
    self.progress.lineWidth = 30;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"438MB"];
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];

    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:14.0] range:NSMakeRange(3,2)];
//    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    _label_flow.attributedText = str;
    
    
    //set CircularProgressView delegate
    self.progress.progress = 0.7;
}
@end
