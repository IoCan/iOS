//
//  TestViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/14.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"测试";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn1.layer.cornerRadius = 5.0f;
    _btn2.layer.cornerRadius = 5.0f;
    UIImage *sxImg = [UIImage imageNamed:@"bg_white_sxline.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
    sxImg = [sxImg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    _bg1.image = sxImg;
    _bg2.image = sxImg;
    
    _view1.layer.borderWidth =2.0f;
    _view1.layer.backgroundColor = UIColor.whiteColor.CGColor;
    UIColor *selcolor = [UIColor colorWithRed:91/255.0
                                        green:190/255.0
                                         blue:211/255.0
                                        alpha:1.0];
    
    _view1.layer.borderColor = selcolor.CGColor;
    _view2.layer.borderWidth = 2.0f;
    _view2.layer.backgroundColor = UIColor.whiteColor.CGColor;
    _view2.layer.borderColor = selcolor.CGColor;
    _btn_change1.layer.cornerRadius = 5.0f;
    _btn_change2.layer.cornerRadius = 5.0f;
    _btn_change1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _btn_change2.titleLabel.font = [UIFont boldSystemFontOfSize:16];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
