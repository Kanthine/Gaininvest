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
}

@property (nonatomic ,strong) NSTimer *timer;


@property (nonatomic ,strong) NSOperationQueue *operationQueue;

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
    __weak __typeof__(self) weakSelf = self;
    _isClosed = !arc4random() % 4;//休市
    
    /* 获取k-线图 */
    [StockCurrentData timerUpdateStockData:^(StockCurrentData *stockData) {
        if (_isClosed) {
            [weakSelf.tradeView updateFalseTradeDetaileView:stockData.dataArray LastPrice:stockData.dataArray.lastObject];
        }else{
            [weakSelf.tradeView updateTradeDetaileView:StockCurrentData.currentStock];
        }
        
        if ([stockData.type isEqualToString:@"1"]){
            weakSelf.timeLineChartView.hidden = NO;
            weakSelf.stockChartView.hidden = YES;
            [weakSelf.stockChartView stockChartViewDisAppear];
            [weakSelf.timeLineChartView updateStockChartViewWithDataArray:stockData.dataArray DateArray:stockData.dateArray];
        }else{
            weakSelf.timeLineChartView.hidden = YES;
            [weakSelf.timeLineChartView timeLineStockChartViewDisAppear];
            weakSelf.stockChartView.hidden = NO;
            
            Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithDataArray:stockData.dataArray DateArray:stockData.dateArray];
            weakSelf.stockChartView.kLineModels = groupModel.models;
            [weakSelf.stockChartView updateStockChartViewWithType:stockData.type];
        }
    }];
    
    /* 获取产品列表 */
    [self.buyProductView updateBuyUpOrDownProductInfo:ProductInfoModel.shareProducts];

    /* 获取买张买跌比例 */
    self.footerView.leftLable.text = @"35%% 用户买涨";
    self.footerView.rightLable.text = @"65%% 用户买跌";
    
    /* 获取账户余额 */
    if([AuthorizationManager isBindingMobile]){
        self.buyProductView.balanceOfAccountString = AccountInfo.standardAccountInfo.balance;
    }
}

/* 获取代金券数量 */
- (void)accessCouponNumber{
    self.buyProductView.couponNumberString = [NSString stringWithFormat:@"%d",arc4random() % 30 + 1];
}

#pragma mark - setter and getters

- (NSOperationQueue *)operationQueue{
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

- (NSTimer *)timer{
    if (_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(realTimeUpdate) userInfo:nil repeats:YES];
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
            StockCurrentData.currentStock.type = type;
            [weakSelf realTimeUpdate];
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




