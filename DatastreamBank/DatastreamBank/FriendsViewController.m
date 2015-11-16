//
//  FriendsViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/9/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsCell.h"
#import "FriendsHeadView.h"
#import "UIButton+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+Phone.h"
#import "PresentViewController.h"
#import "MJRefresh.h"

@interface FriendsViewController ()

@property (nonatomic,strong) UITableViewCell *selCell;
@property (strong, nonatomic) FriendsHeadView *tableHeadView;

@end

@implementation FriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"朋友圈";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_present.layer.cornerRadius = 6;
    _btn_demand.layer.cornerRadius = 6;
    _btn_demand.clipsToBounds = YES;
    _btn_present.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"您还没有好友";
    label.textColor = [UIColor lightGrayColor];
    label.tag = 10;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(ScreenWidth/2-100, _tableView.height/2-20, 200, 40);
    label.hidden = YES;
    [_tableView addSubview:label];
    _tableHeadView = [[FriendsHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
    self.tableView.tableHeaderView =_tableHeadView;
//    [self loadFriends];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFriends)];
    [self.tableView.header beginRefreshing];
}

-(void)loadFriends {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                                 ican_password:[UserInfoManager readObjectByKey:ican_password]};
    
    //**********************朋友圈查询************************//
    parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                   ican_password:[UserInfoManager readObjectByKey:ican_password]};
    [manager POST:[BaseUrlString stringByAppendingString:@"friendquery.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
//            NSLog(@"%@",responseObject);
            NSString *result = [responseObject objectForKey:@"result"];
            if ([@"00" isEqualToString:result]) {
                NSArray *array = [responseObject objectForKey:@"resultlist"];
                self.data = [[NSMutableArray alloc] initWithArray:array];
                self.tableHeadView.count = (int)[self.data count];
                [self.tableView reloadData];
                if (self.data.count ==0) {
                    [_tableView viewWithTag:10].hidden = NO;
                } else {
                    [_tableView viewWithTag:10].hidden = YES;
                }
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
            [self.tableView.header endRefreshing];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
    }];
    

    
}

#pragma mark - 加载头部数据 
-(void)loadLocalTopData {
    if (self.tableHeadView == nil) {
        return;
    }
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSInteger virtualflow = [[UserInfoManager readObjectByKey:ican_virtualflow] integerValue];
    NSString *headpath = [UserInfoManager readObjectByKey:ican_headpath];
    self.tableHeadView.label_userphone.text = [NSString stringWithFormat:@"账户：%@",mobile];
    self.tableHeadView.label_balance.text = [NSString stringWithFormat:@"备胎余额：%ldM",virtualflow];
    if (headpath!=nil && headpath.length>10) {
        NSString *headurl = [BaseUrlString stringByAppendingString:headpath];
        [self.tableHeadView.btn_head sd_setBackgroundImageWithURL:[NSURL URLWithString:headurl]
                                                         forState:UIControlStateNormal
                                                 placeholderImage:[UIImage imageNamed:@"img_header_default.png"]
                                                          options:SDWebImageDelayPlaceholder
                                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                            //                                                      NSLog(@"%@",error);
                                                        }];
        
    }

}

