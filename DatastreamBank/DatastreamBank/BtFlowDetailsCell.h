//
//  BtFlowDetailsCell.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/26.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BtFlowDetailsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *view_bg;
@property (strong, nonatomic) IBOutlet UIImageView *img_icon;
@property (strong, nonatomic) IBOutlet UILabel *label_flow;
@property (strong, nonatomic) IBOutlet UILabel *label_date;
@property (strong, nonatomic) IBOutlet UILabel *label_state;

@property (strong,nonatomic,setter=setState:) NSString *state;
@end
