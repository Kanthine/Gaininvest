//
//  RechargeViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/24.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"RechargeMethodTableCell"
#define HeaderIdentifer @"UITableViewHeaderFooterView"

#import "RechargeViewController.h"
#import "RechargeMethodTableCell.h"

#import "RechargeMethodVerifyView.h"
#import "RechargeQualityItemView.h"
#import "RechargeInfomationVC.h"
#import "RechargeResultVC.h"



@interface RechargeViewController ()
<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger _currentMoney;
    NSInteger _interval;
    NSInteger _selectedIndex;

}

@property (nonatomic ,strong) UIView *qualityView;
@property (nonatomic ,strong) UIView *safetyView;
@property (nonatomic ,strong) UIView *moneyView;

@property (nonatomic ,strong) UIView *tableHeaderView;
@property (nonatomic ,strong) UIView *tableFooterView;
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSTimer *timer;

@end

@implementation RechargeViewController

#pragma mark - life cycle

- (void)dealloc{
    _timer = nil;
}

- (instancetype)init{
    self = [super init];
    if (self){
        _selectedIndex = 0;
        _interval = -1;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"充值";
    self.navigationItem.leftBarButtonItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.view.backgroundColor = RGBA(250, 250, 255, 1);
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - response click

- (void)leftNavBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.isBuyUp != -1){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissRechargeViewControllerNotification" object:nil userInfo:@{@"isBuyUp":@(self.isBuyUp)}];
    }
}

//选择充值面额
- (void)moneyViewButtonClick:(UIButton *)sender{
    [self.moneyView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
         if (obj.tag > 9 && [obj isKindOfClass:[UIButton class]]){
             UIButton *button = (UIButton *)obj;
             [button setTitleColor:UIColorFromRGB(0x576fe3, 1) forState:UIControlStateNormal];
             button.backgroundColor = [UIColor whiteColor];
         }
     }];
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor = UIColorFromRGB(0x576fe3, 1);
    
    _currentMoney = [sender.titleLabel.text intValue];
}

//立即充值
- (void)footerViewRechargeButtonClick{
    NSLog(@"充值金额 : %ld元",_currentMoney);
    if (_selectedIndex == 0){
        //微信支付
        [self weChatMethodPay];
    }else if (_selectedIndex == 1){
        //京东支付
        [self jdMethodPay];
    }
}

#pragma mark - private method

- (void)weChatMethodPay{
    NSString *moneyStr = [NSString stringWithFormat:@"%ld",_currentMoney ];
    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *dict = @{@"mobile_phone":account.phone,
                           @"card_no":@"",
                           @"money":moneyStr,
                           @"channel":@"12"};
    
    AccountInfo.standardAccountInfo.balance = [NSString stringWithFormat:@"%.2f",AccountInfo.standardAccountInfo.balance.floatValue + _currentMoney];
    [AccountInfo.standardAccountInfo storeAccountInfo];

    //支付成功
    [self payResultIsSucceed:YES];
}

- (void)jdMethodPay{
    if ([AccountInfo.standardAccountInfo.isHaveJdInfo isEqualToString:@"1"]) {
        
        NSString *orderId = @"";
        RechargeMethodVerifyView *verifyView = [[RechargeMethodVerifyView alloc]init];
        verifyView.rechargeMethodVerifyCode = ^(NSString *verCode){
            [self jdMethodPayOnlineWithID:orderId VerCode:verCode];
        };
        verifyView.rechargeMethodVerifyDismiss = ^(){
            [self stopTimer];
        };
        [verifyView show];
        if (0 <= _interval && _interval <= 60){
            verifyView.timeLable.text = [NSString stringWithFormat:@"%ldS",_interval];
        }else{
            verifyView.timeLable.text = @"60S";
        }
        [self timer];
        
    }else{
        ///第一次充值，完善京东信息
        RechargeInfomationVC *rechargeVC = [[RechargeInfomationVC alloc]init];
        rechargeVC.currentMoney = _currentMoney;
        rechargeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }
}


- (void)jdMethodPayOnlineWithID:(NSString *)oderId VerCode:(NSString *)verCode{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSString *money = [NSString stringWithFormat:@"%ld",_currentMoney * 100];
    NSDictionary *parameterDict = @{@"mobile_phone":account.phone,
                                    @"trade_amount":money,
                                    @"ordernum":oderId,
                                    @"trade_code":verCode};
    AccountInfo.standardAccountInfo.balance = [NSString stringWithFormat:@"%.2f",AccountInfo.standardAccountInfo.balance.floatValue + _currentMoney];
    [AccountInfo.standardAccountInfo storeAccountInfo];
    [self payResultIsSucceed:YES];
}

