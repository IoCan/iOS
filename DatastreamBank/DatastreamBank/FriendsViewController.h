//
//  FriendsViewController.h
//  DatastreamBank
//  朋友圈
//  Created by OsnDroid on 15/9/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FriendsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

//赠送
@property (strong, nonatomic) IBOutlet UIButton *btn_present;
//索要
@property (strong, nonatomic) IBOutlet UIButton *btn_demand;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
