//
//  MineHeadView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/12.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "MineHeadView.h"
#import "UserInfoSettingViewController.h"
#import "BaseNavigationController.h"


@implementation MineHeadView


/**
 *  初始化xib页面
 *
 *  @param frame 页面位置大小
 *
 *  @return UIView
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"MineHeadView" owner:self options:nil][0];
        self.frame =  CGRectMake(0, 0, ScreenWidth, 160);
        [self addSubview:view];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame navg:(UINavigationController *) nav{
    _navigationController = nav;
    return  [self initWithFrame:frame];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, ScreenWidth, 160);
    UIImage *buttonImage = [UIImage imageNamed:@"mine_btn_bg.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
    buttonImage = [buttonImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.btn_addfriend setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.btn_infosetting setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.btn_addfriend setImage:[UIImage imageNamed:@"mine_icon_add"] forState:UIControlStateHighlighted];
    [self.btn_infosetting setImage:[UIImage imageNamed:@"mine_icon_set"] forState:UIControlStateHighlighted];
}

 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)action_set:(id)sender {
    if (_navigationController) {
        UserInfoSettingViewController *setCtrl = [[UserInfoSettingViewController alloc] init];
        [_navigationController pushViewController:setCtrl animated:YES];
//        BaseNavigationController *sendNav = [[BaseNavigationController alloc] initWithRootViewController:setCtrl];
//        [_navigationController presentViewController:sendNav animated:YES completion:NULL];
    }
}

- (IBAction)action_add:(id)sender {
    
}

- (IBAction)action_head:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"用户相册", nil];
    [actionSheet showInView:self];
}

#pragma mark -UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerControllerSourceType sourceType;
    
    if (buttonIndex == 0) {
        //拍照
        if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有找到摄像头设备" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
        sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else if(buttonIndex == 1){
        //用户相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if(buttonIndex == 2){
        //取消
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [_navigationController presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [UIView animateWithDuration:0.5 animations:^{
        _img_userhead.imageView.image = _headImage;
    }];
}


@end
