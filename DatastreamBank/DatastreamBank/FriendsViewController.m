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

@interface FriendsViewController ()

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
    _btn_present.layer.cornerRadius = 10;
    _btn_demand.layer.cornerRadius = 10;
    _btn_demand.clipsToBounds = YES;
    _btn_present.clipsToBounds = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
     FriendsHeadView *tableHeadView = [[FriendsHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
    self.tableView.tableHeaderView =tableHeadView;

}

#pragma mark -数据源方法
//这个方法用来告诉某个分组的某一行是什么数据，返回一个UITableViewCel
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"FriendsCell";
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[FriendsCell alloc] initWithFrame:CGRectZero];
    }
    cell.selectedBackgroundView.backgroundColor = RGBA(255, 250, 246, 1.0);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 81.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
