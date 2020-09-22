//
//  RechargeMethodVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/1.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define CellIdentifer @"RechargeMethodTableCell"
#define HeaderIdentifer @"UITableViewHeaderFooterView"


#import "RechargeMethodVC.h"
#import "RechargeMethodTableCell.h"
#import "RechargeMethodVerifyView.h"

#import <Masonry.h>
#import "RechargeInfomationVC.h"
#import "TransactionHttpManager.h"
#import "RechargeResultVC.h"
@interface RechargeMethodVC ()
<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger _currentMoney;
    
    NSInteger _interval;
    
    NSInteger _selectedIndex;
    
}

@property (nonatomic ,strong) TransactionHttpManager *httpManager;
@property (nonatomic ,strong) UIView *tableHeaderView;
@property (nonatomic ,strong) UIView *tableFooterView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSTimer *timer;

@end

@implementation RechargeMethodVC

- (void)dealloc
{
    _timer = nil;
    _httpManager = nil;
}

- (instancetype)initWithRechargeMoney:(NSInteger)money
{
    self = [super init];
    
    if (self)
    {
        _selectedIndex = 0;
        _interval = -1;
        _currentMoney = money;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBA(250, 250, 255, 1);
    
    [self customNavBar];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"充值方式";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;

    
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (TransactionHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[TransactionHttpManager alloc]init];
    }
    
    return _httpManager;
}


- (UIView *)tableHeaderView
{
    if (_tableHeaderView == nil)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *tipLable = [[UILabel alloc]init];
        tipLable.text = @"充值金额";
        tipLable.textColor = TextColorBlack;
        tipLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:tipLable];
        [tipLable mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.centerY.equalTo(view);
            make.left.mas_equalTo(@10);
        }];
        
        
        UILabel *modenLable = [[UILabel alloc]init];
        modenLable.text = [NSString stringWithFormat:@"%ld元",_currentMoney];
        modenLable.textColor = [UIColor redColor];
        modenLable.font = [UIFont systemFontOfSize:15];
        [view addSubview:modenLable];
        [modenLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(view);
             make.right.mas_equalTo(@-10);
         }];
        
        _tableHeaderView = view;
    }
    
    return _tableHeaderView;
}

- (UIView *)tableFooterView
{
    if (_tableFooterView == nil)
    {
        
        CGFloat y = 44 + 26 + 50 * 2;
        CGFloat height = ScreenHeight - y - 64;
        if (height < 60)
        {
            height = 60;
        }
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.backgroundColor = UIColorFromRGB(0x576fe3, 1);
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        button.frame = CGRectMake(15, height - 60, ScreenWidth - 30, 40);
        [footerView addSubview:button];
        
        _tableFooterView = footerView;
    }
    
    return _tableFooterView;
}



- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        
        [_tableView registerNib:[UINib nibWithNibName:@"RechargeMethodTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = self.tableFooterView;
    }
    
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 26.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];
    
    UILabel *lable = [headerView.contentView viewWithTag:1];
    
    if (lable == nil)
    {
        UILabel *tipLable = [[UILabel alloc]init];
        tipLable.tag = 1;
        tipLable.text = @"选择支付方式";
        tipLable.textColor = TextColorGray;
        tipLable.font = [UIFont systemFontOfSize:13];
        [headerView.contentView addSubview:tipLable];
        [tipLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(headerView);
             make.left.mas_equalTo(@10);
         }];
    }
    
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RechargeMethodTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        cell.platLogoImageView.image = [UIImage imageNamed:@"RechargeMethod_WeChat"];
        cell.payPlatLable.text = @"微信支付";
        cell.payPlatDetaileLable.text = @"推荐微信4.2以上版本使用";
        cell.platDetaileImageView.hidden = YES;
    }
    else
    {
        cell.platLogoImageView.image = [UIImage imageNamed:@"RechargeMethod_Rank"];
        cell.payPlatLable.text = @"快捷支付";
        cell.payPlatDetaileLable.text = @"由京东支付提供服务";
        cell.platDetaileImageView.hidden = NO;
        cell.platDetaileImageView.image = [UIImage imageNamed:@"RechargeMethod_JingdongLogo"];
    }
    
    if (_selectedIndex == indexPath.row)
    {
        cell.selectImageView.highlighted = YES;
    }
    else
    {
        cell.selectImageView.highlighted = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    [tableView reloadData];
}

