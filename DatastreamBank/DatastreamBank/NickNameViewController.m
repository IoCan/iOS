//
//  NickNameViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/2.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "NickNameViewController.h"
#import "NSString+Phone.h"

@interface NickNameViewController ()

@end

@implementation NickNameViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"昵称";
    }
    return self;
}

- (void)viewDidLoad {
    self.isCancelButton = YES;
    [super viewDidLoad];
    _txt_nicename.text = _titleStr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)okAction {
    [_txt_nicename resignFirstResponder];
    NSString *name = _txt_nicename.text;
    if ([NSString isBlankString:name]) {
        [self toast:self.view cotent:@"昵称不能为空"];
        return;
    }
    if (name.length > 12) {
        [self toast:self.view cotent:@"昵称最多只能12个文字"];
        return;
    }
    if (self.delegate) {
        [self.delegate nickname:_txt_nicename.text];
    }
    [super okAction];
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
