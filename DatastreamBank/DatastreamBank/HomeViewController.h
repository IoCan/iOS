//
//  HomeViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/9/22.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "JDFPeekabooCoordinator.h"
#import "CircularProgressView.h"

@interface HomeViewController : BaseViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionTwoView;
@property (strong, nonatomic) IBOutlet UIView *view1;

@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet CircularProgressView *progress;

@property (strong, nonatomic) NSMutableArray *data;//数据源
@property (strong, nonatomic) NSMutableArray *datatwo;//数据源
@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;

@end
