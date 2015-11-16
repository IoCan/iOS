//
//  SegTabBarView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/17.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "SegTabBarView.h"
#import "MessageCell.h"
#import "UserInfoDao.h"
#import "NSString+Phone.h"
#import "MyOrderViewController.h"
#import "ApplyFriendsViewController.h"
#import "TimingRechargeViewController.h"
#import "RechargeViewController.h"
#import "BtFlowDetailsViewController.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperationManager.h"
#import "PresentViewController.h"
#import "BenefitsViewController.h"

@interface SegTabBarView ()

///顶部topScrollView下面滑动的View
@property (strong, nonatomic) UIView *slideView;
//上方的ScrollView
@property (strong, nonatomic) UIScrollView *topScrollView;
//上方的view
@property (strong, nonatomic) UIView *topMainView;
//页面总页面数
@property (assign) NSInteger tabCount;
//下方容器的ScrollView
@property (strong, nonatomic) UIScrollView *scrollView;

//@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) NSArray *items;

@end

@implementation SegTabBarView

-(instancetype)initWithFrame:(CGRect)frame WithArray: (NSMutableArray *)items{
    self = [super initWithFrame:frame];
    
    if (self) {
        _topItems = items;
        _tabCount = items.count;
        _topViews = [[NSMutableArray alloc] init];
        _scrollTableViews = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countBtNum:) name:btNum object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countSysNum:) name:sysNum object:nil];
    }
    
    return self;
}

-(void)layoutSubviews {
   
    self.items = [[NSArray alloc] initWithObjects:@"消息通知",@"备胎消息",@"优惠消息",nil];
    [self initScrollView];
    
    [self initTopTabs];
    
    [self initDownTables];
    
    [self initSlideView];
    
    [self initDataSource];
}



-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.state != 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark -- 初始化滑动的指示View
-(void) initSlideView{
    CGFloat width = self.frame.size.width / default_count;
    if(self.tabCount <= default_count){
        width = self.frame.size.width / self.tabCount;
    }
    _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, default_topview_height - default_sildeview_height, width, default_sildeview_height)];
    [_slideView setBackgroundColor:default_selected_titlecolor];
    UIButton *btn = (UIButton *)[_topScrollView viewWithTag:1];
    [btn setTitleColor:default_selected_titlecolor forState:UIControlStateNormal];
    [_topScrollView addSubview:_slideView];
}


#pragma mark -- 初始化表格的数据源
-(void) initDataSource{
    _dataSource = [[NSMutableArray alloc] initWithCapacity:_tabCount];
    [_dataSource addObject:_data];
    [_dataSource addObject:_btdata];
    [_dataSource addObject:_yhdata];
}


#pragma mark * UIPanGestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //    NSString *str = [NSString stringWithUTF8String:object_getClassName(gestureRecognizer)];
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}

#pragma mark -- 实例化ScrollView
-(void) initScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, default_topview_height, self.frame.size.width, self.frame.size.height - default_topview_height-49-64)];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * _tabCount, self.frame.size.height - default_topview_height-64-49);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    [self addSubview:_scrollView];
}



