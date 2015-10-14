//
//  MyOrderViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderCell.h"

@interface MyOrderViewController ()

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
    [self setWhiteNav];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark -数据源方法

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"MyOrderCell";
    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[MyOrderCell alloc] initWithFrame:CGRectZero];
    }
    if (indexPath.row % 2 == 0) {
        [cell.img_icon setImage:[UIImage imageNamed:@"icon_dd_1"]];
        cell.label_type.text = @"流量操作：备胎－购买";
    } else {
        [cell.img_icon setImage:[UIImage imageNamed:@"icon_dd_2"]];
        cell.label_type.text = @"流量操作：备胎－退订";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 114.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
