//
//  SetTransactionPasswordVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/23.
//  Copyright © 2017年 苏沫离. All rights reserved.
//


#define Success @"?utoken=ying"

#import "SetTransactionPasswordVC.h"

#import "UserInfoHttpManager.h"
#import <WebKit/WebKit.h>

#import "MainTabBarController.h"
#import "MyVoucherViewController.h"

@interface SetTransactionPasswordVC ()
<WKNavigationDelegate>

{
    NSString *_urlString;
    
    TransactionPasswordKind _passwordKind;
}


@property (nonatomic ,strong) WKWebView *webView;

@property (nonatomic ,strong) UIActivityIndicatorView *activityView;

@end

@implementation SetTransactionPasswordVC

- (instancetype)initWithURL:(NSString *)urlString Type:(TransactionPasswordKind)passwordKind
{
    self = [super init];
    
    if (self)
    {
        
        if (urlString)
        {
            _urlString = urlString;
            _passwordKind = passwordKind;

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
        __block BOOL isHave = NO;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if ([obj isKindOfClass:NSClassFromString(@"AccountManagerVC")])
             {
                 [self.navigationController popToViewController:obj animated:YES];
                 isHave = YES;
                 * stop = YES;
             }
        }];
        
        if (isHave == NO)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }        
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
    NSLog(@"urlString =====%@",urlString);
  

    if (_passwordKind == TransactionPasswordKindOpenAccount)
    {
          urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString2 =====%@",urlString);

        if ([_urlString isEqualToString:urlString])
        {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
        else if ([urlString containsString:Success])
        {
            // 开户成功
            AccountInfo *account = [AccountInfo standardAccountInfo];
            account.isOpenAccount = @"1";
            [account storeAccountInfo];
            [self leftNavBarButtonClick];
            
            [SetTransactionPasswordVC registerSuccessSendCouponTip];
            
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        else
        {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - 开户成功提示送代金券

+ (void)registerSuccessSendCouponTip
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"惊喜到来" message:@"您已经成功在交易所开户，我们又赠送您一张8元代金券作为奖励，请您注意查收" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
    
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"去查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      [self lookMyCouponList];
                                  }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:loginAction];
    
    UINavigationController *nav = [MainTabBarController shareMainController].selectedViewController;
    
    [nav.viewControllers.lastObject presentViewController:actionSheet animated:YES completion:nil];
}

+ (void)lookMyCouponList
{
    UINavigationController *nav = [MainTabBarController shareMainController].selectedViewController;
    
    if ([AuthorizationManager isLoginState] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:nav.viewControllers.lastObject];
    }
    else if ([AuthorizationManager isHaveFourLevelWithViewController:nav.viewControllers.lastObject IsNeedCancelClick:NO])
    {
        MyVoucherViewController *voucherVC = [[MyVoucherViewController alloc]init];
        voucherVC.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:voucherVC animated:YES];
    }
}


@end

