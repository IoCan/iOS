//
//  FlowInfoCell.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/6.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *label_title;
@property (strong, nonatomic) IBOutlet UILabel *label_desc;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *label_pre;

@property (strong, nonatomic) IBOutlet UIView *bg_view;

@property (nonatomic)float initProgress;


@end
