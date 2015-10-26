//
//  MessageCell.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/17.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *label_title;


@property (strong, nonatomic) IBOutlet UIButton *btn_state;

@property (strong, nonatomic) IBOutlet UILabel *label_date;

@property (strong, nonatomic) IBOutlet UILabel *label_detail;
@end
