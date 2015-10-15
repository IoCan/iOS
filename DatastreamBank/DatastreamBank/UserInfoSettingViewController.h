//
//  UserInfoSettingViewController.h
//  DatastreamBank
//  我的模块－个人资料设置
//  Created by OsnDroid on 15/10/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"

@interface UserInfoSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *data;//数据源

@end
