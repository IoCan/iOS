//
//  BtAcountViewController.m
//  DatastreamBank
//  首页模块-备胎账户
//  Created by OsnDroid on 15/10/23.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BtAcountViewController.h"
#import "BtAcountCell.h"
#import "BtAcountHeadView.h"
#import "UIViewExt.h"
#import "BtFlowDetailsViewController.h"
#import "BenefitsViewController.h"
#import "FlowUnsubscribeViewController.h"
#import "RechargeViewController.h"
#import "TimingRechargeViewController.h"
#import "MyOrderViewController.h"

static NSString *kcellIdentifier = @"BtAcountCell";
static NSString *kheaderIdentifier = @"headerIdentifier";
static NSString *kfooterIdentifier = @"footerIdentifier";
@interface BtAcountViewController ()

@end

@implementation BtAcountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"备胎账户";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [_collectionView registerClass:[BtAcountCell class] forCellWithReuseIdentifier:kcellIdentifier];
    [_collectionView registerClass:[BtAcountHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"btacount" ofType:@"plist"];
    _data = [[NSMutableArray  alloc] initWithContentsOfFile:plistPath];
}



#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _data.count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ScreenWidth/2, 90);
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 100);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    BtAcountHeadView *view;
    if (kind == UICollectionElementKindSectionHeader) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kheaderIdentifier forIndexPath:indexPath];
    }
    return view;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BtAcountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BtAcountCell alloc] initWithFrame:CGRectZero];
    }
    cell.layer.borderWidth = 0.3;
    cell.layer.borderColor = RGBA(242, 242, 242, 1.0).CGColor;
    NSDictionary *items = [self.data objectAtIndex:indexPath.row];
    NSString *icon = [items objectForKey:@"icon"];
    NSString *title = [items objectForKey:@"title"];
    NSString *desc = [items objectForKey:@"desc"];
    NSString *state = [items objectForKey:@"state"];
    
    NSString *content;
    if ([state isEqualToString:@""]) {
        content = [[[[title stringByAppendingString:@"\n"] stringByAppendingString:state] stringByAppendingString:@""] stringByAppendingString:desc];
    } else {
        content = [[[[title stringByAppendingString:@"\n"] stringByAppendingString:state] stringByAppendingString:@"\n"] stringByAppendingString:desc];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4];
    [str addAttribute:NSForegroundColorAttributeName value:RGBA(72, 72, 72, 1.0) range:NSMakeRange(0,title.length)];
    [str addAttribute:NSForegroundColorAttributeName value:RGBA(170, 170, 170, 1.0) range:NSMakeRange(title.length+1,state.length)];
    [str addAttribute:NSForegroundColorAttributeName value:RGBA(0, 160, 191, 1.0) range:NSMakeRange(content.length-desc.length,desc.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:14.0] range:NSMakeRange(title.length+1,state.length)];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    cell.labe_title.attributedText = str;
    cell.img_icon.image = [UIImage imageNamed:icon];
    return cell;
};

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BaseViewController *ctrl;
    switch (indexPath.row) {
        case 0:
            //冲进手机账户
            ctrl = [[RechargeViewController alloc] init];
            break;
        case 1:
            // 定时生效
            ctrl = [[TimingRechargeViewController alloc] init];
            break;
        case 2:
            //充值备胎流量
            ctrl = [[BenefitsViewController alloc] init];
            break;
        case 3:
            //赠送给TA
            break;
        case 4:
            //流量用不完
            ctrl = [[FlowUnsubscribeViewController alloc] init];
            break;
        case 5:
            ctrl = [[MyOrderViewController alloc] init];
            break;
        default:
            break;
    }
    if (ctrl) {
        [self.navigationController pushViewController:ctrl animated:YES];
        ctrl = nil;
    }
}


@end
