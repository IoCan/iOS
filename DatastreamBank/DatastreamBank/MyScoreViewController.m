//
//  MyScoreViewController.m
//  DatastreamBank
//  我的模块－我的积分
//  Created by OsnDroid on 15/10/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "MyScoreViewController.h"
#import "WebViewController.h"
#import "ScoreTakeViewController.h"

@interface MyScoreViewController ()

@end

@implementation MyScoreViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的积分";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_takescore.layer.cornerRadius = 5.0f;
    _btn_scorerule.layer.cornerRadius = 5.0f;
    UIImage *sxImg = [UIImage imageNamed:@"bg_white_sxline.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
    sxImg = [sxImg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    _img_change.image = sxImg;
    _img_changerule.image = sxImg;
   
    _view_changebg1.layer.borderWidth =2.0f;
    _view_changebg1.layer.backgroundColor = UIColor.whiteColor.CGColor;
    UIColor *selcolor = [UIColor colorWithRed:91/255.0
                                        green:190/255.0
                                         blue:211/255.0
                                        alpha:1.0];
    
    _view_changebg1.layer.borderColor = selcolor.CGColor;
    _view_changebg2.layer.borderWidth = 2.0f;
    _view_changebg2.layer.backgroundColor = UIColor.whiteColor.CGColor;
    _view_changebg2.layer.borderColor = selcolor.CGColor;
    _btn_change1.layer.cornerRadius = 5.0f;
    _btn_change2.layer.cornerRadius = 5.0f;
    _btn_change1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _btn_change2.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    

}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _view_allbg.height =540;
    _scrollView.contentSize = _view_allbg.frame.size;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionTake:(id)sender {
    ScoreTakeViewController *scoreCtrl = [[ScoreTakeViewController alloc] init];
    [self.navigationController pushViewController:scoreCtrl animated:YES];
    
}

- (IBAction)actionRule:(id)sender {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"jf_rule" ofType:@"html"];
    WebViewController *webView = [[WebViewController alloc] initWithUrl:filePath];
    [self.navigationController pushViewController:webView animated:YES];
}
@end
