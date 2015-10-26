//
//  FlowUnsubscribeViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/23.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "FlowUnsubscribeViewController.h"

@interface FlowUnsubscribeViewController ()

@end

@implementation FlowUnsubscribeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"流量退订";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_header.layer.cornerRadius = _btn_header.frame.size.width/2;
    _btn_header.clipsToBounds = YES;
    _btn_ok.layer.cornerRadius = 6;
    _btn_ok.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
