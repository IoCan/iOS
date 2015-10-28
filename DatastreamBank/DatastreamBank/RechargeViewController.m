//
//  RechargeViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/26.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "RechargeViewController.h"

@interface RechargeViewController ()
@property (strong, nonatomic) UIButton *selBtn;
@end

@implementation RechargeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"充至手机账户";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"bg_check_blue.png"];
    image = [image stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    UIImage *selImage = [UIImage imageNamed:@"bg_check_sel2.png"];
    selImage = [selImage stretchableImageWithLeftCapWidth:2 topCapHeight:24];
    [_btn_200 setBackgroundImage:image forState:UIControlStateNormal];
    [_btn_500 setBackgroundImage:image forState:UIControlStateNormal];
    [_btn_1024 setBackgroundImage:image forState:UIControlStateNormal];
    
    
    [_btn_200 setBackgroundImage:selImage forState:UIControlStateSelected];
    [_btn_500 setBackgroundImage:selImage forState:UIControlStateSelected];
    [_btn_1024 setBackgroundImage:selImage forState:UIControlStateSelected];
    
    //90 189 210
    UIColor *ncolor = RGBA(90, 189, 210, 1.0);
    UIColor *scolor = RGBA(255, 120, 2, 1.0);
    [_btn_200 setTitleColor:scolor forState:UIControlStateSelected];
    [_btn_200 setTitleColor:ncolor forState:UIControlStateNormal];
    [_btn_500 setTitleColor:scolor forState:UIControlStateSelected];
    [_btn_500 setTitleColor:ncolor forState:UIControlStateNormal];
    [_btn_1024 setTitleColor:scolor forState:UIControlStateSelected];
    [_btn_1024 setTitleColor:ncolor forState:UIControlStateNormal];
    
    
    [_btn_200 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    [_btn_500 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    [_btn_1024 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
}

-(void)checkboxClick:(UIButton*)btn{
    if (_selBtn) {
        _selBtn.selected = !_selBtn.selected;
    }
    _selBtn = btn;
    btn.selected=!btn.selected;//每次点击都改变按钮的状态
    
    if(btn.selected){
        
    }else{
        
        //在此实现打勾时的方法
        
    }
    
    //在此实现不打勾时的方法
    
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
