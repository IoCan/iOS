//
//  ConfirmOrderViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/27.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "ConfirmOrderViewController.h"

@interface ConfirmOrderViewController ()
@property (strong, nonatomic) UIButton *selBtn;
@end

@implementation ConfirmOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"确认订购";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"bg_check.png"];
    image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    UIImage *selImage = [UIImage imageNamed:@"bg_check_sel2.png"];
    selImage = [selImage stretchableImageWithLeftCapWidth:2 topCapHeight:24];
    [_btn_chk1 setBackgroundImage:image forState:UIControlStateNormal];
    [_btn_chk2 setBackgroundImage:image forState:UIControlStateNormal];
    
    [_btn_chk1 setBackgroundImage:selImage forState:UIControlStateSelected];
    [_btn_chk2 setBackgroundImage:selImage forState:UIControlStateSelected];
    
    [_btn_chk1 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    [_btn_chk2 addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    
    _btn_order.layer.cornerRadius = 6;
    _btn_order.clipsToBounds = YES;
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
