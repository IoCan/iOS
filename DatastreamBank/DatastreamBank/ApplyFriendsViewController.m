//
//  ApplyFriendsViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "ApplyFriendsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Phone.h"

@interface ApplyFriendsViewController ()

@property(nonatomic,strong) AFHTTPRequestOperation *operation;

@end

@implementation ApplyFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"好友申请";
        _isAdd = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //申请添加好友 fdapplyforsure.do
    //参数 mobile password fdmobile remark fdmsg
    if (_isAdd) {//是添加好友
        self.title = @"添加好友";
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        [self loaddata];
    }
}

#pragma mark - 加载数据
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
    self.operation = [manager POST:[BaseUrlString stringByAppendingString:@"queryfdapplyfor.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSString *result = [responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"00"]) {
            NSArray *array = [responseObject objectForKey:@"resultList"];
            self.data = [[NSMutableArray alloc] initWithArray:array];
            [self.tableView reloadData];
            
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
    static NSString *identify = @"ApplyFriendsCell";
    ApplyFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ApplyFriendsCell alloc] initWithFrame:CGRectZero];
    }
    NSDictionary *item = self.data[indexPath.row];
    NSString *nickname = [item objectForKey:@"nickname"];
    NSString *fdheadpath = [item objectForKey:@"fdheadpath"];
    NSDictionary *fdapplyfor = [item objectForKey:@"fdapplyfor"];
    NSURL *url = [NSURL URLWithString:[BaseUrlString stringByAppendingString:fdheadpath]];
    [cell.img_head setImageWithURL:url placeholderImage:[UIImage imageNamed:@"infosetting_header_default.png"]];
    cell.label_name.text = nickname;
    cell.label_phone.text = [fdapplyfor objectForKey:@"fdmobile"];
    cell.status = [fdapplyfor objectForKey:@"fdStatus"];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 101.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

#pragma mark - cell代理
-(void)click:(NSIndexPath *)indexPath{
    if (_isAdd) {
        [self fdapplyforsure:indexPath];
    } else {
        [self addFriend:indexPath];
    }
}

#pragma mark － 发起添加好友请求
-(void)addFriend:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.data[indexPath.row];
    NSDictionary *fdapplyfor = [dic objectForKey:@"fdapplyfor"];
    NSString *nickname = [dic objectForKey:@"nickname"];
    NSString *fdmobile = [fdapplyfor objectForKey:@"fdmobile"];
    NSString *remark = [fdapplyfor objectForKey:@"remark"];
    nickname = [NSString isBlankString:nickname]?remark:nickname;
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在添加";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                                 ican_password:[UserInfoManager readObjectByKey:ican_password],
                                 @"fdmobile":fdmobile,
                                 @"remark":nickname};
    self.operation = [manager POST:[BaseUrlString stringByAppendingString:@"friendadd.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"00"]) {
            [self toastsucess:self.view cotent:@"添加成功"];
            NSMutableDictionary *mutableItem = [[NSMutableDictionary alloc] initWithDictionary:dic];
            NSMutableDictionary *mutablesm = [[NSMutableDictionary alloc] initWithDictionary:fdapplyfor];
            
            [mutablesm setValue:@"R" forKey:@"fdStatus"];
            [mutableItem setValue:mutablesm forKey:@"fdapplyfor"];
            [self.data setObject: mutableItem atIndexedSubscript:indexPath.row];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
            
        } else {
            [self alert:@"提示信息" msg:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",(long)error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示信息" msg:param];
    }];

}

#pragma mark － 申请添加好友
-(void)fdapplyforsure:(NSIndexPath *)indexPath{
    //申请添加好友 fdapplyforsure.do
    //参数 mobile password fdmobile remark fdmsg
    NSDictionary *dic = self.data[indexPath.row];
    NSDictionary *fdapplyfor = [dic objectForKey:@"fdapplyfor"];
    NSString *nickname = [dic objectForKey:@"nickname"];
    NSString *fdmobile = [fdapplyfor objectForKey:@"fdmobile"];
    NSString *remark = [fdapplyfor objectForKey:@"remark"];
    nickname = [NSString isBlankString:nickname]?remark:nickname;
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在添加";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                                 ican_password:[UserInfoManager readObjectByKey:ican_password],
                                 @"fdmobile":fdmobile,
                                 @"remark":nickname,
                                 @"fdmsg":@""};
    self.operation = [manager POST:[BaseUrlString stringByAppendingString:@"fdapplyforsure.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSLog(@"%@",responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"00"]) {
            
            
        } else {
            [self alert:@"提示信息" msg:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",(long)error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示信息" msg:param];
    }];
    
}

#pragma mark - 生命周期
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    if(self.operation) {
        [self.operation cancel];
    }
    
}


@end
