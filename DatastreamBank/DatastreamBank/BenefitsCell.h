//
//  BenefitsCell.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BenefitsCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *label_title;

@property (strong, nonatomic) IBOutlet UILabel *label_desc;

@property (strong, nonatomic) IBOutlet UIImageView *img_topbg;

@property (strong, nonatomic) IBOutlet UIView *view_content;

@end
