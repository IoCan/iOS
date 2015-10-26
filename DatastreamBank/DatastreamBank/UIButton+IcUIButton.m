//
//  UIButton+IcUIButton.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/20.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "UIButton+IcUIButton.h"

@implementation UIButton (IcUIButton)


- (void)centerImageAndTitle:(float)spacing {

    CGSize imageSize = self.imageView.frame.size;
    
    CGSize titleSize = self.titleLabel.frame.size;
    
    
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
//    CGFloat cj = ScreenWidth/4;
//    cj = (cj-imageSize.width-titleSize.width)/2;
   // CGFloat totalHeight = 90;
    // raise the image and push it right to center it
    //CGFloat top, CGFloat left, CGFloat bottom, CGFloat right
    self.imageEdgeInsets = UIEdgeInsetsMake( - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}

- (void)centerImageAndTitle {
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}


@end
