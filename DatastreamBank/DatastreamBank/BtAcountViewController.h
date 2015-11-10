//
//  BtAcountViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/23.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"
@protocol UpdateUserInfoDelegate <NSObject>

@optional

- (void)update;

@end

@interface BtAcountViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>  
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic) NSMutableArray *data;//数据源

@property (assign, nonatomic) id <UpdateUserInfoDelegate> delegate;

@end
