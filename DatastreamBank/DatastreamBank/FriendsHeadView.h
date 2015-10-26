//
//  FriendsHeadView.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/19.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsHeadView : UIView


@property (strong, nonatomic) IBOutlet UIButton *btn_head;

@property (strong, nonatomic) IBOutlet UILabel *label_userphone;

@property (strong, nonatomic) IBOutlet UILabel *label_balance;

@property (strong, nonatomic) IBOutlet UILabel *label_count;

@property (strong, nonatomic) IBOutlet UIButton *btn_add;

- (IBAction)action_add:(id)sender;

@end
