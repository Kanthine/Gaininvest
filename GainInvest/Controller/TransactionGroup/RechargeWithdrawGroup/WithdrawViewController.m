//
//  WithdrawViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/24.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "WithdrawViewController.h"

#import "WithdrawPerfectInfoView.h"
#import "WithdrawBankCardInfoView.h"


@interface WithdrawViewController ()
<CAAnimationDelegate>
{
    NSDictionary *_bandCardInfo;
}


@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) WithdrawPerfectInfoView *firstWithdrawView;
@property (nonatomic ,strong) WithdrawBankCardInfoView *withdrawInfoView;


@end

@implementation WithdrawViewController

- (void)dealloc
{
    _httpManager = nil;

}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.accountMoney = @"0";
        //获取银行卡信息
//        [self accessBankCardInfo];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    
    [self.scrollView addSubview:self.firstWithdrawView];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(self.firstWithdrawView.frame) + 200);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"提现";
    
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
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds) - 64)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = TableGrayColor;
    }
    
    return _scrollView;
}

- (WithdrawPerfectInfoView *)firstWithdrawView
{
    if (_firstWithdrawView == nil)
    {
        _firstWithdrawView = [[NSBundle mainBundle] loadNibNamed:@"WithdrawPerfectInfoView" owner:nil options:nil].firstObject;
        _firstWithdrawView.accountMoney = self.accountMoney;
        _firstWithdrawView.currentViewController = self;
        
        CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds) - 64;
        if (height < 520)
        {
            height = 520;
        }
        
        _firstWithdrawView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), height);

    }
    
    return _firstWithdrawView;
}

- (WithdrawBankCardInfoView *)withdrawInfoView
{
    if (_withdrawInfoView == nil)
    {
        _withdrawInfoView = [[NSBundle mainBundle] loadNibNamed:@"WithdrawBankCardInfoView" owner:nil options:nil].firstObject;
        _withdrawInfoView.accountMoney = self.accountMoney;
        _withdrawInfoView.currentViewController = self;
        _withdrawInfoView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 340);
        [_withdrawInfoView.updateBankCardInfoButton addTarget:self action:@selector(updateBankCardInfoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _withdrawInfoView;
}

- (void)updateBankCardInfoButtonClick
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.7f;
    animation.type = @"pageCurl";
    animation.subtype = kCATransitionFromRight;
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [self.view.layer addAnimation:animation forKey:@"animation"];
    
    
    [self.scrollView insertSubview:self.firstWithdrawView aboveSubview:self.withdrawInfoView];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(self.firstWithdrawView.frame) + 200);

}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"动画结束！");
    [self.withdrawInfoView removeFromSuperview];

}


- (void)setAccountMoney:(NSString *)accountMoney
{
    _accountMoney = accountMoney;
    
    if (_firstWithdrawView)
    {
        _firstWithdrawView.accountMoney = accountMoney;
    }
    
    if (_withdrawInfoView)
    {
        _withdrawInfoView.accountMoney = accountMoney;
    }
    
}


- (TransactionHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[TransactionHttpManager alloc]init];
    }
    
    return _httpManager;
}

- (void)accessBankCardInfo
{
    __weak __typeof__(self) weakSelf = self;
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *dict = @{@"mobile_phone":account.phone};
    [self.httpManager withdrawBankCardInfoParameterDict:dict CompletionBlock:^(NSDictionary *parameterDict, NSError *error)
    {
        if (error)
        {
            //请求发生错误
            [ErrorTipView errorTip:error.domain SuperView:weakSelf.view];

            [weakSelf.scrollView addSubview:weakSelf.firstWithdrawView];
            weakSelf.scrollView.contentSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(weakSelf.firstWithdrawView.frame) + 200);
        }
        else if (parameterDict)
        {
            //返回用户提现卡信息
            _bandCardInfo = parameterDict;
            [weakSelf.scrollView addSubview:weakSelf.withdrawInfoView];
            weakSelf.withdrawInfoView.infoDict = parameterDict;
            weakSelf.scrollView.contentSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(weakSelf.withdrawInfoView.frame));
        }
        else
        {
            //返回正常，但是缺少用户卡信息，需要去完善
            [weakSelf.scrollView addSubview:weakSelf.firstWithdrawView];
            weakSelf.scrollView.contentSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(weakSelf.firstWithdrawView.frame) + 200);
        }
    }];
}

@end
