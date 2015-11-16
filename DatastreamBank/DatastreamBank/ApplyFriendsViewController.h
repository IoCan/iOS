//
//  ApplyFriendsViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
#import "ApplyFriendsCell.h"

@interface ApplyFriendsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CellClickDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic,assign) BOOL isAdd;

@end
