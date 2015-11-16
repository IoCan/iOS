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
#import "AFHTTPRequestOperationManager.h"


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
    NSArray *array = @[@"消息通知", @"备胎消息", @"优惠消息"];
    NSMutableArray *items =[[NSMutableArray alloc] initWithArray:array];
    _segTabBarView = [[SegTabBarView alloc] initWithFrame:self.view.frame WithArray:items];
    [self loaddata];
}


-(void)loaddata {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                                 ican_password:[UserInfoManager readObjectByKey:ican_password]};

    //**********************消息查询************************//
    parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                   ican_password:[UserInfoManager readObjectByKey:ican_password],
                   @"today":@""};
    [manager POST:[BaseUrlString stringByAppendingString:@"sysmessagequery.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSString *result = [responseObject objectForKey:@"result"];
            if ([@"00" isEqualToString:result]) {
                _data = [responseObject objectForKey:@"resultlist"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@", @"sm.type", @"btinfo"];
                _btdata = [self.data filteredArrayUsingPredicate:predicate];
                NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@", @"sm.type", @"sysinfo"];
                _yhdata = [self.data filteredArrayUsingPredicate:predicate2];
//                NSLog(@"%ld-%ld-%ld",_data.count,_btdata.count,_yhdata.count);
                _segTabBarView.data = [[NSMutableArray alloc] initWithArray:_yhdata];
                _segTabBarView.btdata = [[NSMutableArray alloc] initWithArray:_btdata];
                _segTabBarView.yhdata = [[NSMutableArray alloc] init];
                [self.view addSubview:_segTabBarView];
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
