//
//  TransactionViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/7.
//  Copyright © 2017年 苏沫离. All rights reserved.
//


#import "TransactionViewController.h"

#import "TransactionBuyUpOrDownView.h"
#import "TranscationTableSectionFooterView.h"
#import "TransactionClosedTipView.h"//休市提示
#import "LoadImageViewController.h"
#import "TradeDetaileView.h"

#import "StockTopSegmentView.h"
#import "StockChartView.h"//k-线图
#import "TimeLineStockChartView.h"//分时图

#import "Y_KLineGroupModel.h"

#import "OpenPositionResultTipView.h"
#import "MainTabBarController.h"

@interface TransactionViewController ()

{
    BOOL _isClosed;//休市
    NSString *_type;
}

@property (nonatomic ,strong) NSTimer *timer;

@property (nonatomic ,strong) TradeDetaileView *tradeView;
@property (nonatomic ,strong) StockTopSegmentView *topSegmentView;
@property (nonatomic, strong) StockChartView *stockChartView;//k-线图
@property (nonatomic, strong) TimeLineStockChartView *timeLineChartView;//分时图
@property (nonatomic, strong) TranscationTableSectionFooterView *footerView;
@property (nonatomic ,strong) TransactionBuyUpOrDownView *buyProductView;

@end

@implementation TransactionViewController

#pragma mark - life cycle

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismissRechargeViewControllerNotification" object:nil];
}

- (instancetype)init{
    self = [super init];
    if (self){
        _isClosed = NO;
        _type = @"1";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissRechargeViewControllerNotification:) name:@"dismissRechargeViewControllerNotification" object:nil];
    
    self.navigationItem.title = @"白银";

    [self.view addSubview:self.tradeView];
    [self.view addSubview:self.topSegmentView];
    [self.view addSubview:self.stockChartView];
    [self.view addSubview:self.timeLineChartView];
    [self.view addSubview:self.footerView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        return;
    }
    
    [self timer];
    [self realTimeUpdate];

    if ([AuthorizationManager isEffectiveToken]){
        [self accessBalanceOfAccount];
        [self accessCouponNumber];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tradeView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 70);
    self.topSegmentView.frame = CGRectMake(0, CGRectGetMaxY(self.tradeView.frame), CGRectGetWidth(self.view.bounds), 25);
    CGFloat height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.topSegmentView.frame) - 80;
    self.stockChartView.frame = CGRectMake(0, CGRectGetMaxY(self.topSegmentView.frame), CGRectGetWidth(self.view.bounds), height);
    self.timeLineChartView.frame = CGRectMake(0, CGRectGetMaxY(self.topSegmentView.frame), CGRectGetWidth(self.view.bounds), height);
    self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.stockChartView.frame), CGRectGetWidth(self.view.bounds), 80);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    _timer = nil;
}

#pragma mark - Notification

- (void)dismissRechargeViewControllerNotification:(NSNotification *)notification{
    BOOL isBuyUp = [notification.userInfo[@"isBuyUp"] boolValue];
    if (isBuyUp){
        [self footerViewLeftButtonClick];
    }else{
         [self footerViewRightButtonClick];
    }
}

#pragma mark - response click

- (void)footerViewLeftButtonClick{
    if (_isClosed){
        //休市中
        TransactionClosedTipView *closedTipView = [[TransactionClosedTipView alloc]init];
        [closedTipView show];
        closedTipView.closedTipConfirmButtonClick = ^(){
            [self closedTipKnowTransactionTime];
        };
        return;
    }
    
    if ([AuthorizationManager isLoginState] == NO){
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    if ([AuthorizationManager isHaveFourLevelWithViewController:self IsNeedCancelClick:NO]){
        //买涨
        self.buyProductView.isBuyUp = YES;
        [self.buyProductView show];
    }
}

- (void)footerViewRightButtonClick{
    if (_isClosed){
        //休市中
        TransactionClosedTipView *closedTipView = [[TransactionClosedTipView alloc]init];
        [closedTipView show];
        closedTipView.closedTipConfirmButtonClick = ^(){
            [self closedTipKnowTransactionTime];
        };
        return;
    }

    if ([AuthorizationManager isLoginState] == NO){
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    if ([AuthorizationManager isHaveFourLevelWithViewController:self IsNeedCancelClick:NO]){
        //买跌
        self.buyProductView.isBuyUp = NO;
        [self.buyProductView show];
    }
}

- (void)closedTipKnowTransactionTime{
    LoadImageViewController *newTeach = [[LoadImageViewController alloc]initWithTitle:@"交易时间" ImagePath:[NewTeachBundle pathForResource:@"newTeachDetaile_01" ofType:@"png"]];
    newTeach.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newTeach animated:YES];
}


#pragma mark - Http Request

- (void)realTimeUpdate{
    [self accessToMarketQuotation];
    [self accessK_TimeLineChart];
    [self accessProductList];
    [self accessBuyUpOrDown];
}

/* 获取行情报价 */
- (void)accessToMarketQuotation{
    _isClosed = NO;
    if (arc4random() % 4 == 0) {
        //休市
        _isClosed = YES;
        [self accessFalseToMarketQuotation];
    }else{
        [self.tradeView updateTradeDetaileView:@{@"createDate":@"9月23号",@"quote":@"700",@"preClose":@"520",@"open":@"550",@"high":@"760",@"low":@"500"}];
    }
}

/* 休市时获取行情报价的假数据 */
- (void)accessFalseToMarketQuotation{
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *dataList = [DemoData timeLineChartDatasWithType:@"2"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tradeView updateFalseTradeDetaileView:dataList LastPrice:dataList.lastObject];
        });
    });
}

