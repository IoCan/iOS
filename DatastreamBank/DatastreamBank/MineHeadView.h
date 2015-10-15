//
//  MineHeadView.h
//  DatastreamBank
//  我的模块－顶部自定义view
//  Created by OsnDroid on 15/10/12.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineHeadView : UIView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImage *headImage;
@property (nonatomic,strong)  UINavigationController *navigationController;
- (id)initWithFrame:(CGRect)frame navg:(UINavigationController *) nav;

 
@property (strong, nonatomic) IBOutlet UIButton *img_userhead;
@property (strong, nonatomic) IBOutlet UILabel *label_userphone;
@property (strong, nonatomic) IBOutlet UIButton *btn_addfriend;
@property (strong, nonatomic) IBOutlet UIButton *btn_infosetting;
- (IBAction)action_set:(id)sender;
- (IBAction)action_add:(id)sender;
- (IBAction)action_head:(id)sender;

@end
