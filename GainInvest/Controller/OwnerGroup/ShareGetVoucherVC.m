//
//  ShareGetVoucherVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/9.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define BUFFER_SIZE 1024 * 100


#import "ShareGetVoucherVC.h"
#import "AppDelegate.h"
#import "MyVoucherViewController.h"
#import "ShareManager.h"

@interface ShareGetVoucherVC ()


@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UIButton *shareButton;

@end

@implementation ShareGetVoucherVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    720 / 663
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customNavBar];
    
    [self.view addSubview:self.scrollView];
    
    __weak __typeof__(self) weakSelf = self;
    APPDELEGETE.libWeChatShareResult = ^(NSError *error)
    {
        [weakSelf handleWeChatShareResult:error];
    };;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"分享领代金券";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = RGBA(248, 181, 76, 1);
        
        UIImage *image = [UIImage imageNamed:@"owner_ShareGetVoucher"];
        
        CGFloat imageHeight = image.size.height / image.size.width * ScreenWidth;
        
        self.imageView.image = image;
        self.imageView.frame = CGRectMake(0, 0, ScreenWidth, imageHeight);
        
        [_scrollView addSubview:self.imageView];
        
        _scrollView.contentSize = CGSizeMake(ScreenWidth, imageHeight);
        
        
        CGFloat buttonHeight = 340 / 375.0 * ScreenWidth;

        self.shareButton.frame = CGRectMake(50, buttonHeight, ScreenWidth - 100, 80);
        [_scrollView addSubview:self.shareButton];

        
    }
    
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc]init];
    }
    
    return _imageView;
}

- (UIButton *)shareButton
{
    if (_shareButton == nil)
    {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        _shareButton.layer.borderWidth = 3;
//        _shareButton.layer.borderColor = [UIColor yellowColor].CGColor;
        
    }
    
    return _shareButton;
}

- (void)shareButtonClick
{
    [ShareManager weChatShareDetaileString:@"首单免费，安全正规的小额投资平台，8元起投，操作简单，盈利可立即提现" ViewController:self];
}

- (void)handleWeChatShareResult:(NSError *)err{
    [self showShareResult:@"您已成功分享，我们将发送代金券到您个人账户，请注意查收" Succees:YES];
}

- (void)showShareResult:(NSString *)string Succees:(BOOL)isSucceed
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                             {}];
    [alertView addAction:action];
    
    
    if (isSucceed)
    {
        UIAlertAction *lookAction = [UIAlertAction actionWithTitle:@"去查看代金券" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                     {
                                         [self lookMyCouponClick];
                                     }];
        [alertView addAction:lookAction];
        
    }
    else
    {
        UIAlertAction *againAction = [UIAlertAction actionWithTitle:@"再次分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                      {
                                          [self shareButtonClick];
                                      }];
        [alertView addAction:againAction];
    }
    
    [self presentViewController:alertView animated:YES completion:nil];
}


- (void)lookMyCouponClick
{
    if ([AuthorizationManager isLoginState] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    
    if ([AuthorizationManager isHaveFourLevelWithViewController:self IsNeedCancelClick:NO])
    {
        MyVoucherViewController *voucherVC = [[MyVoucherViewController alloc]init];
        voucherVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:voucherVC animated:YES];
    }
}

@end
