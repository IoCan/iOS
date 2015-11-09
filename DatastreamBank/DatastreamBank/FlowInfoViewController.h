//
//  FlowInfoViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/6.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"

@interface FlowInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;

@end
