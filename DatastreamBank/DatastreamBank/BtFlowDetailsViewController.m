//
//  BtFlowDetailsViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/26.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BtFlowDetailsViewController.h"
#import "BtFlowDetailsCell.h"
#import "AFHTTPRequestOperationManager.h"

@interface BtFlowDetailsViewController ()

@property(nonatomic,strong) AFHTTPRequestOperation *operation;

@end

@implementation BtFlowDetailsViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"备胎流量详情";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"未找到记录";
    label.textColor = [UIColor lightGrayColor];
    label.tag = 10;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(ScreenWidth/2-100, _tableView.height/2-20, 200, 40);
    label.hidden = YES;
    [_tableView addSubview:label];
    [self loaddata];
}

-(void)loaddata {
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在加载";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                                 ican_password:[UserInfoManager readObjectByKey:ican_password]};
    self.operation = [manager POST:[BaseUrlString stringByAppendingString:@"orderquery.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
//        MyLog(@"%@",responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"00"]) {
            NSArray *array = [responseObject objectForKey:@"resultList"];
            NSMutableArray *marray = [[NSMutableArray alloc] initWithArray:array];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ = %d", @"price", 0];
            self.data = [marray filteredArrayUsingPredicate:predicate];
            if (self.data.count == 0) {
                [_tableView viewWithTag:10].hidden = NO;
            } else {
                [self.tableView reloadData];
            }
            
        } else {
            NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
            [self alert:@"提示信息" msg:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",(long)error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示信息" msg:param];
    }];
}



#pragma mark -数据源方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"BtFlowDetailsCell";
    BtFlowDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[BtFlowDetailsCell alloc] initWithFrame:CGRectZero];
    }
    if (indexPath.row % 2 == 0) {
        [cell.img_icon setImage:[UIImage imageNamed:@"icon_btxq_1"]];

    } else {
        [cell.img_icon setImage:[UIImage imageNamed:@"icon_btxq_2"]];

    }
    NSDictionary *dic = [_data objectAtIndex:indexPath.row];
    cell.label_flow.text = [NSString stringWithFormat:@"流量额度：%@M",[dic objectForKey:@"flowchange"]];
    cell.state = [dic objectForKey:@"content"];
    cell.label_date.text  = [NSString stringWithFormat:@"操作时间：%@",[dic objectForKey:@"createTime"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 114.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
