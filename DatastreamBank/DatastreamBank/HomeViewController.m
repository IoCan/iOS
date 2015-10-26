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

        //
        BaseViewController *vCtrl;
        switch (indexPath.row) {
            case 0:
                //好实惠
                vCtrl = [[BenefitsViewController alloc] init];
                break;
            case 1:
                vCtrl = [[FlowUnsubscribeViewController alloc] init];
                break;
            case 2:
                vCtrl = [[BtAcountViewController alloc] init];
                break;
            default:
                break;
        }
        if (vCtrl) {
            [self.navigationController pushViewController:vCtrl animated:YES];
            vCtrl = nil;
        }
    } else if([_collectionTwoView isEqual:collectionView]) {
        //
        [_collectionTwoView deselectItemAtIndexPath:indexPath animated:YES];
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
