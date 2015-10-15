//
//  ScoreTakeViewCell.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/14.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreTakeViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *img_icon;
@property (strong, nonatomic) IBOutlet UILabel *label_optname;
@property (strong, nonatomic) IBOutlet UILabel *label_score;
@property (strong, nonatomic) IBOutlet UILabel *label_type;
@property (strong, nonatomic) IBOutlet UILabel *label_state;
@property (strong, nonatomic) IBOutlet UIView *view_bg;
@property (strong, nonatomic) IBOutlet UIImageView *img_arrow;

@end
