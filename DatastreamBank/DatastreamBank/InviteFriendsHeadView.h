//
//  InviteFriendsHeadView.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/15.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeadViewClickDelegate <NSObject>

@optional
-(void)click:(NSString *) param;

@end

@interface InviteFriendsHeadView : UIView<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *bg_view;
@property (strong, nonatomic) IBOutlet UITextField *txt_phone;
- (IBAction)action_add:(id)sender;

@property (assign, nonatomic) id <HeadViewClickDelegate> delegate;
@end