#pragma mark -- 实例化顶部的tab
-(void) initTopTabs{
    CGFloat width = self.frame.size.width / default_count;
    if(self.tabCount <= default_count){
        width = self.frame.size.width / self.tabCount;
    }
    _topMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, default_topview_height)];
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, default_topview_height+1)];
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = YES;
    _topScrollView.bounces = NO;
    _topScrollView.delegate = self;
    if (_tabCount >= default_count) {
        _topScrollView.contentSize = CGSizeMake(width * _tabCount, default_topview_height);
    } else {
        _topScrollView.contentSize = CGSizeMake(self.frame.size.width, default_topview_height);
    }
    
    [self addSubview:_topMainView];
    [_topMainView addSubview:_topScrollView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, default_topview_height, ScreenWidth, 1)];
    view.backgroundColor = RGBA(238, 238, 238, 1.0);
    [_topScrollView addSubview:view];
    UIColor *defaultColor = RGBA(246, 246, 246, 1);
    for (int i = 0; i < _tabCount; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, default_topview_height)];
        view.backgroundColor = defaultColor;
        view.tag = 11+i;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, default_topview_height)];
        button.tag = i+1;
        [button setTitle:[NSString stringWithFormat:_topItems[i], i+1] forState:UIControlStateNormal];
        [button setTitleColor:default_normal_titlecolor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((width - 22), 8, default_badgelabel_wh, default_badgelabel_wh)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor redColor];
        label.tag = i+100;
        label.layer.cornerRadius = default_badgelabel_wh/2;
        label.clipsToBounds = YES;
        label.hidden = YES;
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        [_topViews addObject:view];
        [_topScrollView addSubview:view];
    }
    //label 100 101 102 父节点
    UIView *tmpView = [_topScrollView viewWithTag:11];
    UILabel *label1 = (UILabel *)[tmpView viewWithTag:100];
    tmpView = [_topScrollView viewWithTag:12];
    UILabel *label2 = (UILabel *)[tmpView viewWithTag:101];
    tmpView = [_topScrollView viewWithTag:13];
    UILabel *label3 = (UILabel *)[tmpView viewWithTag:102];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@", @"sm.msgStatus", @"N"];

    NSArray *tmpdata = [_data filteredArrayUsingPredicate:predicate];
    NSArray *tmpbtdata = [_btdata filteredArrayUsingPredicate:predicate];
    NSArray *tmpyhdata = [_yhdata filteredArrayUsingPredicate:predicate];
    
    
    label1.hidden = (tmpdata.count == 0);
    label1.text = [NSString stringWithFormat:@"%ld",tmpdata.count];
    
    label2.hidden = (tmpbtdata.count == 0);
    label2.text = [NSString stringWithFormat:@"%ld",tmpbtdata.count];
    
    label3.hidden = (tmpyhdata.count == 0);
    label3.text = [NSString stringWithFormat:@"%ld",tmpyhdata.count];
    
}



#pragma mark --点击顶部的按钮所触发的方法
-(void) tabButton: (id) sender{
    UIButton *button = sender;
    [_scrollView setContentOffset:CGPointMake((button.tag-1) * self.width, 0) animated:YES];
}

#pragma mark --初始化下方的TableViews
-(void) initDownTables{
    
    for (int i = 0; i < 3; i ++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * self.width, 0, self.width, self.height - default_topview_height - 49 - 64)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i;
        if (i<2) {
            tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddata)];
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.text = [@"暂无" stringByAppendingString:_topItems[i]];
        label.textColor = [UIColor lightGrayColor];
        label.tag = 10+i;
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(ScreenWidth/2-100+i*self.width, tableView.height/2-20, 200, 40);
        label.hidden = YES;
        tableView.hidden = YES;
        [_scrollTableViews addObject:tableView];
        [_scrollView addSubview:tableView];
        [_scrollView insertSubview:label aboveSubview:tableView];
    }
    
    //文字提示无数据
    [_scrollView viewWithTag:10].hidden = (_data.count > 0);
    [_scrollView viewWithTag:11].hidden = (_btdata.count > 0);
    [_scrollView viewWithTag:12].hidden = (_yhdata.count > 0);
    
}