- (void)confirmButtonClick
{
    
    if (_selectedIndex == 0)
    {
        //微信支付
        [self weChatMethodPay];
    }
    else if (_selectedIndex == 1)
    {
        //京东支付
        AccountInfo *account = [AccountInfo standardAccountInfo];
        if ([account.isHaveJdInfo isEqualToString:@"1"])
        {
            [self jdMethodPay];
        }
        else
        {
            [self jdMethodInfoPay];
        }
    }

}

- (void)weChatMethodPay
{
    
    NSString *moneyStr = [NSString stringWithFormat:@"%ld",_currentMoney * 100];
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *dict = @{@"mobile_phone":account.username,
                           @"card_no":@"",
                           @"money":moneyStr,
                           @"channel":@"12"};
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the label text.
    hud.label.text = @"提交订单";
    [self.httpManager UnionPayRechargeWithParameterDict:dict CompletionBlock:^(NSString *tokenString, NSError *error)
    {
        [hud hideAnimated:YES];

        if (error)
        {
            [ErrorTipView errorTip:error.domain SuperView:self.view];
        }
        else
        {
            [self weChatMethodPayWithToken:tokenString];
        }
    }];
}

- (void)weChatMethodPayWithToken:(NSString *)tokenString
{
    
    
}

- (void)jdMethodInfoPay
{
    RechargeInfomationVC *rechargeVC = [[RechargeInfomationVC alloc]init];
    rechargeVC.currentMoney = _currentMoney;
    rechargeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)jdMethodPay
{
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSString *string = [NSString stringWithFormat:@"%ld",_currentMoney * 100];
    NSDictionary *parameterDict = @{@"mobile_phone":account.username,
                                    @"trade_amount":string};
    __weak __typeof__(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the label text.
    hud.label.text = @"提交订单";
    [self.httpManager jingDongSignatoryOnlineWithParameterDict:parameterDict CompletionBlock:^(NSDictionary *resultDict,NSError *error)
     {
         [hud hideAnimated:YES];

         if (error)
         {
             if (error.code == 132)
             {
                 [weakSelf jdMethodInfoPay];
             }
             else
             {
                 [ErrorTipView errorTip:error.domain SuperView:self.view];
             }

         }
         else
         {
             
             NSString *orderId = [NSString stringWithFormat:@"%@",resultDict[@"data.trade.id"]];
             
             RechargeMethodVerifyView *verifyView = [[RechargeMethodVerifyView alloc]init];
             verifyView.rechargeMethodVerifyCode = ^(NSString *verCode)
             {
                 [weakSelf jdMethodPayOnlineWithID:orderId VerCode:verCode];
             };
             verifyView.rechargeMethodVerifyDismiss = ^()
             {
                 [weakSelf stopTimer];
             };
             [verifyView show];
             if (0 <= _interval && _interval <= 60)
             {
                 verifyView.timeLable.text = [NSString stringWithFormat:@"%ldS",_interval];
             }
             else
             {
                 verifyView.timeLable.text = @"60S";
             }
             [weakSelf timer];

         }
     }];

}


- (void)jdMethodPayOnlineWithID:(NSString *)oderId VerCode:(NSString *)verCode
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSString *money = [NSString stringWithFormat:@"%ld",_currentMoney * 100];
    NSDictionary *parameterDict = @{@"mobile_phone":account.username,
                                    @"trade_amount":money,
                                    @"ordernum":oderId,
                                    @"trade_code":verCode};
    
    
    NSLog(@"parameterDict ======= %@",parameterDict);
    
    
    [self.httpManager jingDongPayWithParameterDict:parameterDict CompletionBlock:^(NSError *error)
     {
         if (error)
         {
             [ErrorTipView errorTip:error.domain SuperView:self.view];
         }
         else
         {
             [self payResultIsSucceed:YES];
         }
     }];
}


- (NSTimer *)timer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendMessage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        _interval = 60;
    }
    return _timer;
}

- (void)sendMessage
{
    _interval --;
    
    [[UIApplication sharedApplication].keyWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj isKindOfClass:[RechargeMethodVerifyView class]])
         {
             RechargeMethodVerifyView *verifyView = (RechargeMethodVerifyView *)obj;
             verifyView.timeLable.text = [NSString stringWithFormat:@"%ldS",_interval];
             * stop = YES;
         }
    }];
    
    if (_interval == 0)
    {
        [self stopTimer];
    }
}

- (void)stopTimer
{
    _interval = 60;
    [_timer invalidate];
    _timer = nil;
}

- (void)payResultIsSucceed:(BOOL)isSucceed
{
    RechargeResultVC *rechargeVC = [[RechargeResultVC alloc]init];
    rechargeVC.navigationItem.title = @"充值结果";
    rechargeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rechargeVC animated:YES];
}


@end
