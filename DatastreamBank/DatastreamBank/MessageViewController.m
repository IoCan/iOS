//
//  MessageViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/9.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "MessageViewController.h"
#import "RDVTabBarController.h"
#import "SegTabBarView.h"


@interface MessageViewController ()

@property (strong, nonatomic) SegTabBarView *segTabBarView;

@end

@implementation MessageViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"服务窗";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
//    NSLog(@"%f",self.view.frame.size.width);
//    CGRect screenBound = [[UIScreen mainScreen] bounds];
//    screenBound.origin.y = 60;
    NSArray *array = @[@"消息通知", @"备胎消息", @"优惠消息"];
    NSMutableArray *items =[[NSMutableArray alloc] initWithArray:array];
    _segTabBarView = [[SegTabBarView alloc] initWithFrame:self.view.frame WithArray:items];
    [self.view addSubview:_segTabBarView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
