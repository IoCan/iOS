//
//  HomeProgressView.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/28.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircularProgressView.h"

@interface HomeProgressView : UIView<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet CircularProgressView *progress;
@property (strong, nonatomic) IBOutlet UILabel *label_flow;

@property (nonatomic) NSInteger initflow;
@property (nonatomic) float initprogress;

-(void)updateProgress:(float) progress;

-(void)setFlow:(NSInteger) flow;

@end
