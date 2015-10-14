//
//  FeedbackViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/12.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"意见反馈";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWhiteNav];
    _utv_content.delegate = self;
    _utv_content.textColor = [UIColor lightGrayColor];
    _utv_content.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _utv_content.layer.borderWidth = 0.4;
    _utv_content.layer.cornerRadius = 6;
    _utv_content.layer.masksToBounds = YES;
    _btn_submit.layer.cornerRadius = 6;
    _view_bg.layer.borderWidth = 0.4;
    _view_bg.layer.borderColor = UIColor.lightGrayColor.CGColor;
//    UIImage *btnImg = [UIImage imageNamed:@"btn_submit.png"];
//     UIEdgeInsets insets = UIEdgeInsetsMake(14, 14, 14, 14);
//    btnImg = [btnImg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//    [_btn_submit setBackgroundImage:btnImg forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    MyLog(@"提交反馈内容",nil);
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _utv_content.text=@"";
    _utv_content.textColor = [UIColor blackColor];
    return YES;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
