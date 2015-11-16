//
//  InviteFriendsViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/20.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
#import "InviteFriendsHeadView.h"

@interface InviteFriendsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,HeadViewClickDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
