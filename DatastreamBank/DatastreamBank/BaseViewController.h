//
//  BaseViewController.h
//  OsnDroidWeiBo
//
//  Created by OsnDroid on 14-8-2.
//  Copyright (c) 2014年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface BaseViewController : UIViewController


@property(nonatomic,assign)BOOL isBackButton;
@property(nonatomic,assign)BOOL isCancelButton;
 
-(void)setWhiteNav;
-(void)setBlueNav;



@end
