//
//  InviteFriendsViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/20.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
#import "JDFPeekabooCoordinator.h"

@interface InviteFriendsViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;
@end
