//
//  UserInfoSettingViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/13.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "UserInfoSettingViewController.h"
#import "NSString+Phone.h"
#import "UIImageView+WebCache.h"
#import "UserInfoSettingCell.h"
#import "LocationSheetView.h"
#import "DatePickerSheetView.h"
#import "GenderViewController.h"
#import "NickNameViewController.h"
#import "BaseNavigationController.h"
#import "NSString+Phone.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserInfoManager.h"
#import "UIUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UserInfoSettingViewController ()
@property(nonatomic,strong) LocationSheetView *locateView;
@property(nonatomic,strong) DatePickerSheetView *datePickerView;
@property(nonatomic) BOOL isSave;
@property (nonatomic,strong) UIImage *headImage;
@property(nonatomic,strong) UIAlertView *backalert;

@end

@implementation UserInfoSettingViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"资料设置";
    }
    return self;
}

#pragma mark - 页面初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSave = NO;
    self.btn_save = [[UIButton alloc] init];
    self.btn_save.frame = CGRectMake(0, 0, 45, 30);
    [self.btn_save setTitle:@"保存" forState:UIControlStateNormal];
    [self.btn_save addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_save setTitleColor:RGBA(74, 74, 74, 1.0) forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn_save];
    self.navigationItem.rightBarButtonItem = backItem;
    self.btn_save.hidden = YES;

    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"infosetting" ofType:@"plist"];
    self.data = [[NSMutableArray  alloc] initWithContentsOfFile:plistPath];
    
    NSString *nicekname = [UserInfoManager readObjectByKey:ican_nickname];
    if (![NSString isBlankString:nicekname]) {
        [[[self.data objectAtIndex:1] objectAtIndex:0] setValue:nicekname forKey:@"desc"];
    }
    NSString *gender = [UserInfoManager readObjectByKey:ican_gender];
    if (![NSString isBlankString:gender]) {
        if ([gender isEqualToString:@"g"]) {
            gender = @"男";
        }
        if ([gender isEqualToString:@"l"]) {
            gender = @"女";
        }
        [[[self.data objectAtIndex:1] objectAtIndex:1] setValue:gender forKey:@"desc"];
    }
    NSString *birthday = [UserInfoManager readObjectByKey:ican_birthday];
    if (![NSString isBlankString:birthday]) {
        [[[self.data objectAtIndex:1] objectAtIndex:2] setValue:birthday forKey:@"desc"];
    }
    NSString *city = [UserInfoManager readObjectByKey:ican_address];
    if (![NSString isBlankString:city]) {
        [[[self.data objectAtIndex:1] objectAtIndex:3] setValue:city forKey:@"desc"];
    }
    self.olddata = [[NSMutableArray alloc] init];
    [self.olddata addObject:nicekname];
    [self.olddata addObject:gender];
    [self.olddata addObject:birthday];
    [self.olddata addObject:city];
}

#pragma mark -数据源方法
//这个方法用来告诉表格有几个分组
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.data count];
}

//这个方法告诉表格第section个分段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.data objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0 && row == 0) {
        return  80.0f;
    } else {
        return 50.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0f;
    }else {
        return 10.0f;
    }
    
}

