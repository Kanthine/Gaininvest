//
//  RechargeInfomationVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/1.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "RechargeInfomationVC.h"

#import "RechargePerfectInfomation.h"

@interface RechargeInfomationVC ()

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) RechargePerfectInfomation *rechargeView;

@end

@implementation RechargeInfomationVC

- (void)dealloc
{
    _httpManager = nil;
}

- (TransactionHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[TransactionHttpManager alloc]init];
    }
    
    return _httpManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    [self customNavBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"充值信息";
    
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
        _scrollView.backgroundColor = TableGrayColor;
        
        [_scrollView addSubview:self.rechargeView];
        _scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetHeight(self.rechargeView.frame) + 200);

    }
    
    return _scrollView;
}

- (RechargePerfectInfomation *)rechargeView
{
    if (_rechargeView == nil)
    {
        _rechargeView = [[NSBundle mainBundle] loadNibNamed:@"RechargePerfectInfomation" owner:nil options:nil].firstObject;
        _rechargeView.currentMoney = self.currentMoney;
        _rechargeView.currentViewController = self;
        
        CGFloat height = ScreenHeight - 64;
        if (height < 470)
        {
            height = 470;
        }
        
        _rechargeView.frame = CGRectMake(0, 0, ScreenWidth, height);
        
    }
    
    return _rechargeView;
}


@end
