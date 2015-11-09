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

@interface HomeViewController : BaseViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionTwoView;

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (strong, nonatomic) IBOutlet UIButton *btn_tnf;
@property (strong, nonatomic) IBOutlet UIButton *btn_btf;

- (IBAction)action_tnf:(id)sender;
- (IBAction)action_btf:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *slideView;

@property (strong, nonatomic) NSMutableArray *data;//数据源
@property (strong, nonatomic) NSMutableArray *datatwo;//数据源

@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;

@end
