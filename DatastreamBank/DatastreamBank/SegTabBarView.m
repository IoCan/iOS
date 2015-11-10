//
//  SegTabBarView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/17.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "SegTabBarView.h"
#import "MessageCell.h"
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

@end

@implementation SegTabBarView

-(instancetype)initWithFrame:(CGRect)frame WithArray: (NSMutableArray *)items{
    self = [super initWithFrame:frame];
    
    if (self) {
        _topItems = items;
        _tabCount = items.count;
        _topViews = [[NSMutableArray alloc] init];
        _scrollTableViews = [[NSMutableArray alloc] init];
        
        [self initDataSource];
        
        [self initScrollView];
        
        [self initTopTabs];
        
        [self initDownTables];
        
        [self initDataSource];
        
        [self initSlideView];
        
    }
    
    return self;
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
    for (int i = 1; i <= _tabCount; i ++) {
        NSMutableArray *tempArray  = [[NSMutableArray alloc] initWithCapacity:20];
        for (int j = 1; j <= 20; j ++) {
            NSString *tempStr = [NSString stringWithFormat:@"我是第%d个TableView的第%d条数据。", i, j];
            [tempArray addObject:tempStr];
        }
        [_dataSource addObject:tempArray];
    }
}


#pragma mark * UIPanGestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //    NSString *str = [NSString stringWithUTF8String:object_getClassName(gestureRecognizer)];
    NSLog(@"======");
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}

#pragma mark -- 实例化ScrollView
-(void) initScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, default_topview_height, self.frame.size.width, self.frame.size.height - default_topview_height)];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * _tabCount, self.frame.size.height - default_topview_height-64);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = NO;
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
        view.tag = 11;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, default_topview_height)];
        button.tag = i+1;
        [button setTitle:[NSString stringWithFormat:_topItems[i], i+1] forState:UIControlStateNormal];
        [button setTitleColor:default_normal_titlecolor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((width - default_badgelabel_wh), 5, default_badgelabel_wh, default_badgelabel_wh)];
        label.text = @"●";
        label.textColor = [UIColor redColor];
        label.tag = i+10;
        label.font = [UIFont boldSystemFontOfSize:18];
        [view addSubview:label];
        [_topViews addObject:view];
        [_topScrollView addSubview:view];
    }
 
}



#pragma mark --点击顶部的按钮所触发的方法
-(void) tabButton: (id) sender{
    UIButton *button = sender;
    [_scrollView setContentOffset:CGPointMake((button.tag-1) * self.frame.size.width, 0) animated:YES];
}

#pragma mark --初始化下方的TableViews
-(void) initDownTables{
    
    for (int i = 0; i < 3; i ++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height - default_topview_height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i;
//        tableView set
        [_scrollTableViews addObject:tableView];
        [_scrollView addSubview:tableView];
    }
    
}


#pragma mark --根据scrollView的滚动位置复用tableView，减少内存开支
-(void) updateTableWithPageNumber: (NSUInteger) pageNumber{
    int tabviewTag = pageNumber % 3;
    CGRect tableNewFrame = CGRectMake(pageNumber * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height - default_topview_height);
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
        UIButton *btn = (UIButton *)[_topScrollView viewWithTag:_currentPage+1];
        [btn setTitleColor:default_selected_titlecolor forState:UIControlStateNormal];
        [self updateTableWithPageNumber:_currentPage];
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
    return YES;
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
    NSLog(@"%ld",indexPath.row);
}

-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    BOOL nibsRegistered=NO;
    if (!nibsRegistered) {
        UINib *nib=[UINib nibWithNibName:@"MessageCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"MessageCell"];
        nibsRegistered=YES;
    }
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if ([tableView isEqual:_scrollTableViews[_currentPage%2]]) {
        //        cell.tipTitle.text = _dataSource[_currentPage][indexPath.row];
    }
    return cell;
}


@end
