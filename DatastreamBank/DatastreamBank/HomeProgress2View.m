//
//  HomeProgress2View.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/28.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "HomeProgress2View.h"
#import "BtAcountViewController.h"

@implementation HomeProgress2View

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"HomeProgress2View" owner:self options:nil][0];
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
    
    self.progress.imgName = @"zhizhen3.png";
    self.progress.progressColor = RGBA(54, 246, 226, 0.3);
    
    self.progress.lineWidth = 30;
    [self setFlow:_initfow];
 
    self.progress.progress = 1.0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo:)];
    tapGesture.delegate = self;
    [_view3 addGestureRecognizer:tapGesture];
    [_view1 addGestureRecognizer:tapGesture];
    [_view2 addGestureRecognizer:tapGesture];
    [_label_flow addGestureRecognizer:tapGesture];
}

-(void)Actiondo:(UITapGestureRecognizer *)sender{
    BtAcountViewController *acountCtrl = [[BtAcountViewController alloc] init];
    [self.viewController.navigationController pushViewController:acountCtrl animated:YES];
}

-(void)setFlow:(NSInteger) flow {
    NSString *tmp = [NSString stringWithFormat:@"%ldMB",flow];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tmp];
    NSInteger start = tmp.length - 2;
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:14.0] range:NSMakeRange(start,2)];
    _label_flow.attributedText = str;

}

@end
