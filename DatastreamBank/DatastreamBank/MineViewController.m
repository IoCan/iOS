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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHead:) name:loadhead object:nil];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    NSBundle *bundle = [NSBundle mainBundle];
//    NSLog(@"%@",[UserInfoManager readObjectByKey:ican_headpath]);
    NSString *plistPath = [bundle pathForResource:@"mineitem" ofType:@"plist"];
    self.data = [[NSMutableArray  alloc] initWithContentsOfFile:plistPath];
    self.tableHeadView = [[MineHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
    self.tableView.tableHeaderView =self.tableHeadView;
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSInteger virtualflow = [[UserInfoManager readObjectByKey:ican_virtualflow] integerValue];
    NSString *score = [UserInfoManager readObjectByKey:ican_score];
    NSString *headpath = [UserInfoManager readObjectByKey:ican_headpath];
    self.tableHeadView.label_userphone.text = [NSString stringWithFormat:@"账户：%@",mobile];
    self.tableHeadView.label_virtualflow.text = [NSString stringWithFormat:@"备胎余额：%ldM",virtualflow];
    self.tableHeadView.label_score.text = [NSString stringWithFormat:@"当前积分：%@",score];
    if (headpath!=nil && headpath.length>10) {
        NSString *headurl = [BaseUrlString stringByAppendingString:headpath];
        [self.tableHeadView.img_userhead sd_setImageWithURL:[NSURL URLWithString:headurl]
                                                   forState:UIControlStateNormal
                                           placeholderImage:[UIImage imageNamed:@"img_header_default.png"]
                                                    options:SDWebImageDelayPlaceholder
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                                      NSLog(@"%@",error);
                                                  }];
        
    }
  
    
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
        MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
        toast.labelText = @"正在检查";
        toast.mode = MBProgressHUDModeIndeterminate;
        [self.view addSubview:toast];
        [toast showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            
//            toast = nil;
            [self toast:self.view cotent:@"已经是最新的了！"];
        }];
    }
    if ([[self getVauleForDicByGroup:1 selectRow:2] isEqualToString:selabel]) {
        //关于我们
        viewCtrl = [[AboutViewController alloc] init];
    }
    if ([[self getVauleForDicByGroup:2 selectRow:0] isEqualToString:selabel]) {
        //注销
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"注销后将会移除本地缓存历史数据，下次登录将会加载最新数据。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
    }
    if (viewCtrl) {
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
    
    
}

#pragma mark -UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self toast:self.view cotent:@"注销成功"];
        [UserInfoManager clear];
        UserLoginViewController *loginCtrl = [[UserLoginViewController alloc] init];
        AppDelegate *deleteview =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        deleteview.window.rootViewController = loginCtrl;
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