- (void)sendMessage{
    _interval --;
    
    [[UIApplication sharedApplication].keyWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
         if ([obj isKindOfClass:[RechargeMethodVerifyView class]]){
             RechargeMethodVerifyView *verifyView = (RechargeMethodVerifyView *)obj;
             verifyView.timeLable.text = [NSString stringWithFormat:@"%ldS",(long)_interval];
             * stop = YES;
         }
     }];
    
    if (_interval == 0){
        [self stopTimer];
    }
}

- (void)stopTimer{
    _interval = 60;
    [_timer invalidate];
    _timer = nil;
}

- (void)payResultIsSucceed:(BOOL)isSucceed{
    RechargeResultVC *rechargeVC = [[RechargeResultVC alloc]init];
    rechargeVC.navigationItem.title = @"充值结果";
    rechargeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [headerView.contentView viewWithTag:1];
    if (lable == nil){
        UILabel *tipLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 35)];
        tipLable.tag = 1;
        tipLable.text = @"选择充值方式";
        tipLable.textColor = TextColorBlack;
        tipLable.font = [UIFont systemFontOfSize:15];
        [headerView.contentView addSubview:tipLable];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RechargeMethodTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    if (indexPath.row == 0){
        cell.platLogoImageView.image = [UIImage imageNamed:@"RechargeMethod_WeChat"];
        cell.payPlatLable.text = @"微信支付";
        cell.payPlatDetaileLable.text = @"推荐微信4.2以上版本使用";
        cell.platDetaileImageView.hidden = YES;
    }else{
        cell.platLogoImageView.image = [UIImage imageNamed:@"RechargeMethod_Rank"];
        cell.payPlatLable.text = @"快捷支付";
        cell.payPlatDetaileLable.text = @"由京东支付提供服务";
        cell.platDetaileImageView.hidden = NO;
        cell.platDetaileImageView.image = [UIImage imageNamed:@"RechargeMethod_JingdongLogo"];
    }
    
    if (_selectedIndex == indexPath.row){
        cell.selectImageView.highlighted = YES;
    }else{
        cell.selectImageView.highlighted = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex = indexPath.row;
    [tableView reloadData];
}

#pragma mark - setter and getters

- (NSTimer *)timer{
    if (!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendMessage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        _interval = 60;
    }
    return _timer;
}

- (UIView *)qualityView{
    if (_qualityView == nil){
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        
        CGFloat itemWidth = CGRectGetWidth(UIScreen.mainScreen.bounds) / 3.0;
        __block CGFloat itemHeight = 0;
                
        NSString *firstImage = @"Recharge_leaglePlatSpot";
        if ([FirstLaunchPage isLookedRechargePlatform]){
            firstImage = @"Recharge_leaglePlat";
        }
        
        NSArray *imageArray = @[firstImage,@"Recharge_leagleMember",@"Recharge_leagleQuality"];
        NSArray *titleArray = @[@"合法平台",@"正规会员",@"资质证明"];

        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
            CGRect rect = CGRectMake(itemWidth * idx, 0, itemWidth, itemWidth);
            RechargeQualityItemView *itemView = [[RechargeQualityItemView alloc]initWithFrame:rect Image:obj Title:titleArray[idx]];
            itemView.tag = idx + 10;
            [view addSubview:itemView];
            itemHeight = CGRectGetHeight(itemView.frame);
        }];

        view.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), itemHeight);
        _qualityView = view;
    }
    return _qualityView;
}

- (UIView *)safetyView{
    if (_safetyView == nil){
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = TableGrayColor;
        
        CGFloat space = 15.0;
        CGFloat imageWidth = (CGRectGetWidth(UIScreen.mainScreen.bounds) - space * 5) / 4.0;
        CGFloat imageHeight = 54 / 149.0 * imageWidth;
        NSArray *imageArray = @[@"Recharge_SafetyUion",@"Recharge_Safety360",@"Recharge_SafetyTencent",@"Recharge_SafetyReallyName"];
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
             UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(space + (space + imageWidth) *idx, 10, imageWidth, imageHeight)];
             imageView.image = [UIImage imageNamed:obj];
             [view addSubview:imageView];
         }];
                
        view.frame = CGRectMake(0, CGRectGetMaxY(self.qualityView.frame), CGRectGetWidth(UIScreen.mainScreen.bounds), imageHeight + 20);
        _safetyView = view;
    }
    return _safetyView;
}

