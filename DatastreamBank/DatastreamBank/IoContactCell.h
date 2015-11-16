//
//  IoContactCell.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/14.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellClickDelegate.h"

@interface IoContactCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *img_head;
@property (strong, nonatomic) IBOutlet UILabel *label_name;

@property (strong, nonatomic) IBOutlet UILabel *label_phone;
@property (strong, nonatomic) IBOutlet UIButton *btn_add;


@property (assign,nonatomic) NSIndexPath * indexPath;
@property (nonatomic,strong,setter=setPhone:) NSString *phone;

@property (assign, nonatomic) id <CellClickDelegate> delegate;

@end
