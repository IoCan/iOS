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
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "HomeProgressView.h"
#import "HomeProgress2View.h"
#import "AFHTTPRequestOperationManager.h"
#import "MyScoreViewController.h"
#import "WebViewController.h"
#import "TestTbViewController.h"
#import "UserInfoDao.h"
#import "PresentFriendsViewController.h"
#import "MJRefresh.h"

#pragma mark - 系统首页
@interface HomeViewController ()

//当前选中页数
@property (assign) NSInteger currentPage;
@property(nonatomic,strong) AFHTTPRequestOperation *operation;
@property(nonatomic,strong) HomeProgressView *progressview;
@property(nonatomic,strong) HomeProgress2View *progressview2;
@property(nonatomic,strong) UIAlertView *obview;

@end

@implementation HomeViewController


#pragma nib初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"首页";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countMsNum:) name:countNum object:nil];
    }
    return self;
}

#pragma mark - 系统view初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [_collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:@"HomeCell"];
    [_collectionTwoView registerClass:[HomeTwoCell class] forCellWithReuseIdentifier:@"HomeTwoCell"];
    _contentScrollView.contentSize = CGSizeMake(ScreenWidth*2, 220);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self bindDelegte];
    [self initLocalData];
    [self initView];
    [self loaddata];
    [self loadUnReadMsgNum:nil];
    //更新本地数据
    [UserInfoDao updateLocalUserInfoFromService];
    //定时器 每60秒获取一次未读消息
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(loadUnReadMsgNum:) userInfo:nil repeats:YES];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddata)];
//    [self.scrollView.header beginRefreshing];
}

#pragma mark - 代理绑定
-(void)bindDelegte {
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionTwoView.dataSource = self;
    _collectionTwoView.delegate = self;
    _contentScrollView.delegate = self;
}

#pragma mark - 初始化本地数据
-(void)initLocalData {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"home_item1" ofType:@"plist"];
    _data = [[NSMutableArray  alloc] initWithContentsOfFile:plistPath];
    plistPath = [bundle pathForResource:@"home_item2" ofType:@"plist"];
    _datatwo = [[NSMutableArray  alloc] initWithContentsOfFile:plistPath];
}

#pragma mark - 加载动态页面
-(void)initView {
    _progressview = [[HomeProgressView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
    _progressview2 = [[HomeProgress2View alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth, 220)];
    @try {
        float already = [[UserInfoManager readObjectByKey:@"already"] floatValue];
        float total = [[UserInfoManager readObjectByKey:@"total"] floatValue];
        float left = total - already;
        float pre = left/total;
        [_progressview setFlow:left];
        _progressview.initprogress = isnan(pre)?0.0f:pre;
        [_progressview2 setFlow:[[UserInfoManager readObjectByKey:ican_virtualflow] integerValue]];
    }
    @catch (NSException *exception) {
        
    }
    [_contentScrollView addSubview:_progressview];
    [_contentScrollView addSubview:_progressview2];
}

#pragma mark - 服务窗的消息数量监听
-(void)countMsNum:(NSNotification *)notification{
    @try {
        NSMutableDictionary *dic = notification.object;
        int count = [[dic objectForKey:@"count"] intValue];
        NSString *num = [self fomatNum:count];
        RDVTabBarItem *item = [self rdv_tabBarController].tabBar.items[1];
        NSString *method = [dic objectForKey:@"method"];
        if ([method isEqualToString:@"fg"]) {
            
        } if ([method isEqualToString:@"js"]) {
            int current = [item.badgeValue intValue];
            if (current > 0) {
                current = current-1;
            }
            num = [self fomatNum:current];
        }
        [item setBadgeValue:num];
        [item setBadgeTextFont:[UIFont systemFontOfSize:10]];
    }
    @catch (NSException *exception) {
        MyLog(@"%@",exception.description);
    }
    @finally {
        
    }
}

-(NSString *) fomatNum:(int)count{
    NSString *num;
    if (count == 0) {
        num = @"";
    } else if (count < 99 && count>0) {
        num = [NSString stringWithFormat:@"%d",count];
    } else {
        num = @"··";
    }
    return num;
}

#pragma mark - 访问流量相关数据
-(void)loaddata {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                                 ican_password:[UserInfoManager readObjectByKey:ican_password]};
    //**********************总套餐内流量查询************************//
    self.operation = [manager POST:[BaseUrlString stringByAppendingString:@"flowmainquery.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            float already = [[responseObject objectForKey:@"already"] floatValue];
            float total = [[responseObject objectForKey:@"total"] floatValue];
            float left = total - already;
            float pre = left/total;
            [_progressview updateProgress:isnan(pre)?0.0f:pre];
            [_progressview setFlow:(int)left];
            [UserInfoManager saveDic:responseObject];
            NSString *resultMsg = [responseObject objectForKey:@"resultMsg"];
            if (resultMsg) {
                [self toast:self.view cotent:resultMsg];
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
            [self.scrollView.header endRefreshing];
        }
        
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [self.scrollView.header endRefreshing];
    }];
    
     //**********************备胎剩余流量查询************************//
    parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                   ican_password:[UserInfoManager readObjectByKey:ican_password]};
    [manager POST:[BaseUrlString stringByAppendingString:@"virtualflowquery.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSInteger left = [[responseObject objectForKey:@"virtualflow"] integerValue];
            [UserInfoManager updateWithObject:[responseObject objectForKey:@"virtualflow"] forKey:ican_virtualflow];
            [self.progressview2 setFlow:left];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
            [self.scrollView.header endRefreshing];
        }
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.scrollView.header endRefreshing];
    }];

}


