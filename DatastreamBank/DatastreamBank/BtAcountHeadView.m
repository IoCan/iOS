//
//  BtAcountHeadView.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/25.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BtAcountHeadView.h"
#import "UIButton+WebCache.h"
#import "UserInfoManager.h"

@implementation BtAcountHeadView

- (void)awakeFromNib {
    // Initialization code
}


/**
 *  初始化xib页面
 *
 *  @param frame 页面位置大小
 *
 *  @return UIView
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"BtAcountHeadView" owner:self options:nil][0];
        view.frame = CGRectMake(0, 0, ScreenWidth, 100);
//        self.frame =  CGRectMake(0, 0, ScreenWidth, 100);
        [self addSubview:view];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _btn_header.layer.cornerRadius = _btn_header.frame.size.width/2;
    _btn_header.layer.borderColor = [UIColor whiteColor].CGColor;
    _btn_header.layer.borderWidth = 2.0f;
    _btn_header.clipsToBounds = YES;

    NSString *mobile = [UserInfoManager readObjectByKey:ican_mobile];
    NSInteger virtualflow = [[UserInfoManager readObjectByKey:ican_virtualflow] integerValue];
    NSString *headpath = [UserInfoManager readObjectByKey:ican_headpath];
    self.label_userphone.text = [NSString stringWithFormat:@"账户：%@",mobile];
    self.label_balance.text = [NSString stringWithFormat:@"备胎余额：%ldM",virtualflow];
    if (headpath!=nil && headpath.length>10) {
        NSString *headurl = [BaseUrlString stringByAppendingString:headpath];
        [_btn_header sd_setBackgroundImageWithURL:[NSURL URLWithString:headurl]
                                                   forState:UIControlStateNormal
                                           placeholderImage:[UIImage imageNamed:@"img_header_default.png"]
                                                    options:SDWebImageDelayPlaceholder
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                      //                                                      NSLog(@"%@",error);
                                                  }];
        
    }

 
}


@end
