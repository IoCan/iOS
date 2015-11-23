//
//  MyOrderViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderCell.h"
#import "AFHTTPRequestOperationManager.h"

@interface MyOrderViewController ()

@property(nonatomic,strong) AFHTTPRequestOperation *operation;

@end

@implementation MyOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的订单";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"您还没有订单记录";
    label.textColor = [UIColor lightGrayColor];
    label.tag = 10;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(ScreenWidth/2-100, ScreenHeight/2-52, 200, 40);
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
        NSString *result = [responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"00"]) {
            NSArray *array = [responseObject objectForKey:@"resultList"];
            NSMutableArray *marray = [[NSMutableArray alloc] initWithArray:array];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ > %d", @"price", 0];
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

//    [manager cancelAllHTTPOperationsWithMethod:@"POST" path:@"product/like"];
}

#pragma mark -数据源方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"MyOrderCell";
    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[MyOrderCell alloc] initWithFrame:CGRectZero];
    }
  
   
     NSDictionary *item = self.data[indexPath.row];
     NSString *type = [item objectForKey:@"content"];
    if ([type containsString:@"退订"]) {
        [cell.img_icon setImage:[UIImage imageNamed:@"icon_dd_2"]];
    } else {
        [cell.img_icon setImage:[UIImage imageNamed:@"icon_dd_1"]];
    }
    NSInteger flowchange = [[item objectForKey:@"flowchange"] integerValue];
    NSInteger price = [[item objectForKey:@"price"] integerValue];
    NSString *createTime = [item objectForKey:@"createTime"];
    cell.label_flow.text = [NSString stringWithFormat:@"备胎流量状态：%ldM",flowchange];
    cell.label_time.text = [@"完成时间：" stringByAppendingString:createTime];
    cell.label_price.text = [NSString stringWithFormat:@"价格：%ld元",price];
    cell.label_type.text = [@"流量操作：" stringByAppendingString:type];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 114.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    if(self.operation) {
        [self.operation cancel];
//        self.operation = nil;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
