//
//  BenefitsViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BenefitsViewController.h"
#import "BenefitsCell.h"
#import "HomeViewController.h"
#import "BenefitsFootView.h"
#import "BtAcountViewController.h"
#import "BtFlowDetailsViewController.h"
#import "ConfirmOrderViewController.h"
#import "AFHTTPRequestOperationManager.h"

static NSString *kcellIdentifier = @"BenefitsCell";
static NSString *kheaderIdentifier = @"headerIdentifier";
static NSString *kfooterIdentifier = @"footerIdentifier";
@interface BenefitsViewController ()
@property(nonatomic,strong) AFHTTPRequestOperation *operation;
@end

@implementation BenefitsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"好实惠";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *plistPath = [bundle pathForResource:@"Benefits" ofType:@"plist"];
//    _data = [[NSMutableArray  alloc] initWithContentsOfFile:plistPath];
    [_collectionView registerClass:[BenefitsCell class] forCellWithReuseIdentifier:kcellIdentifier];
    [_collectionView registerClass:[BenefitsFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterIdentifier];
    _collectionView.hidden = YES;
    [self loaddata];
}


-(void)loaddata {
    MBProgressHUD *toast = [[MBProgressHUD alloc] initWithView:self.view];
    toast.labelText = @"正在加载";
    toast.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:toast];
    [toast show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                                 ican_password:[UserInfoManager readObjectByKey:ican_password]};
    self.operation = [manager POST:[BaseUrlString stringByAppendingString:@"virtualmealquery.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [toast hide:YES];
        @try {
//                      NSLog(@"%@",responseObject);
            
            NSString *result = [responseObject objectForKey:@"result"];
            if ([@"00" isEqualToString:result]) {
                 _collectionView.hidden = NO;
                _data = [responseObject objectForKey:@"resultList"];
                [_collectionView reloadData];
            } else {
                NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
                [self toast:self.view cotent:resultMsg];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
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


#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _data.count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ScreenWidth/2, 120);
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 140);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    BenefitsFootView *view;
    if (kind == UICollectionElementKindSectionFooter) {
       view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kfooterIdentifier forIndexPath:indexPath];
    }
    return view;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 0, 0, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BenefitsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BenefitsCell alloc] initWithFrame:CGRectZero];
    }
    NSDictionary *item = [self.data objectAtIndex:indexPath.row];
    NSInteger flow = [[item objectForKey:@"flow"] integerValue];
    NSInteger price = [[item objectForKey:@"price"] integerValue];
    float floatValue = price/(float)flow;
    NSString *strValue=[NSString stringWithFormat:@"%0.3f", floatValue];
    cell.label_title.text = [@"1M=" stringByAppendingString:strValue];
    cell.label_desc.text = [NSString stringWithFormat:@"%ld元%ldM",price,flow];
    return cell;
    
};

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ConfirmOrderViewController * ctrl = [[ConfirmOrderViewController alloc] init];
    ctrl.dic = [_data objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ctrl animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
