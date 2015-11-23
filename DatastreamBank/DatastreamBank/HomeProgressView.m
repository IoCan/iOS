//
//  HomeProgressView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/28.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "HomeProgressView.h"
#import "FlowInfoViewController.h"

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
    _view2.clipsToBounds = YES;
    _view3.layer.cornerRadius = _view3.width/2;
    _view3.layer.shadowColor = [UIColor redColor].CGColor;
    _view3.layer.shadowOffset = CGSizeMake(50, 50);
    _view3.clipsToBounds = YES;
    
    self.progress.imgName = @"zhizhen2.png";
    self.progress.progressColor = RGBA(54, 246, 226, 0.3);
    
    self.progress.lineWidth = 30;

    [self setFlow:_initflow];
    self.progress.progress = _initprogress;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo:)];
    tapGesture.delegate = self;
    [_view3 addGestureRecognizer:tapGesture];
    [_label_flow addGestureRecognizer:tapGesture];
    [_view1 addGestureRecognizer:tapGesture];
}

-(void)Actiondo:(UITapGestureRecognizer *)sender{
    NSString *operator = [UserInfoManager readObjectByKey:ican_operator];
    if ([operator containsString:@"电信"]) {
        FlowInfoViewController *flowCtrl = [[FlowInfoViewController alloc] init];
        [self.viewController.navigationController pushViewController:flowCtrl animated:YES];
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"目前只支持江苏电信用户流量详情查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];

    }
   
}

-(void)setFlow:(NSInteger) flow {
    NSString *tmp;
    if (flow > 1024) {
        float a = flow/1024.0f;
        tmp = [NSString stringWithFormat:@"%0.1fGB",a];
    } else {
        tmp = [NSString stringWithFormat:@"%ldMB",flow];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tmp];
    NSInteger start = tmp.length - 2;
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:14.0] range:NSMakeRange(start,2)];
    _label_flow.attributedText = str;
    
}

-(void)updateProgress:(float) progress {
    [self.progress updateProgress:progress];
}

@end
