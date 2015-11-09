//
//  FlowInfoViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/6.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "FlowInfoViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "FlowInfoCell.h"
#import "BtFlowDetailsCell.h"
#import "FlowInfo.h"

@interface FlowInfoViewController ()

@end

@implementation FlowInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"套内流量详情";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self loadData];
}



#pragma mark -数据源方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"FlowInfoCell";
    FlowInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[FlowInfoCell alloc] initWithFrame:CGRectZero];
    }
    FlowInfo *flow = [_data objectAtIndex:indexPath.row];
    cell.label_title.text = flow.title;
    cell.initProgress = flow.progress;
//    switch (indexPath.row) {
//        case 0:
//            cell.initProgress = 0.01;
//            break;
//        case 1:
//            cell.initProgress = 0.2;
//            break;
//        case 2:
//            cell.initProgress = 0.8;
//            break;
//        case 3:
//            cell.initProgress = 0.0003;
//            break;
//        default:
//            break;
//    }
    NSString *left = [NSString stringWithFormat:@"%0.1f",flow.left];
    NSString *used = [NSString stringWithFormat:@"%0.1f",flow.used];
    NSString *param = [NSString stringWithFormat:@"已用%@MB,剩余%@MB",used,left];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:param];
    [str addAttribute:NSForegroundColorAttributeName value:RGBA(238, 129, 100, 1.0) range:NSMakeRange(2,used.length)];
    NSRange range = [param rangeOfString:@"剩余"];
    [str addAttribute:NSForegroundColorAttributeName value:RGBA(238, 129, 100, 1.0) range:NSMakeRange(range.location+2,left.length)];
    cell.label_desc.attributedText = str;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 141.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}

-(void)loadData {

    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在查询";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSDictionary *parameters = @{ican_mobile:mobile,
                                 ican_password:password,
                                 @"searchtime":@""};
    [manager POST:[BaseUrlString stringByAppendingString:@"flowquery.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
//        MyLog(@"%@",responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"0"]) {
           NSMutableArray *array = [responseObject objectForKey:@"CumUlationResp"];
            _data = [[NSMutableArray alloc] init];
            for (int i=0; i < array.count; i++) {
                NSMutableDictionary *item = [array objectAtIndex:i];
                FlowInfo *flow = [[FlowInfo alloc] init];
                flow.title = [item objectForKey:@"offerName"];
                float left = [[item objectForKey:@"cumulationLeft"] floatValue];
                float used = [[item objectForKey:@"cumulationAlready"] floatValue];
                float all = [[item objectForKey:@"cumulationTotal"] floatValue];
                flow.left = left/1024;
                flow.used = used/1024;
                flow.progress = [[NSString stringWithFormat:@"%0.2f",used/all] floatValue];
                [_data addObject:flow];
            }
            [self.tableView reloadData];
        } else {
           [self alert:@"提示" msg:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示" msg:param];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