#pragma mark -数据源方法
//这个方法用来告诉某个分组的某一行是什么数据，返回一个UITableViewCel
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"FriendsCell";
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[FriendsCell alloc] initWithFrame:CGRectZero];
    }
    NSDictionary *dic = [_data objectAtIndex:indexPath.row];
    NSString *fdheadpath = [dic objectForKey:@"fdheadpath"];
    NSString *fdmobile = [dic objectForKey:@"fdmobile"];
    NSString *nickname = [dic objectForKey:@"nickname"];
    NSString *remark = [dic objectForKey:@"remark"];
    int score = [[dic objectForKey:@"score"] intValue];
    if ([NSString isBlankString:nickname]) {
        nickname = remark;
    }
    if ([NSString isBlankString:nickname]) {
        nickname = fdmobile;
    }
    cell.label_name.text = nickname;
    [cell.btn_phone setTitle:fdmobile forState:UIControlStateNormal];
    [cell.btn_scrore setTitle:[NSString stringWithFormat:@"积分:%d",score] forState:UIControlStateNormal];
    if (![NSString isBlankString:fdheadpath]) {
        NSURL *url = [NSURL URLWithString:[BaseUrlString stringByAppendingString:fdheadpath]];
        [cell.btn_head sd_setBackgroundImageWithURL:url
                                           forState:UIControlStateNormal
                                    placeholderImage:[UIImage imageNamed:@"infosetting_header_default.png"]
                                                              options:SDWebImageDelayPlaceholder
                                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                //                                                      NSLog(@"%@",error);
                                                            }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 81.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中高亮
    if ([_selCell isEqual:[tableView cellForRowAtIndexPath:indexPath]]) {
        [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
        _selCell = nil;
    } else {
        _selCell = [tableView cellForRowAtIndexPath:indexPath];
    }
}


//先要设Cell可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     if(indexPath.row ==0)
     {
     [tableView setEditing:YES animated:YES];  //这个是整体出现
     }
     */
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [_data objectAtIndex:indexPath.row];
    NSString *fdmobile = [dic objectForKey:@"fdmobile"];
    [self deleteFriends:fdmobile];
    [_data removeObjectAtIndex:indexPath.row];
    self.tableHeadView.count = (int)[self.data count];
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [_tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
    
  
     if(indexPath ==0)
     {
     [tableView setEditing:NO animated:YES];
     }
    
}

#pragma mark - 删除用户
-(void)deleteFriends:(NSString *)fdmobile {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSDictionary *parameters = @{ican_mobile:mobile,
                                 ican_password:password,
                                 @"fdmobile":fdmobile
                                 };
    [manager POST:[BaseUrlString stringByAppendingString:@"frienddelete.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MyLog(@"%@",responseObject);
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        [self toast:self.view cotent:resultMsg];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示信息" msg:param];
    }];
    
}

#pragma mark - 生命周期 
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadLocalTopData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)action_present:(id)sender {
    if (_selCell) {
        PresentViewController *pCtrl = [[PresentViewController alloc] init];
        FriendsCell * precell = (FriendsCell *)_selCell;
        pCtrl.fdmobile  = precell.btn_phone.titleLabel.text;
        [self.navigationController pushViewController:pCtrl animated:YES];
    } else {
        [self toast:self.view cotent:@"请选择一位好友"];
    }
    
}

- (IBAction)action_demand:(id)sender {
    if (_selCell) {
        [self demand];
    } else {
        [self toast:self.view cotent:@"请选择一位好友"];
    }
}

#pragma mark - 索要操作
-(void)demand {
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"索要中";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    //索要接口 flowapplyfor.do
    //参数 mobile password fdmobile
 
    FriendsCell * precell = (FriendsCell *)_selCell;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSDictionary *parameters = @{ican_mobile:mobile,
                                 ican_password:password,
                                 @"fdmobile":precell.btn_phone.titleLabel.text
                                 };
    [manager POST:[BaseUrlString stringByAppendingString:@"flowapplyfor.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        MyLog(@"%@",responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        NSString *res = [responseObject objectForKey:@"res"];
        if ([res isEqualToString:@"00"]) {
            resultMsg = [responseObject objectForKey:@"resMsg"];
            NSString *scorefull = [responseObject objectForKey:@"scorefull"];
            NSLog(@"%@",scorefull);
            [UserInfoManager updateWithObject:[responseObject objectForKey:@"score"] forKey:ican_score];
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:resultMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
        } else if([result isEqualToString:@"99"]){
            [self alert:@"提示信息" msg:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示信息" msg:param];
    }];
    
}
@end
