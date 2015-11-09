//
//  DatePickerSheetView.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/2.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerSheetView : UIActionSheet

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)action_cancle:(id)sender;
- (IBAction)action_ok:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *label_title;
@property (strong,nonatomic) NSString * selectedDate;
@property (nonatomic) BOOL isShow;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;
- (void)showInView:(UIView *)view;
-(void)removeView;

@end
