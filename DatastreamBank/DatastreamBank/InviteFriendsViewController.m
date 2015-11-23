//
//  InviteFriendsViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/20.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "IoContactViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ApplyFriendsViewController.h"

@interface InviteFriendsViewController ()

@end

@implementation InviteFriendsViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"邀请新朋友";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //根据号码查询注册信息 fdapplyfor.do
    //参数 mobile password fdmobile
    
    //申请添加好友 fdapplyforsure.do
    //参数 mobile password fdmobile remark fdmsg
    InviteFriendsHeadView *headView = [[InviteFriendsHeadView alloc] init];
    headView.delegate = self;
    _tableView.tableHeaderView = headView;
    
}


#pragma mark -数据源方法
//这个方法用来告诉表格有几个分组
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//这个方法告诉表格第section个分段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//这个方法用来告诉某个分组的某一行是什么数据，返回一个UITableViewCel
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *groupedTableIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:groupedTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:groupedTableIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"icon_yqpy_1"];
    cell.textLabel.text = @"添加手机联系人";
    cell.textLabel.textColor = RGBA(91, 190, 212, 1.0);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark -代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中高亮
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    IoContactViewController *iCtrl = [[IoContactViewController alloc] init];
    iCtrl.isAdd = YES;
    [self.navigationController pushViewController:iCtrl animated:YES];
}


#pragma mark - 实现顶部代理
-(void)click:(NSString *)param {
    [self fdapplyfor:param];
}

#pragma mark - 查询用户信息
-(void)fdapplyfor:(NSString *)fdmobile {
    if ([fdmobile isEqualToString:[UserInfoManager readObjectByKey:ican_mobile]]) {
        [self alert:@"提示" msg:@"不能添加自己为好友"];
        return;
    }
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在查询";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    //根据号码查询注册信息 fdapplyfor.do
    //参数 mobile password fdmobile

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSDictionary *parameters = @{ican_mobile:mobile,
                                 ican_password:password,
                                 @"fdmobile":fdmobile
                                 };
    [manager POST:[BaseUrlString stringByAppendingString:@"fdapplyfor.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        MyLog(@"%@",responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"00"]) {
            ApplyFriendsViewController *aCtrl = [[ApplyFriendsViewController alloc] init];
            aCtrl.isAdd = YES;
            NSString *fdmobile = [responseObject objectForKey:@"fdmobile"];
            NSString *headpath = [responseObject objectForKey:@"headpath"];
            NSString *nickname = [responseObject objectForKey:@"nickname"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:nickname forKey:@"nickname"];
            [dic setValue:headpath forKey:@"fdheadpath"];
            
            NSMutableDictionary *fdapplyfor = [[NSMutableDictionary alloc] init];
            [fdapplyfor setValue:fdmobile forKey:@"fdmobile"];
            [fdapplyfor setValue:@"N" forKey:@"fdStatus"];
            [dic setValue:fdapplyfor forKey:@"fdapplyfor"];
            [array addObject:dic];
            aCtrl.data = array;
            [self.navigationController pushViewController:aCtrl animated:YES];
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
    // Dispose of any resources that can be recreated.
}

@end
