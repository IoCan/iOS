//
//  FriendsHeadView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/19.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "FriendsHeadView.h"
#import "InviteFriendsViewController.h"

@implementation FriendsHeadView

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
//       UIView *view = [UINib nibWithNibName:@"MessageCell" bundle:nil][0];
        
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"FriendsHeadView" owner:self options:nil][0];
        [self addSubview:view];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
     self.frame = CGRectMake(0, 0, ScreenWidth, 140);
    _btn_head.layer.cornerRadius = _btn_head.frame.size.width/2;
    _btn_head.clipsToBounds = YES;
}

- (IBAction)action_add:(id)sender {
    UIViewController *uvCtrl  = (UIViewController *)[self.superview.superview.superview nextResponder];
    InviteFriendsViewController *ifCtrl = [[InviteFriendsViewController alloc] init];
    [uvCtrl.navigationController pushViewController:ifCtrl animated:YES];
}
@end
