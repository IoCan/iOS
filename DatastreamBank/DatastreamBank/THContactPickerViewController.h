//
//  ContactPickerViewController.h
//  ContactPicker
//
//  Created by Tristan Himmelman on 11/2/12.
//  Copyright (c) 2012 Tristan Himmelman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THContactPickerTableViewCell.h"
#import "BaseViewController.h"


@protocol SelectedPhoneDelegate <NSObject>

@optional

- (void)selectedPhone: (NSString *)values;

@end

@interface THContactPickerViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>



@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *top_view;
@property (strong, nonatomic) IBOutlet UITextField *txt_phone;
- (IBAction)action_add:(id)sender;

@property (nonatomic, strong) NSMutableArray *contacts;

@property (assign, nonatomic) id <SelectedPhoneDelegate> delegate;

@end
