//
//  MineViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/9/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeadView.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "MyOrderViewController.h"

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
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"mineitem" ofType:@"plist"];
    self.data = [[NSMutableArray  alloc] initWithContentsOfFile:plistPath];
    MineHeadView *tableHeadView = [[MineHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
    self.tableView.autoresizesSubviews = YES;
    self.tableView.tableHeaderView =tableHeadView;
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
    MyLog(selabel,nil);
    if ([[self getVauleForDicByGroup:0 selectRow:0] isEqualToString:selabel]) {
        MyOrderViewController *orderCtrl = [[MyOrderViewController alloc] init];
        [self.navigationController pushViewController:orderCtrl animated:YES];
    }
    if ([[self getVauleForDicByGroup:0 selectRow:1] isEqualToString:selabel]) {
        
    }
    if ([[self getVauleForDicByGroup:1 selectRow:0] isEqualToString:selabel]) {
        FeedbackViewController *feedbackCtrl = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackCtrl animated:YES];
    }
    if ([[self getVauleForDicByGroup:1 selectRow:1] isEqualToString:selabel]) {
        
    }
    if ([[self getVauleForDicByGroup:1 selectRow:2] isEqualToString:selabel]) {
        AboutViewController *aboutCtrl = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutCtrl animated:YES];
    }
    if ([[self getVauleForDicByGroup:2 selectRow:0] isEqualToString:selabel]) {
        
    }
    
    
}

-(id)getVauleForDicByGroup:(long) section selectRow:(long) row {
    return [[self.data objectAtIndex:section][row] objectForKey:@"title"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setBlueNav];
    [super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
