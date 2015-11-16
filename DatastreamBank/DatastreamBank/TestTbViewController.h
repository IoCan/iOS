//
//  TestTbViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/12.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"

@interface TestTbViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
