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
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "SDWebImage/SDImageCache.h"
#import "UIUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "InviteFriendsViewController.h"

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


-(void)layoutSubviews{
    
    self.frame = CGRectMake(0, 0, ScreenWidth, 160);
    UIImage *buttonImage = [UIImage imageNamed:@"mine_btn_bg.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
    buttonImage = [buttonImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.btn_addfriend setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.btn_infosetting setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.btn_addfriend setImage:[UIImage imageNamed:@"mine_icon_add"] forState:UIControlStateHighlighted];
    [self.btn_infosetting setImage:[UIImage imageNamed:@"mine_icon_set"] forState:UIControlStateHighlighted];
    _img_userhead.layer.cornerRadius = 30;
    _img_userhead.layer.borderColor = [UIColor whiteColor].CGColor;
    _img_userhead.layer.borderWidth = 2;
    _img_userhead.clipsToBounds = YES;
    [super layoutSubviews];
}


- (IBAction)action_set:(id)sender {
    UIViewController *uvCtrl  = (UIViewController *)[self.superview.superview nextResponder];
    UserInfoSettingViewController *setCtrl = [[UserInfoSettingViewController alloc] init];
    [uvCtrl.navigationController pushViewController:setCtrl animated:YES];
}

- (IBAction)action_add:(id)sender {
    InviteFriendsViewController *iCtrl = [[InviteFriendsViewController alloc] init];
    [self.viewController.navigationController pushViewController:iCtrl animated:YES];
}

- (IBAction)action_head:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"用户相册", nil];
    [actionSheet showInView:self];
}

#pragma mark -UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请在iPhone的\"设置-隐私-相机\"中允许\"流量备胎\"访问相机。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
            //拍照
            if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有找到摄像头设备" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
                return;
            }
            sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if(buttonIndex == 1){
        int author = [ALAssetsLibrary authorizationStatus];
        if(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
            // The user has explicitly denied permission for media capture.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请在iPhone的\"设置-隐私-照片\"中允许\"流量备胎\"访问照片。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        //用户相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if(buttonIndex == 2){
        //取消
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    imagePicker.editing = YES;
    imagePicker.allowsEditing = YES;
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _headImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [UIView animateWithDuration:0.5 animations:^{
        [_img_userhead setImage:_headImage forState:UIControlStateNormal];
    }];
    [(BaseViewController *)[self.superview.superview nextResponder] showStatusTip:YES title:@"正在发送..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSData *data = UIImageJPEGRepresentation(_headImage,0.2);
    NSDictionary *parameters = @{ican_mobile:mobile,ican_password:password};
//    NSString *datetime = [UIUtils stringFromFomate:[NSDate date] formate:@"mmss"];
    NSString *url = [BaseUrlString stringByAppendingFormat:@"headupload.do?mobile=%@&password=%@",mobile,password];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"item" fileName:@"item.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"00"]) {
            NSString *headpath = [responseObject objectForKey:ican_headpath];
            NSString *oldHeadPath = [UserInfoManager readObjectByKey:ican_headpath];
            [UserInfoManager updateWithObject:headpath forKey:ican_headpath];
            [[SDImageCache sharedImageCache] removeImageForKey:[BaseUrlString stringByAppendingString:oldHeadPath] fromDisk:YES];
            [[SDImageCache sharedImageCache] storeImage:self.headImage forKey:[BaseUrlString stringByAppendingString:headpath] toDisk:YES];
            [(BaseViewController *)[self.superview.superview nextResponder] showStatusTip:NO title:@"保存头像成功"];
        } else {
            [(BaseViewController *)[self.superview.superview nextResponder] showStatusTip:NO title:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSString *param = [NSString stringWithFormat:@"%ld错误,%@",(long)error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
         [(BaseViewController *)[self.superview.superview nextResponder] showStatusTip:NO title:param];
    }];
    
   
}

#pragma mark - 提示处理
-(void)toast:(NSString *) param{
    BaseViewController *ctrl =(BaseViewController *)[self.superview.superview nextResponder];
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:ctrl.view];
    toast.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    toast.labelText = param;
    toast.mode = MBProgressHUDModeCustomView;
    [ctrl.view addSubview:toast];
    [toast show:YES];
    [toast hide:YES afterDelay:2];
    
}


@end
