//
//  NickNameViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/2.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
@protocol NickNameDelegate <NSObject>

@optional

- (void)nickname: (NSString *)values;

@end

@interface NickNameViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextField *txt_nicename;
@property (strong,nonatomic) NSString * titleStr;

@property (assign, nonatomic) id <NickNameDelegate> delegate;


@end
