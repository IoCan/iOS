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

static NSString *kcellIdentifier = @"BenefitsCell";
static NSString *kheaderIdentifier = @"headerIdentifier";
static NSString *kfooterIdentifier = @"footerIdentifier";
@interface BenefitsViewController ()

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
    [_collectionView registerClass:[BenefitsCell class] forCellWithReuseIdentifier:kcellIdentifier];
    [_collectionView registerClass:[BenefitsFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterIdentifier];
}



#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
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
    if ([_collectionView isEqual:collectionView]) {
            BenefitsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[BenefitsCell alloc] initWithFrame:CGRectZero];
            }
            return cell;
    }
    return nil;
};

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BaseViewController *ctrl;
    NSLog(@"%ld",indexPath.row);
    switch (indexPath.row) {
        case 0:
            //
            break;
        case 5:
            ctrl = [[ConfirmOrderViewController alloc] init];
            break;
        default:
            break;
    }
    if (ctrl) {
        [self.navigationController pushViewController:ctrl animated:YES];
    }
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
