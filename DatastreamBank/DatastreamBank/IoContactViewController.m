//
//  IoContactViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/14.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "IoContactViewController.h"
#import <AddressBook/AddressBook.h>
#import "IoContact.h"
#import "NSString+Phone.h"
#import "AuthorityHelper.h"
#import "AFHTTPRequestOperationManager.h"
#import "ApplyFriendsViewController.h"


@interface IoContactViewController ()
@property (nonatomic, assign) ABAddressBookRef addressBookRef;
@end

@implementation IoContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"通讯录";
        self.isAdd = NO;
        CFErrorRef error;
        _addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _top_view.layer.borderColor = RGBA(229, 229, 229, 1.0).CGColor;
    _top_view.layer.borderWidth = 0.8f;
    _top_view.layer.cornerRadius = _top_view.height/2;
    _top_view.clipsToBounds = YES;
    _txt_phone.delegate = self;
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无联系人";
    label.textColor = [UIColor lightGrayColor];
    label.tag = 10;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(ScreenWidth/2-100, _tableView.height/2-20, 200, 40);
    label.hidden = YES;
    [_tableView addSubview:label];
    [AuthorityHelper CheckAddressBookAuthorization:^(bool isAuthorized){
        if(isAuthorized)
        {
            ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getContactsFromAddressBook];
                    });
                }
            });
        }
        else
        {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的\"设置-隐私-通讯录\"中允许\"流量备胎\"访问通讯录。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
        }
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getContactsFromAddressBook
{
    CFErrorRef error = NULL;
    self.contacts = [[NSMutableArray alloc]init];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook) {
        NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        _contacts = [[NSMutableArray alloc] init];
        
        NSUInteger i = 0;
        for (i = 0; i<[allContacts count]; i++)
        {
            IoContact *contact = [[IoContact alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            contact.recordId = ABRecordGetRecordID(contactPerson);
            
            // Get first and last names
            NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            // Set Contact properties
            contact.firstName = firstName;
            contact.lastName = lastName;
            
            // Get mobile number
            ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            NSString *phone = [self getMobilePhoneProperty:phonesRef];
            NSString *tmp = [NSString formatPhoneNum:phone];
            if(phonesRef) {
                CFRelease(phonesRef);
            }
            
            // Get image if it exists
            NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
            contact.image = [UIImage imageWithData:imgData];
            if (!contact.image) {
                contact.image = [UIImage imageNamed:@"icon-avatar-60x60"];
            }
            
            if (tmp.length == 11 && [tmp hasPrefix:@"1"]) {
                contact.phone = phone;
                contact.showphone = tmp;
                [self.contacts addObject:contact];
            }
        }
        
        if(addressBook) {
            CFRelease(addressBook);
        }
        if (self.contacts.count == 0) {
            [_tableView viewWithTag:10].hidden = NO;
        } else {
            self.filteredContacts = self.contacts;
            [self.tableView reloadData];
        }
    }
    else
    {
        NSLog(@"Error");
        
    }
}


- (NSString *)getMobilePhoneProperty:(ABMultiValueRef)phonesRef {
    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if(currentPhoneLabel) {
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
            
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
        }
        if(currentPhoneLabel) {
            CFRelease(currentPhoneLabel);
        }
        if(currentPhoneValue) {
            CFRelease(currentPhoneValue);
        }
    }
    
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




#pragma mark - UITableView Delegate and Datasource functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filteredContacts.count;
}

- (CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IoContact *contact = [self.filteredContacts objectAtIndex:indexPath.row];
    static NSString *identify = @"IoContactCell";
    IoContactCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[IoContactCell alloc] initWithFrame:CGRectZero];
    }
    cell.label_name.text = [contact fullName];
    cell.phone = [contact phone];
    if(contact.image) {
        cell.img_head.image = contact.image;
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}


#pragma mark - cell代理 
-(void)click:(NSIndexPath *)indexPath {
    MyLog(@"===%ld",(long)indexPath.row);
    IoContact *user = [self.contacts objectAtIndex:indexPath.row];
    NSString *phone = [NSString formatPhoneNum:user.phone];
    if (self.isAdd) {
        [self fdapplyfor:phone];
    } else {
        if (self.delegate) {
            [self.delegate selectedPhone:phone];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 查询用户信息
-(void)fdapplyfor:(NSString *)fdmobile {
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"查询中";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    //根据号码查询注册信息 fdapplyfor.do
    //参数 mobile password fdmobile
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSString *password = [UserInfoManager readObjectByKey:ican_password];
    NSDictionary *parameters = @{ican_mobile:mobile,
                                 ican_password:password,
                                 @"fdmobile":fdmobile
                                 };
    [manager POST:[BaseUrlString stringByAppendingString:@"fdapplyfor.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        MyLog(@"%@",responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
        if ([result isEqualToString:@"00"]) {
            ApplyFriendsViewController *aCtrl = [[ApplyFriendsViewController alloc] init];
            aCtrl.isAdd = YES;
            NSString *fdmobile = [responseObject objectForKey:@"fdmobile"];
            NSString *headpath = [responseObject objectForKey:@"headpath"];
            NSString *nickname = [responseObject objectForKey:@"nickname"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:nickname forKey:@"nickname"];
            [dic setValue:headpath forKey:@"fdheadpath"];
            
            NSMutableDictionary *fdapplyfor = [[NSMutableDictionary alloc] init];
            [fdapplyfor setValue:fdmobile forKey:@"fdmobile"];
            [fdapplyfor setValue:@"N" forKey:@"fdStatus"];
            [dic setValue:fdapplyfor forKey:@"fdapplyfor"];
            [array addObject:dic];
            aCtrl.data = array;
            [self.navigationController pushViewController:aCtrl animated:YES];
        } else {
            [self alert:@"提示信息" msg:resultMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [toast hide:YES];
        NSString *param = [NSString stringWithFormat:@"请求错误码：%ld,%@",error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
        [self alert:@"提示信息" msg:param];
    }];
    
}


#pragma mark - UITextField代理
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([@"\n" isEqualToString:string] == YES) {
        [_txt_phone resignFirstResponder];
        return YES;
    }
    if ([_txt_phone isEqual:textField]) {
        if (string.length>0 && ![NSString isPureInt:string]) {
            return NO;
        }
        NSString *text = textField.text;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        if ([text isEqualToString:@""]){
            self.filteredContacts = self.contacts;
        } else {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@", @"phone", text];
            self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
        }
        [_tableView viewWithTag:10].hidden = (self.filteredContacts.count > 0);
        [self.tableView reloadData];
        
    }
    return YES;
}


- (IBAction)action_add:(id)sender {
    [_txt_phone resignFirstResponder];
    NSString *str = _txt_phone.text;
    if ([NSString isMobileNumber:str]) {
        if (self.isAdd) {
            [self fdapplyfor:str];
        } else {
            if (self.delegate) {
                [self.delegate selectedPhone:str];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self toast:self.view cotent:@"您输入的手机号格式不正确!"];
    }
}

 
@end
