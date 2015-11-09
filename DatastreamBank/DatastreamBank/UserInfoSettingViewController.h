//
//  UserInfoSettingViewController.h
//  DatastreamBank
//  我的模块－个人资料设置
//  Created by OsnDroid on 15/10/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
#import "GenderViewController.h"
#import "NickNameViewController.h"
#import "UIViewController+BackButtonHandler.h"
@protocol ChangeHeaderDelegate <NSObject>
@optional

- (void)changeHead: (BOOL)ischange;

@end

@interface UserInfoSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,SelectedGenderDelegate,NickNameDelegate,BackButtonHandlerProtocol,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *btn_save;

@property (strong, nonatomic) NSMutableArray *data;//数据源

@property (strong, nonatomic) NSMutableArray *olddata;//旧数据源

@property (assign, nonatomic) id <ChangeHeaderDelegate> delegate;

@end
