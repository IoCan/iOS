//
//  InviteFriendsHeadView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/15.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "InviteFriendsHeadView.h"
#import "NSString+Phone.h"
#import "BaseViewController.h"

@implementation InviteFriendsHeadView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsHeadView" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth, 60);
        [self addSubview:view];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, ScreenWidth, 60);
    _bg_view.layer.borderColor = RGBA(229, 229, 229, 1.0).CGColor;
    _bg_view.layer.borderWidth = 0.8f;
    _bg_view.layer.cornerRadius = _bg_view.height/2;
    _bg_view.clipsToBounds = YES;
    _txt_phone.delegate = self;
    //根据号码查询注册信息 fdapplyfor.do
    //参数 mobile password fdmobile
    
    //申请添加好友 fdapplyforsure.do
    //参数 mobile password fdmobile remark fdmsg

}

#pragma mark - UITextField代理
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([@"\n" isEqualToString:string] == YES) {
        [_txt_phone resignFirstResponder];
        return YES;
    }
    if ([_txt_phone isEqual:textField]) {
        if (string.length>0 && ![NSString isPureInt:string]) {
            return NO;
        }
        NSString *text = textField.text;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        
    }
    return YES;
}


- (IBAction)action_add:(id)sender {
    [_txt_phone resignFirstResponder];
    NSString *str = _txt_phone.text;
    if ([NSString isMobileNumber:str]) {
        [self.delegate click:str];
    } else {
        [(BaseViewController *)self.viewController toast:self cotent:@"您输入的手机号格式不正确!"];
    }

}
@end
