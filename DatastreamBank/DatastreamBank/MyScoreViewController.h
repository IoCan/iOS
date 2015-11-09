//
//  MyScoreViewController.h
//  DatastreamBank
//  我的模块－我的积分
//  Created by OsnDroid on 15/10/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImageView+WebCache.h"

@interface MyScoreViewController : BaseViewController<UIAlertViewDelegate>
//{
//@private
//    UIScrollView *scrollView;
//}
@property (strong, nonatomic) IBOutlet UIImageView *img_userhead;
@property (strong, nonatomic) IBOutlet UILabel *label_userphone;
@property (strong, nonatomic) IBOutlet UILabel *label_userscore;
@property (strong, nonatomic) IBOutlet UIButton *btn_takescore;
@property (strong, nonatomic) IBOutlet UIButton *btn_scorerule;


@property (strong, nonatomic) IBOutlet UIImageView *img_change;
@property (strong, nonatomic) IBOutlet UIImageView *img_changerule;

@property (strong, nonatomic) IBOutlet UIView *view_changebg1;
@property (strong, nonatomic) IBOutlet UIView *view_changebg2;

@property (strong, nonatomic) IBOutlet UIButton *btn_change1;
@property (strong, nonatomic) IBOutlet UIButton *btn_change2;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *view_allbg;

- (IBAction)actionChange1:(id)sender;
- (IBAction)actionChange2:(id)sender;

- (IBAction)actionTake:(id)sender;

- (IBAction)actionRule:(id)sender;



@end
