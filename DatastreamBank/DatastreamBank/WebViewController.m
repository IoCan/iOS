//
//  WebViewController.m
//  DatastreamBank
//
//  Created by OsnDroid on 15/10/14.
//  Copyright (c) 2015年 OsnDroid. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"";
        self.isBottm = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label_bottom.hidden = YES;
    if ([_url containsString:@"http"]) {
        self.title = @"加载中...";
        NSURL *url = [NSURL URLWithString:_url];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
         _webView.delegate = self;
        [_webView loadRequest:request];
    } else {
        NSString *htmlString = [NSString stringWithContentsOfFile:_url encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:_url]];
        _webView.delegate = self;
        self.title = @"";
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
    self.label_bottom.hidden = self.isBottm;
}

-(void)dealloc {
    [_webView stopLoading];
    _webView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithUrl:(NSString *)url {
    self = [super self];
    if (self) {
        _url = url;
    }
    return self;
}

@end