//这个方法用来告诉某个分组的某一行是什么数据，返回一个UITableViewCel
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *groupedTableIdentifier = @"cell";
    UserInfoSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:groupedTableIdentifier];
    if (cell == nil) {
        cell = [[UserInfoSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:groupedTableIdentifier];
    }
    NSUInteger row = [indexPath row];
    NSArray *items = [self.data objectAtIndex:indexPath.section];
    NSDictionary *item = items[row];
    cell.textLabel.text = [item objectForKey:@"title"];
    NSString *icon = [item objectForKey:@"icon"];
    NSString *headpath = [UserInfoManager readObjectByKey:ican_headpath];
    if (![icon isEqualToString:@""]) {
        if ([NSString isBlankString:headpath]) {
            cell.imageView.image = [UIImage imageNamed:icon];
        } else {
//            NSURL *url = [NSURL URLWithString:[BaseUrlString stringByAppendingString:headpath]];
//            [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:icon]];
            [self loadHead:cell];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([NSString isBlankString:[item objectForKey:@"desc"]] &&  indexPath.section == 1) {
        cell.detailTextLabel.text = @"未设置";
    } else {
        cell.detailTextLabel.text = [item objectForKey:@"desc"];
    }
    return cell;
}

#pragma mark -actionsheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet isEqual:_locateView]) {
        LocationSheetView *locateView = (LocationSheetView *)actionSheet;
        IcLocation *location = locateView.locate;
        if(buttonIndex == 1) {
            NSString *values = [location.state stringByAppendingFormat:@"-%@",location.city];
            [[[self.data objectAtIndex:1] objectAtIndex:3] setValue:values forKey:@"desc"];
            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:3 inSection:1];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
            [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
            [self showSaveBtn];
        }
    } else if ([actionSheet isEqual:_datePickerView]){
        DatePickerSheetView *dateview = (DatePickerSheetView *)actionSheet;
        if(buttonIndex == 1) {
            NSString *date = dateview.selectedDate;
            [[[self.data objectAtIndex:1] objectAtIndex:2] setValue:date forKey:@"desc"];
            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:2 inSection:1];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
            [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
            [self showSaveBtn];
        }
    } else {
    
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
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

#pragma mark -UIImagePickerControllerDelegate 头像保存
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    _headImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [UIView animateWithDuration:0.5 animations:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [[self.tableView cellForRowAtIndexPath:indexPath].imageView setImage:_headImage];
    }];
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"保存头像";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSData *data = UIImageJPEGRepresentation(_headImage,0.5);
    NSDictionary *parameters = @{ican_mobile:mobile,ican_password:password};
    NSString *url = [BaseUrlString stringByAppendingFormat:@"headupload.do?mobile=%@&password=%@",mobile,password];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"item" fileName:@"item.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"00"]) {
            NSString *headpath = [responseObject objectForKey:ican_headpath];
            NSString *oldHeadPath = [UserInfoManager readObjectByKey:ican_headpath];
            [UserInfoManager updateWithObject:headpath forKey:ican_headpath];
            [[SDImageCache sharedImageCache] removeImageForKey:[BaseUrlString stringByAppendingString:oldHeadPath] fromDisk:YES];
            [[SDImageCache sharedImageCache] storeImage:self.headImage forKey:[BaseUrlString stringByAppendingString:headpath] toDisk:YES];
            [self toastsucess:self.view cotent:resultMsg];
            [[NSNotificationCenter defaultCenter] postNotificationName:loadhead object:nil];
        } else {
            [self loadHead:nil];
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:resultMsg
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        [self loadHead:nil];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",(long)error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:param
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"确定", nil];
        
        [alert show];
    }];
    
    
}

#pragma mark -tableview代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中高亮
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    if (indexPath.row < 2) {
        if ([_datePickerView isShow]) {
            [_datePickerView removeView];
        }
        if ([_locateView isShow]) {
            [_locateView removeView];
        }
    }
    

    if (indexPath.section == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"用户相册", nil];
        [actionSheet showInView:self.view];
    } else {
        switch (indexPath.row) {
            case 0:
                //昵称
            {
                NickNameViewController *nicknameCtrl = [[NickNameViewController alloc] init];
                nicknameCtrl.delegate = self;
                nicknameCtrl.titleStr = [[[self.data objectAtIndex:1] objectAtIndex:0] objectForKey:@"desc"];
                BaseNavigationController *sendNav = [[BaseNavigationController alloc] initWithRootViewController:nicknameCtrl];
                [self presentViewController:sendNav animated:YES completion:NULL];
                [self.navigationController popToViewController:nicknameCtrl animated:YES];
            }
                break;
            case 1:
                //性别
            {
                GenderViewController *genderCtrl = [[GenderViewController alloc] init];
                genderCtrl.delegate = self;
                genderCtrl.selSex = [[[self.data objectAtIndex:1] objectAtIndex:1] objectForKey:@"desc"];
                BaseNavigationController *sendNav = [[BaseNavigationController alloc] initWithRootViewController:genderCtrl];
                [self presentViewController:sendNav animated:YES completion:NULL];
                [self.navigationController popToViewController:genderCtrl animated:YES];
            }
                break;
            case 2:
                //生日
                if (_datePickerView == nil) {
                    _datePickerView = [[DatePickerSheetView alloc] initWithTitle:@"时间选择" delegate:self];
                }
                if ([_datePickerView isShow] == NO) {
                    [_datePickerView showInView:self.view];
                }
                if ([_locateView isShow]) {
                    [_locateView removeView];
                }
                break;
            case 3:
                //地区
                if (_locateView == nil) {
                    _locateView = [[LocationSheetView alloc] initWithTitle:@"城市选择" delegate:self];
                }
                if ([_locateView isShow] == NO) {
                    [_locateView showInView:self.view];
                }
                if ([_datePickerView isShow]) {
                    [_datePickerView removeView];
                }
                break;
            default:
                break;
        }
        
    }
    
    

}

