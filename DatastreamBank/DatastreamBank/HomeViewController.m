//
//  HomeViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/9/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "HomeViewController.h"
#import "UIButton+IcUIButton.h"
#import "HomeCell.h"
#import "HomeTwoCell.h"
#import "BenefitsViewController.h"
#import "BaseNavigationController.h"
#import "BtAcountViewController.h"
#import "FlowUnsubscribeViewController.h"
#import "RechargeViewController.h"
#import "TimingRechargeViewController.h"

@interface HomeViewController ()
@property (assign) BOOL isShow;

@end

@implementation HomeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"首页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isShow = YES;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"home_item1" ofType:@"plist"];
    _data = [[NSMutableArray  alloc] initWithContentsOfFile:plistPath];
    plistPath = [bundle pathForResource:@"home_item2" ofType:@"plist"];
    _datatwo = [[NSMutableArray  alloc] initWithContentsOfFile:plistPath];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionTwoView.dataSource = self;
    _collectionTwoView.delegate = self;
    [_collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:@"HomeCell"];
    [_collectionTwoView registerClass:[HomeTwoCell class] forCellWithReuseIdentifier:@"HomeTwoCell"];
    _view1.layer.cornerRadius = _view1.width/2;


    _view1.layer.shadowColor = [UIColor whiteColor].CGColor;
    _view1.layer.shadowOffset = CGSizeMake(10, 10);
    _view1.layer.shadowOpacity = 0.3;
    _view1.layer.shadowRadius = _view1.width/2+50;
    _view1.clipsToBounds = YES;

    
    
    _view2.layer.cornerRadius = _view2.width/2;
//    
//    _view2.layer.shadowColor = [UIColor whiteColor].CGColor;
//    _view2.layer.shadowOffset = CGSizeMake(10, 10);
//    _view2.layer.shadowOpacity = 0.3;
//    _view2.layer.shadowRadius = _view1.width/2+50;
    _view2.clipsToBounds = YES;
    
    
    _view3.layer.cornerRadius = _view3.width/2;
    _view3.layer.shadowColor = [UIColor redColor].CGColor;
    _view3.layer.shadowOffset = CGSizeMake(50, 50);
    _view3.clipsToBounds = YES;
    
    self.progress.progressColor = RGBA(54, 246, 226, 0.3);
    
    self.progress.lineWidth = 30;
    
    //set CircularProgressView delegate
    self.progress.progress = 0.7;


   
}

- (CAGradientLayer *)shadowAsInverse
{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = CGRectMake(0, 0, 200, 200);
    newShadow.frame = newShadowFrame;
    //添加渐变的颜色组合
    newShadow.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor blackColor].CGColor,nil];
    return newShadow;
}

#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count;
    if ([_collectionView isEqual:collectionView]) {
        count = _data.count;
    }
    else if([_collectionTwoView isEqual:collectionView]){
        count = _datatwo.count;
    }
    return count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    if ([_collectionView isEqual:collectionView]) {
        size = CGSizeMake(ScreenWidth/4, 89);
    }
    else if([_collectionTwoView isEqual:collectionView]){
        size = CGSizeMake(ScreenWidth/2, 90);
    }
    return size;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets edge;
    if ([_collectionView isEqual:collectionView]) {
        edge = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else if([_collectionTwoView isEqual:collectionView]){
        edge = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return edge;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_collectionView isEqual:collectionView]) {
        static NSString *identify = @"HomeCell";
        HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[HomeCell alloc] initWithFrame:CGRectZero];
        } 
        NSDictionary *items = [self.data objectAtIndex:indexPath.row];
        cell.label.text = [items objectForKey:@"title"];
        [cell.btn setImage:[UIImage imageNamed:[items objectForKey:@"icon"]] forState:UIControlStateNormal];
        return cell;
    }
    else if([_collectionTwoView isEqual:collectionView]){
        static NSString *identify = @"HomeTwoCell";
        HomeTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[HomeTwoCell alloc] initWithFrame:CGRectZero];
        }
        cell.layer.borderWidth = 0.3;
        cell.layer.borderColor = RGBA(242, 242, 242, 1.0).CGColor;
        NSDictionary *items = [self.datatwo objectAtIndex:indexPath.row];
        cell.label_desc.text = [items objectForKey:@"desc"];
        cell.label_title.text = [items objectForKey:@"title"];
        [cell.img_icon setImage:[UIImage imageNamed:[items objectForKey:@"icon"]]];
        return cell;
    }
    return nil;
};

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_collectionView isEqual:collectionView]) {
        [_collectionView deselectItemAtIndexPath:indexPath animated:YES];
        BaseViewController *vCtrl;
        switch (indexPath.row) {
            case 0:
                //好实惠
                vCtrl = [[BenefitsViewController alloc] init];
                break;
            case 1:
                //退流量
                vCtrl = [[FlowUnsubscribeViewController alloc] init];
                break;
            case 2:
                //送好友
                vCtrl = [[BtAcountViewController alloc] init];
                break;
            case 3:
                //游乐场
                
                break;
            default:
                break;
        }
        if (vCtrl) {
            [self.navigationController pushViewController:vCtrl animated:YES];
            vCtrl = nil;
        }
    } else if([_collectionTwoView isEqual:collectionView]) {
        [_collectionTwoView deselectItemAtIndexPath:indexPath animated:YES];
        BaseViewController *vCtrl;
        switch (indexPath.row) {
            case 0:
                //备胎流量
                break;
            case 1:
                //积分优惠
                break;
            case 2:
                //注册好礼
                break;
            case 3:
                //首订红包
                break;
            case 4:
                //充手机账户
                vCtrl = [[RechargeViewController alloc] init];
                break;
            case 5:
                vCtrl = [[TimingRechargeViewController alloc] init];
                //定时生效
                break;
            default:
                break;
        }
        if (vCtrl) {
            [self.navigationController pushViewController:vCtrl animated:YES];
            vCtrl = nil;
        }
    }
   
}



#pragma mark -- scrollView的代理方法
-(void) modifyTopScrollViewPositiong: (UIScrollView *) scrollView{
    
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_scrollView isEqual:scrollView] && _isShow != self.navigationController.isNavigationBarHidden) {
        CGFloat contentOffsetY = _scrollView.contentOffset.y;
        if (contentOffsetY > ScreenHeight/3) {
             _isShow = YES;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
        else if (contentOffsetY < 40) {
            _isShow = NO;
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
        return;
    }

}

///拖拽后调用的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    [self modifyTopScrollViewPositiong:scrollView];
    //     NSLog(@"scrollViewDidEndDragging....");
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

 @end
