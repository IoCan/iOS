//
//  BtAcountHeadView.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/25.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BtAcountHeadView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UIButton *btn_header;

@property (strong, nonatomic) IBOutlet UILabel *label_userphone;
@property (strong, nonatomic) IBOutlet UILabel *label_balance;

@end
