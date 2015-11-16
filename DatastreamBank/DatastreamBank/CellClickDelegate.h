//
//  CellClickDelegate.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/11/14.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CellClickDelegate <NSObject>

@optional
-(void)click:(NSIndexPath *) indexPath;

@end

 