#pragma mark - 子页面回调代理
-(void)selectedGender:(NSString *)values {
    [[[self.data objectAtIndex:1] objectAtIndex:1] setValue:values forKey:@"desc"];
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:1 inSection:1];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    [self showSaveBtn];
}

-(void)nickname:(NSString *)values {
    [[[self.data objectAtIndex:1] objectAtIndex:0] setValue:values forKey:@"desc"];
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:0 inSection:1];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    [self showSaveBtn];
}


#pragma mark - 监控保存按钮是否显示
- (void)showSaveBtn {
    BOOL is = NO;
    NSMutableArray *array = [self.data objectAtIndex:1];
    for (int i=0; i < array.count; i++) {
        NSString *str = [array[i] objectForKey:@"desc"];
        NSString *oldstr = self.olddata[i];
        if (![str isEqualToString:oldstr]) {
            is = YES;
            break;
        }
    }
    self.isSave = is;
    self.btn_save.hidden = !is;
}

#pragma mark - 提交数据
-(void)submitAction {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *nicename = [[[self.data objectAtIndex:1] objectAtIndex:0] objectForKey:@"desc"];
    NSString *gender = [[[self.data objectAtIndex:1] objectAtIndex:1] objectForKey:@"desc"];
    if ([gender isEqualToString:@"男"]) {
         gender = @"g";
    }
    if ([gender isEqualToString:@"女"]) {
        gender = @"l";
    }
    NSString *birthday = [[[self.data objectAtIndex:1] objectAtIndex:2] objectForKey:@"desc"];
    NSString *address = [[[self.data objectAtIndex:1] objectAtIndex:3] objectForKey:@"desc"];
    NSDictionary *parameters = @{@"mobile": [UserInfoManager readObjectByKey:ican_mobile],
                                 @"password":[UserInfoManager readObjectByKey:ican_password],
                                 @"nickname":nicename,
                                 @"gender":gender,
                                 @"birthday":birthday,
                                 @"address":address};
    
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在保存";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    
    [manager POST:[BaseUrlString stringByAppendingString:@"userupdate.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"00"]) {
            [UserInfoManager updateWithObject:nicename forKey:ican_nickname];
            [UserInfoManager updateWithObject:gender forKey:ican_gender];
            [UserInfoManager updateWithObject:birthday forKey:ican_birthday];
            [UserInfoManager updateWithObject:address forKey:ican_address];
            [self.olddata removeAllObjects];
            [self.olddata addObject:nicename];
            [self.olddata addObject:gender];
            [self.olddata addObject:birthday];
            [self.olddata addObject:address];
            self.btn_save.hidden = YES;
            self.isSave = NO;
            [self toastsucess:self.view cotent:resultMsg];
            
        } else {
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:resultMsg
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",(long)error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:param
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"确定", nil];
        
        [alert show];
    }];

}

#pragma mark - 系统返回按钮代理的捕获处理
-(BOOL)navigationShouldPopOnBackButton {
    if (self.isSave) {
        if (self.backalert == nil) {
            self.backalert  = [[UIAlertView alloc] initWithTitle: nil
                                                         message:@"是否放弃对资料的修改？"
                                                        delegate:self
                                               cancelButtonTitle:@"放弃"
                                               otherButtonTitles:@"继续编辑", nil];
        }
        [self.backalert show];
        return NO;
    }
    return YES;
}


#pragma mark - 当前页面所有弹出按钮事件处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:self.backalert]) {
        switch (buttonIndex) {
            case 0:
                //
                alertView.hidden = NO;
                [self.navigationController popViewControllerAnimated:YES];
                break;
            case 1:
                
                break;
            default:
                break;
        }
    }
}

#pragma mark - 加载头像
-(void)loadHead:(UITableViewCell *)cell {
    NSString *headpath = [UserInfoManager readObjectByKey:ican_headpath];
    NSURL *url = [NSURL URLWithString:[BaseUrlString stringByAppendingString:headpath]];
    if (cell == nil) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
    }
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"infosetting_header_default.png"]];
}


#pragma mark - 生命周期处理

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