-(void)loadUnReadMsgNum:(NSTimer *) timer{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                                 ican_password:[UserInfoManager readObjectByKey:ican_password]};
    //**********************未读信息总数量查询************************//
    parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                   ican_password:[UserInfoManager readObjectByKey:ican_password],
                   @"type":@""};
    [manager POST:[BaseUrlString stringByAppendingString:@"msgcount.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSString *result = [responseObject objectForKey:@"result"];
            if ([@"00" isEqualToString:result]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
                [dic setValue:@"fg" forKey:@"method"];
                [[NSNotificationCenter defaultCenter] postNotificationName:countNum object:dic];

            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    //**********************未读系统信息数量查询************************//
    parameters = @{ican_mobile:[UserInfoManager readObjectByKey:ican_mobile],
                   ican_password:[UserInfoManager readObjectByKey:ican_password],
                   @"type":@"system"};
    [manager POST:[BaseUrlString stringByAppendingString:@"msgcount.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSString *result = [responseObject objectForKey:@"result"];
            if ([@"00" isEqualToString:result]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
                [dic setValue:@"fg" forKey:@"method"];
                [[NSNotificationCenter defaultCenter] postNotificationName:sysNum object:dic];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    //**********************未读系统信息数量查询************************//
    parameters = @{ican_mobile:[UserInfoManager readObjectByKey:ican_mobile],
                   ican_password:[UserInfoManager readObjectByKey:ican_password],
                   @"type":@"betai"};
    [manager POST:[BaseUrlString stringByAppendingString:@"msgcount.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSString *result = [responseObject objectForKey:@"result"];
            if ([@"00" isEqualToString:result]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
                [dic setValue:@"fg" forKey:@"method"];
                [[NSNotificationCenter defaultCenter] postNotificationName:btNum object:dic];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

- (CAGradientLayer *)shadowAsInverse {
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
                vCtrl = [[PresentFriendsViewController alloc] init];
                break;
            case 3:
                //游乐场
                if (self.obview == nil) {
                    self.obview  = [[UIAlertView alloc] initWithTitle: @"⚠"
                                                                    message:@"抱歉，该功能正在建设中..."
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"确定", nil];
                }
                [self.obview show];
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
                 vCtrl = [[BtAcountViewController alloc] init];
                break;
            case 1:
                //积分优惠
                vCtrl =  [[MyScoreViewController alloc] init];
                break;
            case 2:
                //注册好礼
                vCtrl = [[WebViewController alloc] initWithUrl:@"http://jsurl.huilongkj.com/js/151027fkbt/index1.html"];
                break;
            case 3:
                //首订红包
                vCtrl = [[WebViewController alloc] initWithUrl:@"http://jsurl.huilongkj.com/js/151027fkbt/2.html"];
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



#pragma mark -scrollView的代理方法


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if ([_scrollView isEqual:scrollView] && _isShow != self.navigationController.isNavigationBarHidden) {
//        CGFloat contentOffsetY = _scrollView.contentOffset.y;
//        if (contentOffsetY > ScreenHeight/3) {
//             _isShow = YES;
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//        }
//        else if (contentOffsetY < 40) {
//            _isShow = NO;
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//        }
//        return;
//    }
    
    if ([_contentScrollView isEqual:scrollView]) {
        CGRect frame = _slideView.frame;
        frame.origin.x = scrollView.contentOffset.x/2+(ScreenWidth/2-_slideView.width)/2;
        _slideView.frame = frame;
    }

}



#pragma mark －生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    NSInteger left = [[UserInfoManager readObjectByKey:ican_virtualflow] integerValue];
    [self.progressview2 setFlow:left];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:countNum object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -按钮事件处理
- (IBAction)action_tnf:(id)sender {
     [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)action_btf:(id)sender {
     [_contentScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
}
 @end
