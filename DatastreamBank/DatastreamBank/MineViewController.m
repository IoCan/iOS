//
//  MineViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/9/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "MineViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "MyOrderViewController.h"
#import "MyScoreViewController.h"
#import "MBProgressHUD.h"
#import "UserLoginViewController.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"
#import "UserInfoManager.h"
#import "AppUpdateHelper.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+Phone.h"
#import "MJRefresh.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"mineitem" ofType:@"plist"];
    self.data = [[NSMutableArray  alloc] initWithContentsOfFile:plistPath];
    self.tableHeadView = [[MineHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
    self.tableView.tableHeaderView =self.tableHeadView;
    [self updateFromAppStore:self.view isShow:NO];
    [self setData];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateDate)];
}

-(void)setData {
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSInteger virtualflow = [[UserInfoManager readObjectByKey:ican_virtualflow] integerValue];
    NSString *score = [UserInfoManager readObjectByKey:ican_score];
    NSString *headpath = [UserInfoManager readObjectByKey:ican_headpath];
    self.tableHeadView.label_userphone.text = [NSString stringWithFormat:@"账户：%@",mobile];
    self.tableHeadView.label_virtualflow.text = [NSString stringWithFormat:@"备胎余额：%ldM",(long)virtualflow];
    self.tableHeadView.label_score.text = [NSString stringWithFormat:@"当前积分：%@",score];
    if (headpath!=nil && headpath.length>10) {
        NSString *headurl = [BaseUrlString stringByAppendingString:headpath];
        [self.tableHeadView.img_userhead sd_setBackgroundImageWithURL:[NSURL URLWithString:headurl]
                                                             forState:UIControlStateNormal
                                                     placeholderImage:[UIImage imageNamed:@"img_header_default.png"]
                                                              options:SDWebImageDelayPlaceholder
                                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                //                                                      NSLog(@"%@",error);
                                                            }];
        
    }

}

-(void)updateDate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSDictionary *parameters = @{ican_mobile:mobile,ican_password:password};
    [manager POST:[BaseUrlString stringByAppendingString:@"userquery.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"00"]) {
            NSDictionary *userList = [responseObject objectForKey:UserInfo];
            [UserInfoManager saveDic:userList];
            [self setData];
        }
        [self.tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        NSString *param = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self toast:self.view cotent:param];
    }];

}

#pragma mark -数据源方法
//这个方法用来告诉表格有几个分组
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.data count];
}

//这个方法告诉表格第section个分段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.data objectAtIndex:section] count];
}

//这个方法用来告诉某个分组的某一行是什么数据，返回一个UITableViewCel
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *groupedTableIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:groupedTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:groupedTableIdentifier];
    }
    NSUInteger row = [indexPath row];
    NSArray *items = [self.data objectAtIndex:indexPath.section];
    NSDictionary *item = items[row];
    cell.textLabel.text = [item objectForKey:@"title"];
    cell.imageView.image = [UIImage imageNamed:[item objectForKey:@"icon"]];
    if ([[item objectForKey:@"desc"] isEqualToString:@"00"]) {
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
       cell.detailTextLabel.text = @"●";
       cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:20];
       cell.detailTextLabel.textColor = [UIColor redColor];
    }
    return cell;
}

#pragma mark -代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中高亮
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    long section = indexPath.section;
    long row = indexPath.row;
    NSString *selabel = [self getVauleForDicByGroup:section selectRow:row];
    BaseViewController *viewCtrl = nil;
    if ([[self getVauleForDicByGroup:0 selectRow:0] isEqualToString:selabel]) {
        //我的订单
        viewCtrl = [[MyOrderViewController alloc] init];
    }
    if ([[self getVauleForDicByGroup:0 selectRow:1] isEqualToString:selabel]) {
        //我的积分
        viewCtrl = [[MyScoreViewController alloc] init];
    }
    if ([[self getVauleForDicByGroup:1 selectRow:0] isEqualToString:selabel]) {
        //意见反馈
        viewCtrl = [[FeedbackViewController alloc] init];
    }
    if ([[self getVauleForDicByGroup:1 selectRow:1] isEqualToString:selabel]) {
        //检查更新
        [self updateFromAppStore:self.view isShow:YES];
    }
    if ([[self getVauleForDicByGroup:1 selectRow:2] isEqualToString:selabel]) {
        //关于我们
        viewCtrl = [[AboutViewController alloc] init];
    }
    if ([[self getVauleForDicByGroup:2 selectRow:0] isEqualToString:selabel]) {
        //注销
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"注销后将会移除本地缓存历史数据，下次登录将会加载最新数据。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil, nil];
        actionSheet.tag = 200;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
//        [actionSheet showInView:self.view];
    }
    if (viewCtrl) {
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
    
    
}

