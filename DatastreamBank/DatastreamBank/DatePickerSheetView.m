//
//  DatePickerSheetView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/2.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "DatePickerSheetView.h"
#import "UIUtils.h"
#define kDuration 0.3

@implementation DatePickerSheetView

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerSheetView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.frame = CGRectMake(0, 0, ScreenWidth, 244);
        self.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        self.label_title.text = title;
        self.isShow = NO;
        self.datePicker.maximumDate = [NSDate date];
        self.selectedDate = [UIUtils stringFromFomate:self.datePicker.date formate:@"yyyy-MM-dd"];
        [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)dateChanged:(id)sender{
    UIDatePicker * control = (UIDatePicker*)sender;
    self.selectedDate = [UIUtils stringFromFomate:control.date formate:@"yyyy-MM-dd"];
}

- (void)showInView:(UIView *) view {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDPickerSheetView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.isShow = YES;
    [view addSubview:self];
}

-(void)removeView {
    self.isShow = NO;
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"DatePickerSheetView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
}


- (IBAction)action_cancle:(id)sender {
    self.isShow = NO;
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"LocationSheetView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (IBAction)action_ok:(id)sender {
    self.isShow = NO;
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"LocationSheetView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
}


@end
