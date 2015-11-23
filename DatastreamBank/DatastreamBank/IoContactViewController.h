//
//  IoContactViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/14.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
#import "NSString+Phone.h"
#import "CellClickDelegate.h"

@protocol SelectedPhoneDelegate <NSObject>

@optional

- (void)selectedPhone: (NSString *)values;

@end

@interface IoContactViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,CellClickDelegate>



@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *top_view;
@property (strong, nonatomic) IBOutlet UITextField *txt_phone;
- (IBAction)action_add:(id)sender;

@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSArray *filteredContacts;
@property (nonatomic,assign) BOOL isAdd;
@property (assign, nonatomic) id <SelectedPhoneDelegate> delegate;

@end
