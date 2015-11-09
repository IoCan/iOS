//
//  LocationSheetView.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/31.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IcLocation.h"

@interface LocationSheetView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
@private
    NSArray *provinces;
    NSArray	*cities;
}


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) IcLocation *locate;
@property (nonatomic) BOOL isShow;

 

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;
-(void)removeView;
- (void)showInView:(UIView *)view;
 

@end
