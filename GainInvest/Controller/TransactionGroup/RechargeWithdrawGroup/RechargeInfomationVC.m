//
//  RechargeInfomationVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/1.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "RechargeInfomationVC.h"
#import "RechargePerfectInfomation.h"

@interface RechargeInfomationVC ()

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) RechargePerfectInfomation *rechargeView;

@end

@implementation RechargeInfomationVC

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    self.navigationItem.title = @"充值信息";
    self.navigationItem.leftBarButtonItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Demo数据" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
}

- (void)leftNavBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClick{
    [self.rechargeView setDemoData];
}

#pragma mark - setter and getters

- (UIScrollView *)scrollView{
    if (_scrollView == nil){
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds) - 64)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = TableGrayColor;
        [_scrollView addSubview:self.rechargeView];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(self.rechargeView.frame) + 200);
    }
    return _scrollView;
}

- (RechargePerfectInfomation *)rechargeView{
    if (_rechargeView == nil){
        _rechargeView = [[NSBundle mainBundle] loadNibNamed:@"RechargePerfectInfomation" owner:nil options:nil].firstObject;
        _rechargeView.currentMoney = self.currentMoney;
        _rechargeView.currentViewController = self;
        
        CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds) - 64;
        if (height < 470){
            height = 470;
        }
        _rechargeView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), height);
    }
    return _rechargeView;
}

@end
