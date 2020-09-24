//
//  ConsultDetaileViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/16.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "ConsultDetaileViewController.h"
#import <WebKit/WebKit.h>

@interface ConsultDetaileViewController ()
<WKNavigationDelegate>

@property (nonatomic ,strong) WKWebView *webView;
@property (nonatomic ,strong) UIActivityIndicatorView *activityView;

@end

@implementation ConsultDetaileViewController

- (instancetype)initWithURL:(NSString *)url{
    self = [super init];
    if (self){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"咨询详情";
    self.navigationItem.leftBarButtonItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    [self.view addSubview:self.webView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.webView.frame = self.view.bounds;
    self.activityView.center = self.webView.center;
}

- (void)leftNavBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [self.view addSubview:self.activityView];
    [self.view bringSubviewToFront:self.activityView];
    [self.activityView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    _activityView = nil;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    _activityView = nil;

}

#pragma mark - setter and getters

- (WKWebView *)webView{
    if (_webView == nil){
        _webView = [[WKWebView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIActivityIndicatorView *)activityView{
    if (_activityView == nil){
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(0, 0, 50, 50);
    }
    return _activityView;
}

@end