/* 获取账户余额 */
- (void)accessBalanceOfAccount{
    if([AuthorizationManager isBindingMobile] == NO){
        return;
    }
    self.buyProductView.balanceOfAccountString = AccountInfo.standardAccountInfo.balance;
}

/* 获取代金券数量 */
- (void)accessCouponNumber{
    self.buyProductView.couponNumberString = [NSString stringWithFormat:@"%d",arc4random() % 30 + 1];
}

/* 获取k-线图 */
- (void)accessK_TimeLineChart{
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *dataArray = [DemoData timeLineChartDatasWithType:_type];
        NSArray *dateArray = [DemoData timeDatesWithType:_type];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_type isEqualToString:@"1"]){
                weakSelf.timeLineChartView.hidden = NO;
                weakSelf.stockChartView.hidden = YES;
                [weakSelf.stockChartView stockChartViewDisAppear];
                [weakSelf.timeLineChartView updateStockChartViewWithDataArray:dataArray DateArray:dateArray];
            }else{
                weakSelf.timeLineChartView.hidden = YES;
                [weakSelf.timeLineChartView timeLineStockChartViewDisAppear];
                weakSelf.stockChartView.hidden = NO;
                
                Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithDataArray:dataArray DateArray:dateArray];
                weakSelf.stockChartView.kLineModels = groupModel.models;
                [weakSelf.stockChartView updateStockChartViewWithType:_type];
            }
        });
    });
}

/* 获取产品列表 */
- (void)accessProductList{
    //price 从小到大排序
//    @"%@%@元/千克"
    NSArray *array = @[@{@"name":@"白银",@"weight":@"230",@"spec":@"斤",@"price":@"32.2",@"unit":@"￥",@"fee":@"1"},
                       @{@"name":@"黄金",@"weight":@"350",@"spec":@"千克",@"price":@"60.4",@"unit":@"￥",@"fee":@"5"},
                       @{@"name":@"钻石",@"weight":@"500",@"spec":@"克",@"price":@"90.8",@"unit":@"$",@"fee":@"10"}];
    [self.buyProductView updateBuyUpOrDownProductInfo:array];
}

/* 获取买张买跌比例 */
- (void)accessBuyUpOrDown{
    self.footerView.leftLable.text = @"35%% 用户买涨";
    self.footerView.rightLable.text = @"65%% 用户买跌";
}

#pragma mark - setter and getters

- (NSTimer *)timer{
    if (_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(realTimeUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}


- (TradeDetaileView *)tradeView{
    if (_tradeView == nil){
        _tradeView = [[TradeDetaileView alloc]init];
    }
    return _tradeView;
}

- (StockTopSegmentView *)topSegmentView{
    if(_topSegmentView == nil){
        __weak __typeof__(self) weakSelf = self;

        _topSegmentView = [[StockTopSegmentView alloc]init];
        _topSegmentView.stockTopSegmentView = ^(NSString *type){
            _type = type;
            [weakSelf accessK_TimeLineChart];
        };
    }
    return _topSegmentView;
}

- (StockChartView *)stockChartView{
    if(_stockChartView == nil){
        _stockChartView = [[StockChartView alloc]init];
    }
    return _stockChartView;
}

- (TransactionBuyUpOrDownView *)buyProductView{
    if (_buyProductView == nil){
        _buyProductView = [[TransactionBuyUpOrDownView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds))];
        _buyProductView.currentViewController = self;
        _buyProductView.isBuyUp = YES;
        
        __weak __typeof__(self) weakSelf = self;

        _buyProductView.transactionResultTip = ^(NSError *error){
            
            OpenPositionResultTipView *tipView = [[OpenPositionResultTipView alloc]initWithError:error];
            tipView.openPositionLookPositionClick = ^(){
                [MainTabBarController setSelectedIndex:2];
            };
            tipView.openPositionLookAgainBuyClick = ^(){
                [weakSelf.buyProductView show];
            };
            [tipView show];
        };
    }
    return _buyProductView;
}

- (TimeLineStockChartView *)timeLineChartView{
    if (_timeLineChartView == nil){
        _timeLineChartView = [[TimeLineStockChartView alloc]init];
    }
    return _timeLineChartView;
}

- (TranscationTableSectionFooterView *)footerView{
    if (_footerView == nil){
        _footerView = [[TranscationTableSectionFooterView alloc]initWithReuseIdentifier:@""];
        [_footerView.leftButton addTarget:self action:@selector(footerViewLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.rightButton addTarget:self action:@selector(footerViewRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

@end
