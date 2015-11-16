//
//  WebViewController.h
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/14.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate>
{
    
    NSString *_url;
}

-(id)initWithUrl:(NSString *)url;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic,assign) BOOL isBottm;


@property (strong, nonatomic) IBOutlet UILabel *label_bottom;

@end
