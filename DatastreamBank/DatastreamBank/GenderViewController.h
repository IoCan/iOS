//
//  GenderViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/2.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
@protocol SelectedGenderDelegate <NSObject>

@optional

- (void)selectedGender: (NSString *)values;

@end


@interface GenderViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;//数据源
@property (nonatomic,strong) NSString *selSex;
@property (assign, nonatomic) id <SelectedGenderDelegate> delegate;

@end
