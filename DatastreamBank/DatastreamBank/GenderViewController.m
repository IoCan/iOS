//
//  GenderViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/2.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "GenderViewController.h"
#import "NSString+Phone.h"

@interface GenderViewController ()
@end

@implementation GenderViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"性别";
    }
    return self;
}

- (void)viewDidLoad {
     self.isCancelButton = YES;
    [super viewDidLoad];
    self.data = [[NSMutableArray alloc] init];
    [self.data addObject:@"男"];
    [self.data addObject:@"女"];
    if ([NSString isBlankString:self.selSex]) {
        self.selSex = @"男";
    }

}


//这个方法告诉表格第section个分段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

//这个方法用来告诉某个分组的某一行是什么数据，返回一个UITableViewCel
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    cell.accessoryType = [[self.data objectAtIndex:indexPath.row] isEqualToString:self.selSex]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark -代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中高亮
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    for (UITableViewCell *cell in tableView.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    switch (indexPath.row) {
        case 0:
            self.selSex = @"男";
            break;
        case 1:
            self.selSex = @"女";
            break;
        default:
            break;
    }
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}


-(void)okAction {
    if (self.delegate) {
        [self.delegate selectedGender:self.selSex];
    }
    [super okAction];
}

 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
