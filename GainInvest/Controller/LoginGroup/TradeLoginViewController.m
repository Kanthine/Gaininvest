//
//  TradeLoginViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/11.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "TradeLoginViewController.h"
#import <WebKit/WebKit.h>
#import "SetTransactionPasswordVC.h"
@interface TradeLoginViewController ()

<WKNavigationDelegate>

{
    NSString *_urlString;
}


@property (nonatomic ,strong) WKWebView *webView;

@property (nonatomic ,strong) UIActivityIndicatorView *activityView;

@end

@implementation TradeLoginViewController

- (instancetype)initWithURL:(NSString *)urlString
{
    self = [super init];
    
    if (self)
    {
        
        if (urlString)
        {
            
            _urlString = urlString;
            NSLog(@"urlString ====== %@",urlString);
            
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
            
        }
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
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    if (self.isPushVC)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    
//    
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
    
    
    NSLog(@"error ====== %@",error);
    
}

//在收到响应之前，决定是否跳转
- (void)webView:(WKWebView* )webView decidePolicyForNavigationAction:(WKNavigationAction* )navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *urlString = navigationAction.request.URL.absoluteString;
    
    NSString *tokenString = @"";
    
    if ([urlString containsString:@"?token="])
    {
        tokenString = [urlString componentsSeparatedByString:@"?token="].lastObject;
        tokenString = [tokenString componentsSeparatedByString:@"&"].firstObject;
    }
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    if (tokenString.length > 0 && ![tokenString containsString:@"http:"])
    {
        [UserLocalData setTradeToken:tokenString];
        //设置交易密码成功
        decisionHandler(WKNavigationActionPolicyCancel);
        [self leftNavBarButtonClick];
        NSLog(@"tokenString ====== %@",tokenString);
    }
    else if ([_urlString isEqualToString:urlString] == NO)
    {
        decisionHandler(WKNavigationActionPolicyCancel);
        
        //忘记密码
        SetTransactionPasswordVC *setVc = [[SetTransactionPasswordVC alloc]initWithURL:urlString Type:TransactionPasswordKindUpdate];
        setVc.isPushVC = YES;
        setVc.navigationItem.title = @"修改交易密码";
        [self.navigationController pushViewController:setVc animated:YES];
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


@end
