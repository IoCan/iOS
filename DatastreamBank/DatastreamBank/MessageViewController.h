//
//  MessageViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/9.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"

#import <UIKit/UIKit.h>
//默认顶部ScrollView高度
#define default_topview_height 50
//默认顶部ScrollView底部滑动条的默认高度
#define default_sildeview_height 3
//默认容器内容页面总数
#define default_count 6
//默认红色提示宽高
#define default_badgelabel_wh 16

#define default_normal_titlecolor RGBA(74,74,74,1)
#define default_selected_titlecolor RGBA(91, 190, 211, 1)

@interface MessageViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>


//上方的按钮数组
@property (strong, nonatomic) NSMutableArray *topViews;

//下方的表格数组
@property (strong, nonatomic) NSMutableArray *scrollTableViews;

//TableViews的数据源
@property (strong, nonatomic) NSMutableArray *dataSource;

//顶部菜单数据
@property (strong, nonatomic) NSArray *topItems;

//当前选中页数
@property (assign) NSInteger currentPage;


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
