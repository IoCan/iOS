//
//  PresentFriendsViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/15.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "PresentFriendsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+Phone.h"
#import "PresentViewController.h"
#import "FriendsCell.h"
#import "UIButton+WebCache.h"

@interface PresentFriendsViewController ()

@property (nonatomic,strong) UITableViewCell *selCell;

@end

@implementation PresentFriendsViewController

#pragma nib初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"送好友";
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_present.layer.cornerRadius = 4.0f;
    _btn_rule.layer.cornerRadius = 4.0f;
    _btn_present.clipsToBounds = YES;
    _btn_rule.clipsToBounds = YES;
    UILabel *label = [[UILabel alloc] init];
    label.text = @"您还没有好友";
    label.textColor = [UIColor lightGrayColor];
    label.tag = 10;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(ScreenWidth/2-100, _tableView.height/2-20, 200, 40);
    label.hidden = YES;
    [_tableView addSubview:label];
    PresentFriendsHeadView *headView = [[PresentFriendsHeadView alloc] init];
    headView.delegate = self;
    _tableView.tableHeaderView = headView;
    [self loadFriends];
}

-(void)loadFriends {
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
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
                self.data = [responseObject objectForKey:@"resultlist"];
                self.filtereddata = self.data;
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
            [toast hide:YES];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",(long)error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示" msg:param];
    }];
    
    
    
}

#pragma mark -数据源方法
//这个方法用来告诉某个分组的某一行是什么数据，返回一个UITableViewCel
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"FriendsCell";
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[FriendsCell alloc] initWithFrame:CGRectZero];
    }
    NSDictionary *dic = [self.filtereddata objectAtIndex:indexPath.row];
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
    return self.filtereddata.count;
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

#pragma mark - 顶部代理实现
-(void)click:(NSString *)param {
//    NSLog(@"param:%@",param);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@", @"fdmobile", param];
    self.filtereddata = [self.data filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
//fdmobile
}

#pragma mark - 事件处理
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



- (IBAction)action_rule:(id)sender {
    [self alert:@"赠送规则" msg:@"1.用户可将备胎账户中剩余流量赠送给好友，赠送额度用户可自行输入；\n2.赠送成功流量将直接充至受赠方备胎账户中；受赠方将收到消息提醒。"];
}


#pragma mark - 生命周期
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
