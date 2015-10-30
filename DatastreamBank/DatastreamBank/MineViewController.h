//
//  MineViewController.h
//  DatastreamBank
//  我的模块
//  Created by OsnDroid on 15/9/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MineHeadView.h"

@interface MineViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

//@property (nonatomic,strong) MBProgressHUD *toast;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *data;//数据源

@property (strong, nonatomic) MineHeadView *tableHeadView;



@end
