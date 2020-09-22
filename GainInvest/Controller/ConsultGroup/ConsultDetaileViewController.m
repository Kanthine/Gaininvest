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

@property (nonatomic ,strong) MBProgressHUD *progressHUD;

@end

@implementation ConsultDetaileViewController

- (instancetype)initWithID:(NSString *)idString
{
    self = [super init];
    
    if (self)
    {
        NSString *urlStr = [NSString stringWithFormat:@"http://m.tubiaojia.cn/106/article_detail?article_id=%@",idString];
        
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNavBar];
    
    [self.view addSubview:self.webView];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"咨询详情";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (WKWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _webView.navigationDelegate = self;
    }
    
    return _webView;
}

- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil)
    {
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        _activityView.frame = CGRectMake(0, 0, 50, 50);
        _activityView.center = CGPointMake(ScreenWidth / 2.0, ScreenHeight / 2.0 - 45);
    }
    
    return _activityView;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.tag = 100;
    
    
//    [self.view addSubview:self.activityView];
//    [self.view bringSubviewToFront:self.activityView];
//    [self.activityView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    MBProgressHUD *hud = [self.view viewWithTag:100];
    [hud hideAnimated:YES];

//    [self.activityView stopAnimating];
//    [self.activityView removeFromSuperview];
//    _activityView = nil;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    MBProgressHUD *hud = [self.view viewWithTag:100];
    [hud hideAnimated:YES];

//    [self.activityView stopAnimating];
//    [self.activityView removeFromSuperview];
//    _activityView = nil;

}

@end