- (UIView *)moneyView{
    if (_moneyView == nil){
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *tipLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 20)];
        tipLable.text = @"选择充值金额";
        tipLable.textColor = [UIColor blackColor];
        tipLable.font = [UIFont systemFontOfSize:15];
        [view addSubview:tipLable];
        UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipLable.frame), 10, 160, 20)];
        rightLable.text = @"(新用户首充送代金券）";
        rightLable.textColor = TextColorGray;
        rightLable.font = [UIFont systemFontOfSize:13];
        [view addSubview:rightLable];
        
        NSArray *priceTitleArray = @[@"10",@"100",@"500",@"1000",@"2500",@"5000"];
        CGFloat buttonWidth = ( ScreenWidth - 15 * 2 - 10 * 2 ) / 3.0;
        CGFloat buttonHeight = 35;
        if (CGRectGetWidth(UIScreen.mainScreen.bounds) > 330){
            buttonHeight = 44;
        }
        
        __block CGFloat y_Last = 0;
        [priceTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
             NSInteger horizontalPlace =  idx  % 3;
             NSInteger verticalPlace = idx / 3;
             
             UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
             [button addTarget:self action:@selector(moneyViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
             button.backgroundColor = [UIColor whiteColor];
             [button setTitle:obj forState:UIControlStateNormal];
             [button setTitleColor:UIColorFromRGB(0x576fe3, 1) forState:UIControlStateNormal];
             button.titleLabel.font = [UIFont systemFontOfSize:15];
             button.layer.cornerRadius = 5;
             button.clipsToBounds = YES;
             button.layer.borderWidth = 1;
             button.layer.borderColor = UIColorFromRGB(0x576fe3, 1).CGColor;
             button.tag = idx + 10;
             button.frame = CGRectMake(15 + horizontalPlace * (buttonWidth + 10) , 40 + verticalPlace * ( buttonHeight + 10 ), buttonWidth, buttonHeight);
             [view addSubview:button];
             
             y_Last = CGRectGetMaxY(button.frame);
             if (idx == 0){
                 _currentMoney = [obj intValue];
                 [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 button.backgroundColor = UIColorFromRGB(0x576fe3, 1);
             }
         }];
        
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, y_Last + 15, CGRectGetWidth(UIScreen.mainScreen.bounds), 10)];
        grayView.backgroundColor = TableGrayColor;
        [view addSubview:grayView];
        view.frame = CGRectMake(0, CGRectGetMaxY(self.safetyView.frame), CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetMaxY(grayView.frame));
        _moneyView = view;
    }
    return _moneyView;
}

- (UIView *)tableHeaderView{
    if (_tableHeaderView == nil){
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:self.qualityView];
        [view addSubview:self.safetyView];
        [view addSubview:self.moneyView];
        
        view.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetMaxY(self.moneyView.frame));
        _tableHeaderView = view;
    }
    return _tableHeaderView;
}

- (UIView *)tableFooterView{
    if (_tableFooterView == nil){
        UIView *footerView = [[UIView alloc]init];
        footerView.backgroundColor = [UIColor clearColor];
        CGFloat height = CGRectGetMaxY(self.moneyView.frame) + 85.0;
        height = MAX(70, CGRectGetHeight(UIScreen.mainScreen.bounds) - 64 - height);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"立即充值" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(footerViewRechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.backgroundColor = UIColorFromRGB(0x576fe3, 1);
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        button.frame = CGRectMake(15, (height - 40) / 2.0, CGRectGetWidth(UIScreen.mainScreen.bounds) - 30, 40);
        [footerView addSubview:button];
        footerView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), height);
        _tableFooterView = footerView;
    }
    return _tableFooterView;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        _tableView.sectionHeaderHeight = 35.0;
        _tableView.sectionFooterHeight = 0.01;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        [_tableView registerNib:[UINib nibWithNibName:@"RechargeMethodTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = self.tableFooterView;
    }
    
    return _tableView;
}


@end