#pragma mark -UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 200) {
        if (buttonIndex == 0) {
            [self toast:self.view cotent:@"注销成功"];
            [UserInfoManager clear];
            [UserInfoManager updateWithObject:@"100" forKey:ican_isfirst];
            UserLoginViewController *loginCtrl = [[UserLoginViewController alloc] init];
            AppDelegate *deleteview =  (AppDelegate *)[UIApplication sharedApplication].delegate;
            deleteview.window.rootViewController = loginCtrl;
        }
        if (buttonIndex == 1) {
            
        }
    }
    
    
}

-(void)changeHead:(BOOL)ischange {
        NSString *headurl = [BaseUrlString stringByAppendingString:[UserInfoManager readObjectByKey:ican_headpath]];
        [self.tableHeadView.img_userhead sd_setImageWithURL:[NSURL URLWithString:headurl]
                                                   forState:UIControlStateNormal
                                           placeholderImage:[UIImage imageNamed:@"img_header_default.png"]
                                                    options:SDWebImageDelayPlaceholder
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                      //                                                      NSLog(@"%@",error);
                                                  }];

   
}

#pragma -mark更新
-(void)changeUpdateState {
    [[[self.data objectAtIndex:1] objectAtIndex:1] setValue:@"01" forKey:@"desc"];
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:1 inSection:1];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
}


-(void)updateFromAppStore:(UIView *)view isShow:(BOOL)show{
    NSString *version = [UserInfoManager readObjectByKey:@"version"];
    NSString *localVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (![NSString isBlankString:version] && ![version isEqualToString:localVersion]) {
        [self changeUpdateState];
        if (show) {
            NSString *releaseNotes = [UserInfoManager readObjectByKey:@"releaseNotes"];
            UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"有新版本!" message:releaseNotes delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"更新", nil];
            [createUserResponseAlert show];
        }
        return;
    }
  
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:view];
    toast.labelText = @"正在检查";
    toast.mode = MBProgressHUDModeIndeterminate;
    if (show) {
        [view addSubview:toast];
        [toast show:YES];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager GET:updateurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (show) {
            [toast hide:YES];
        }
        
        NSLog(@"%@",responseObject);
        NSArray *configData = [responseObject valueForKey:@"results"];
        NSString *version;
        NSString *releaseNotes;
        NSString *trackViewUrl;
        for (id config in configData)
        {
            version = [config valueForKey:@"version"];
            releaseNotes = [config valueForKey:@"releaseNotes"];
            trackViewUrl = [config valueForKey:@"trackViewUrl"];
            [UserInfoManager addObject:trackViewUrl forKey:@"trackViewUrl"];
            [UserInfoManager addObject:version forKey:@"version"];
            [UserInfoManager addObject:releaseNotes forKey:@"releaseNotes"];
        }
        NSString *localVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
       
        if (![version isEqualToString:localVersion])
        {
            [self changeUpdateState];
//            UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"有新版本!" message:releaseNotes delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"更新", nil];
//            [createUserResponseAlert show];
        } else {
          if (show) {
                MBProgressHUD *toastsuccess = [[MBProgressHUD alloc] initWithView:view];
                toastsuccess.labelText = @"已经是最新的了！";
                toastsuccess.mode = MBProgressHUDModeText;
                [view addSubview:toast];
                [toastsuccess show:YES];
                [toastsuccess hide:YES afterDelay:2];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (show) {
            [toast hide:YES];
            NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",(long)error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
            UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"提示" message: param delegate:nil cancelButtonTitle:nil  otherButtonTitles: @"确定", nil];
            [createUserResponseAlert show];
        }
    }];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        NSString *iTunesLink = [UserInfoManager readObjectByKey:@"trackViewUrl"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}


-(id)getVauleForDicByGroup:(long) section selectRow:(long) row {
    return [[self.data objectAtIndex:section][row] objectForKey:@"title"];
}

#pragma mark - 生命周期处理
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSInteger virtualflow = [[UserInfoManager readObjectByKey:ican_virtualflow] integerValue];
    NSString *score = [UserInfoManager readObjectByKey:ican_score];
    self.tableHeadView.label_virtualflow.text = [NSString stringWithFormat:@"备胎余额：%ldM",virtualflow];
    self.tableHeadView.label_score.text = [NSString stringWithFormat:@"当前积分：%@",score];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"" object:nil];
}


@end
