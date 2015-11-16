//
//  PresentFriendsViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/15.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
#import "PresentFriendsHeadView.h"

@interface PresentFriendsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,HeadViewClickDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btn_present;
@property (strong, nonatomic) IBOutlet UIButton *btn_rule;
- (IBAction)action_present:(id)sender;
- (IBAction)action_rule:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *data;

@property (nonatomic, strong) NSArray *filtereddata;

@end
