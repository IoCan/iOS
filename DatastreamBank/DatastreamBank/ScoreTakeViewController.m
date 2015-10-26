//
//  ScoreTakeViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/14.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "ScoreTakeViewController.h"
#import "ScoreTakeViewCell.h"

@interface ScoreTakeViewController ()

@end

@implementation ScoreTakeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"积分获取";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"scoretake" ofType:@"plist"];
    self.data = [[NSMutableArray  alloc] initWithContentsOfFile:plistPath];
}

#pragma mark -数据源方法
//这个方法用来告诉某个分组的某一行是什么数据，返回一个UITableViewCel
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"ScoreTakeViewCell";
    ScoreTakeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
         cell = [[ScoreTakeViewCell alloc] initWithFrame:CGRectZero];
    }

    NSDictionary *items = [self.data objectAtIndex:indexPath.row];
    [cell.img_icon setImage:[UIImage imageNamed:[items objectForKey:@"icon"]]];
    cell.label_optname.text = [items objectForKey:@"title"];
    cell.label_score.text = [items objectForKey:@"score"];
    cell.label_state.text = [items objectForKey:@"state"];
    cell.label_type.text = [items objectForKey:@"desc"];
    UIColor *defalutColor = cell.label_state.textColor;
    UIColor *yellowColor = RGBA(266, 120, 2, 1.0);
    if ([cell.label_state.text isEqualToString:@"已完成"]) {
        cell.img_arrow.hidden = YES;
        cell.label_state.textColor = defalutColor;
        CGFloat x = cell.img_arrow.frame.origin.x-cell.label_state.frame.size.width+cell.img_arrow.frame.size.width;
        cell.label_state.frame = CGRectMake(x, cell.label_state.frame.origin.y, cell.label_state.frame.size.width, cell.label_state.frame.size.height);
    } else {
        cell.label_state.textColor = yellowColor;
        cell.img_arrow.hidden = NO;
    }
    cell.selectionStyle =UITableViewCellAccessoryNone;
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
