//
//  MyOrderCell.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *view_bg;
@property (strong, nonatomic) IBOutlet UIImageView *img_icon;
@property (strong, nonatomic) IBOutlet UILabel *label_type;
@property (strong, nonatomic) IBOutlet UILabel *label_flow;
@property (strong, nonatomic) IBOutlet UILabel *label_price;
@property (strong, nonatomic) IBOutlet UILabel *label_time;

@end
