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
    [self.view addSubview:_segTabBarView];
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
        NSLog(@"%@",responseObject);
        @try {
            NSString *result = [responseObject objectForKey:@"result"];
            if ([@"00" isEqualToString:result]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:countNum object:responseObject];
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
