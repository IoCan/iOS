//
//  BtFlowDetailsViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/26.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BtFlowDetailsViewController.h"
#import "BtFlowDetailsCell.h"

@interface BtFlowDetailsViewController ()

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
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 114.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