#pragma mark - 刷新数据
-(void)loaddata {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                                 ican_password:[UserInfoManager readObjectByKey:ican_password]};
    
    //**********************消息查询************************//
    parameters = @{ican_mobile: [UserInfoManager readObjectByKey:ican_mobile],
                   ican_password:[UserInfoManager readObjectByKey:ican_password],
                   @"today":@""};
    [manager POST:[BaseUrlString stringByAppendingString:@"sysmessagequery.do"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSString *result = [responseObject objectForKey:@"result"];
            if ([@"00" isEqualToString:result]) {
                NSArray *array  = [responseObject objectForKey:@"resultlist"];
                NSMutableArray *marray = [[NSMutableArray alloc] initWithArray:array];
                NSPredicate *predicate;
                if (_currentPage == 0) {
                    predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@", @"sm.type", @"sysinfo"];
                } else if (_currentPage == 1) {
                    predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@", @"sm.type", @"btinfo"];
                }
                NSArray *s = [marray filteredArrayUsingPredicate:predicate];
                NSMutableArray *b = [[NSMutableArray alloc] initWithArray:s];
                [_dataSource setObject:b atIndexedSubscript:_currentPage];
                UITableView *reuseTableView = _scrollTableViews[_currentPage];
                [reuseTableView.header endRefreshing];
                [reuseTableView reloadData];
                UIView *tmpView = [_topScrollView viewWithTag:(11+_currentPage)];
                UILabel *label = (UILabel *)[tmpView viewWithTag:(100+_currentPage)];
                 
                NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@", @"sm.msgStatus", @"N"];
                NSArray *tmpdata = [_dataSource[_currentPage] filteredArrayUsingPredicate:predicate2];
                label.hidden = (tmpdata.count == 0);
                label.text = [NSString stringWithFormat:@"%ld",tmpdata.count];
                
                NSMutableDictionary *fsdic = [[NSMutableDictionary alloc] init];
                UIView *tmpView11 = [_topScrollView viewWithTag:(11)];
                UILabel *label11 = (UILabel *)[tmpView11 viewWithTag:(100)];
                
                UIView *tmpView12 = [_topScrollView viewWithTag:(12)];
                UILabel *label12 = (UILabel *)[tmpView12 viewWithTag:(101)];
                int a = 0;
                if (!label11.hidden) {
                    a = a+[label11.text intValue];
                }
                if (!label12.hidden) {
                    a = a+[label12.text intValue];
                }
                [fsdic setValue:[NSString stringWithFormat:@"%d",a] forKey:@"count"];
                [fsdic setValue:@"fg" forKey:@"method"];
                [[NSNotificationCenter defaultCenter] postNotificationName:countNum object:fsdic];
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


#pragma mark --根据scrollView的滚动位置复用tableView，减少内存开支
-(void) updateTableWithPageNumber: (NSUInteger) pageNumber{
    int tabviewTag = pageNumber % 3;
    CGRect tableNewFrame = CGRectMake(pageNumber * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height - default_topview_height-64-49);
    UITableView *reuseTableView = _scrollTableViews[tabviewTag];
    reuseTableView.frame = tableNewFrame;
    [reuseTableView reloadData];
}


#pragma mark -- scrollView的代理方法
-(void) modifyTopScrollViewPositiong: (UIScrollView *) scrollView{
    if ([_topScrollView isEqual:scrollView]) {
        CGFloat contentOffsetX = _topScrollView.contentOffset.x;
        CGFloat width = _slideView.frame.size.width;
        int count = (int)contentOffsetX/(int)width;
        CGFloat step = (int)contentOffsetX%(int)width;
        CGFloat sumStep = width * count;
        if (step > width/2) {
            sumStep = width * (count + 1);
        }
//        NSLog(@"modifyTopScrollViewPositiong---%d",count);
        [_topScrollView setContentOffset:CGPointMake(sumStep, 0) animated:YES];
        return;
    }
    
}

///拖拽后调用的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //[self modifyTopScrollViewPositiong:scrollView];
//     NSLog(@"scrollViewDidEndDragging....");
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UIButton *btn = (UIButton *)[_topScrollView viewWithTag:_currentPage+1];
   

    if ([scrollView isEqual:_scrollView]) {
         [btn setTitleColor:default_normal_titlecolor forState:UIControlStateNormal];
        _currentPage = _scrollView.contentOffset.x/self.frame.size.width;
        _currentPage = _scrollView.contentOffset.x/self.frame.size.width;

        //    UITableView *currentTable = _scrollTableViews[_currentPage];
        //    [currentTable reloadData];
        [self updateTableWithPageNumber:_currentPage];
        UIButton *btn = (UIButton *)[_topScrollView viewWithTag:_currentPage+1];
        [btn setTitleColor:default_selected_titlecolor forState:UIControlStateNormal];
       
        return;
    }
    [self modifyTopScrollViewPositiong:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if ([_scrollView isEqual:scrollView]) {
        CGRect frame = _slideView.frame;
        if (self.tabCount <= default_count) {
            frame.origin.x = scrollView.contentOffset.x/_tabCount;
        } else {
            frame.origin.x = scrollView.contentOffset.x/default_count;
        }
        _slideView.frame = frame;
    }
    
}





#pragma mark -- talbeView的代理方法
//先要设Cell可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     if(indexPath.row ==0)
     {
     [tableView setEditing:YES animated:YES];  //这个是整体出现
     }
     */
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"touchIIddddd");
    [_dataSource[_currentPage] removeObjectAtIndex:indexPath.row];
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    UITableView *reuseTableView = _scrollTableViews[_currentPage];
    [reuseTableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
    /*
     if(indexPath ==0)
     {
     [tableView setEditing:NO animated:YES];
     }
     */
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *tempArray = _dataSource[_currentPage];
    return tempArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 101;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消选中高亮
    [_scrollTableViews[_currentPage] deselectRowAtIndexPath:[_scrollTableViews[_currentPage] indexPathForSelectedRow] animated:YES];
    NSDictionary *dic  = _dataSource[_currentPage][indexPath.row];
    NSDictionary *sm = [dic objectForKey:@"sm"];
    NSString *msgid = [sm objectForKey:@"id"];
    NSString *msgStatus = [sm objectForKey:@"msgStatus"];
//    MyLog(@"%@",dic);
    if ([msgStatus isEqualToString:@"N"]) {
        ///**********发送广播***********///
        NSMutableDictionary *fsdic = [[NSMutableDictionary alloc] init];
        [fsdic setValue:@"1" forKey:@"count"];
        [fsdic setValue:@"js" forKey:@"method"];
        [[NSNotificationCenter defaultCenter] postNotificationName:countNum object:fsdic];
        if (_currentPage == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:sysNum object:fsdic];
        } else if(_currentPage == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:btNum object:fsdic];
        }
        //*********请求网络修改状态********//
        [UserInfoDao updateUnReadInfoToService:@"Y" parameters:msgid success:^(NSString *msgid, id responseObject) {
            MyLog(@"%@-%@",msgid,[responseObject objectForKey:@"resultMsg"]);
            NSString *result = [responseObject objectForKey:@"result"];
            if ([result isEqualToString:@"00"]) {
                //状态修改成功
            }
        } failure:^(NSString *msgid, NSError *error) {
            
        }];
        NSMutableDictionary *mutableItem = [[NSMutableDictionary alloc] initWithDictionary:dic];
        NSMutableDictionary *mutablesm = [[NSMutableDictionary alloc] initWithDictionary:sm];
        [mutablesm setValue:@"Y" forKey:@"msgStatus"];
        [mutableItem setValue:mutablesm forKey:@"sm"];
        [_dataSource[_currentPage] setObject: mutableItem atIndexedSubscript:indexPath.row];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath];
        UITableView *reuseTableView = _scrollTableViews[_currentPage];
        [reuseTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    }
    
    

    
    NSString *sType = [sm objectForKey:@"sType"];
    if ([@"scoreinfo" isEqualToString:sType]) {
        BtFlowDetailsViewController *ctrl = [[BtFlowDetailsViewController alloc] init];
        [self.viewController.navigationController pushViewController:ctrl animated:YES];
    } else if([@"flowinfo" isEqualToString:sType]) {
        //手机充值备胎
        BenefitsViewController *ctrl = [[BenefitsViewController alloc] init];
        [self.viewController.navigationController pushViewController:ctrl animated:YES];
    }else if([@"fdinfo" isEqualToString:sType]) {
        //添加好友页面
        ApplyFriendsViewController *ctrl = [[ApplyFriendsViewController alloc] init];
        [self.viewController.navigationController pushViewController:ctrl animated:YES];
    }else if([@"ntflow" isEqualToString:sType]) {
        //次月生效
        TimingRechargeViewController *ctrl = [[TimingRechargeViewController alloc] init];
        [self.viewController.navigationController pushViewController:ctrl animated:YES];
    }else if([@"virtofdpho" isEqualToString:sType]) {
        //充至好友手机账户
        RechargeViewController *ctrl = [[RechargeViewController alloc] init];
        [self.viewController.navigationController pushViewController:ctrl animated:YES];
    }else if([@"helpinfo" isEqualToString:sType]) {
        //跳入赠送页面
        PresentViewController *pCtrl = [[PresentViewController alloc] init];
        pCtrl.fdmobile  = [dic objectForKey:@"fdmobile"];
        [self.viewController.navigationController pushViewController:pCtrl animated:YES];
    }else if([@"preinfo" isEqualToString:sType]) {
        //跳入备胎流量详情页面
        BtFlowDetailsViewController *ctrl = [[BtFlowDetailsViewController alloc] init];
        [self.viewController.navigationController pushViewController:ctrl animated:YES];
    }else if([@"" isEqualToString:sType]) {
        
        
    }else if([@"" isEqualToString:sType]) {
        
        
    }
}

