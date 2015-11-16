//
//  BenefitsFootView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BenefitsFootView.h"
#import "BtAcountViewController.h"

@implementation BenefitsFootView

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
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"BenefitsFootView" owner:self options:nil][0];
        view.frame = CGRectMake(0, 0, ScreenWidth, 140);
        [self addSubview:view];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    _view1.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _view1.layer.borderWidth = 0.4;
    _view1.layer.cornerRadius = 6;
    _view1.layer.masksToBounds = YES;

    _view2.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _view2.layer.borderWidth = 0.4;
    _view2.layer.cornerRadius = 6;
    _view2.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo:)];
    tapGesture.delegate = self;
    [_view1 addGestureRecognizer:tapGesture];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo:)];
    tapGesture2.delegate = self;
    [_view2 addGestureRecognizer:tapGesture2];
}

-(void)Actiondo:(UITapGestureRecognizer *)sender{
    sender.view.backgroundColor = [UIColor whiteColor];
    if ([_view1 isEqual:sender.view]) {
        BtAcountViewController *btAcountViewController = [[BtAcountViewController alloc] init];
        [self.viewController.navigationController pushViewController:btAcountViewController animated:YES];
    }
    if ([_view2 isEqual:sender.view]) {
        
        if (self.obview == nil) {
            self.obview  = [[UIAlertView alloc] initWithTitle: @"⚠"
                                                      message:@"抱歉，该功能正在建设中..."
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"确定", nil];
        }
        [self.obview show];
    }
    
   
}


//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
////     gestureRecognizer.view.backgroundColor = [UIColor whiteColor];
//    return YES;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"=====shouldRequireFailureOfGestureRecognizer=====");
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"=====shouldBeRequiredToFailByGestureRecognizer=====");
//    return YES;
//}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    gestureRecognizer.view.backgroundColor = RGBA(246, 246, 246, 1.0);
    return YES;
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
////    NSLog(@"=====gestureRecognizerShouldBegin=====");
//    gestureRecognizer.view.backgroundColor = [UIColor brownColor];
//    return YES;
//}


@end