-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    BOOL nibsRegistered=NO;
    if (!nibsRegistered) {
        UINib *nib=[UINib nibWithNibName:@"MessageCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"MessageCell"];
        nibsRegistered=YES;
    }
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if ([tableView isEqual:_scrollTableViews[_currentPage%3]]) {
        NSDictionary *dic = _dataSource[_currentPage][indexPath.row];
        NSDictionary *sm = [dic objectForKey:@"sm"];
        cell.label_detail.text = [sm objectForKey:@"content"];
        cell.label_date.text = [sm objectForKey:@"createTime"];
        switch (_currentPage) {
            case 0:
                cell.label_title.text = @"系统消息";
                break;
            case 1:
                cell.label_title.text = @"备胎消息";
                break;
            case 2:
                cell.label_title.text = @"优惠消息";
                break;
            default:
                break;
        }
        cell.state = [sm objectForKey:@"msgStatus"];
 
    }
    return cell;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            UITableView *showt = _scrollTableViews[_currentPage];
            showt.hidden = NO;
        });
    }
}


#pragma mark - 服务窗的消息数量监听
-(void)countBtNum:(NSNotification *)notification{
    @try {
        NSMutableDictionary *dic = notification.object;
        int count = [[dic objectForKey:@"count"] intValue];
        NSString *num = [self fomatNum:count];
    
        NSString *method = [dic objectForKey:@"method"];
        UIView *tmpView = [_topScrollView viewWithTag:12];
        UILabel *label = (UILabel *)[tmpView viewWithTag:101];
        if ([method isEqualToString:@"fg"]) {
            
        } if ([method isEqualToString:@"js"]) {
            int current = [label.text intValue];
            if (current > 0) {
                current = current-1;
            }
            num = [self fomatNum:current];
        }
        if ([NSString isBlankString:num]) {
            label.hidden = YES;
        } else {
            label.hidden = NO;
            label.text = num;
        }
    }
    @catch (NSException *exception) {
        MyLog(@"%@",exception.description);
    }
    @finally {
        
    }
}

-(void)countSysNum:(NSNotification *)notification{
    @try {
        NSMutableDictionary *dic = notification.object;
        int count = [[dic objectForKey:@"count"] intValue];
        NSString *num = [self fomatNum:count];

        UIView *tmpView = [_topScrollView viewWithTag:11];
        UILabel *label = (UILabel *)[tmpView viewWithTag:100];
        NSString *method = [dic objectForKey:@"method"];
        if ([method isEqualToString:@"fg"]) {
            
        } if ([method isEqualToString:@"js"]) {
            int current = [label.text intValue];
            if (current > 0) {
                current = current-1;
            }
            num = [self fomatNum:current];
        }
        if ([NSString isBlankString:num]) {
            label.hidden = YES;
        } else {
            label.hidden = NO;
            label.text = num;
        }

        
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

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:btNum object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:sysNum object:nil];
}
@end
