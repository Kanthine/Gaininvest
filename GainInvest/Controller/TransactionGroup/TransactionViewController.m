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

#import <Masonry.h>
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
    
    CGFloat _chartViewHeight;
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismissRechargeViewControllerNotification" object:nil];
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _chartViewHeight = ScreenHeight - 64 - 49 - 70 - 25 - 80;
        _isClosed = NO;
        _type = @"1";
        [self realTimeUpdate];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissRechargeViewControllerNotification:) name:@"dismissRechargeViewControllerNotification" object:nil];
    
    [self initNavBarItem];
    [self initSubView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
    {
        return;
    }
    
    [self timer];
    
    if ([AuthorizationManager isEffectiveToken])
    {
        [self accessBalanceOfAccount];
        [self accessCouponNumber];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    _timer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubView
{
    [self.view addSubview:self.tradeView];
    [self.tradeView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(@0);
         make.left.mas_equalTo(@0);
         make.right.mas_equalTo(@0);
         make.height.mas_equalTo(@70);
     }];
    
    [self.view addSubview:self.topSegmentView];
    [_topSegmentView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(_tradeView.mas_bottom);
         make.left.mas_equalTo(@0);
         make.height.mas_equalTo(@25);
         make.right.mas_equalTo(@0);
     }];
    
    [self.view addSubview:self.stockChartView];
    [_stockChartView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(_topSegmentView.mas_bottom);
         make.left.mas_equalTo(@0);
         make.right.mas_equalTo(@0);
     }];
    [self.view addSubview:self.timeLineChartView];
    [_timeLineChartView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(_topSegmentView.mas_bottom);
         make.left.mas_equalTo(@0);
         make.right.mas_equalTo(@0);
         make.height.equalTo(_stockChartView.mas_height);
     }];
    
    [self.view addSubview:self.footerView];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(_stockChartView.mas_bottom);
         make.left.mas_equalTo(@0);
         make.bottom.mas_equalTo(@0);
         make.right.mas_equalTo(@0);
         make.height.mas_equalTo(@80);
     }];
}

#pragma mark - NavBarItem

- (void)initNavBarItem
{
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_TitleView"]];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.clipsToBounds = YES;
//    imageView.frame = CGRectMake(0, 0, 60, 19);
//    self.navigationItem.titleView = imageView;

    self.navigationItem.title = @"白银";

    
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"排行榜" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)rightBarItemClick
{
    
    
}

- (TransactionBuyUpOrDownView *)buyProductView
{
    if (_buyProductView == nil)
    {
        _buyProductView = [[TransactionBuyUpOrDownView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _buyProductView.currentViewController = self;
        _buyProductView.isBuyUp = YES;
        
        __weak __typeof__(self) weakSelf = self;

        _buyProductView.transactionResultTip = ^(NSError *error)
        {
            
            OpenPositionResultTipView *tipView = [[OpenPositionResultTipView alloc]initWithError:error];
            tipView.openPositionLookPositionClick = ^()
            {
                [MainTabBarController setSelectedIndex:2];
            };
            tipView.openPositionLookAgainBuyClick = ^()
            {
                [weakSelf.buyProductView show];
            };
            [tipView show];
        };
        
    }
    
    return _buyProductView;
}

- (TimeLineStockChartView *)timeLineChartView
{
    if (_timeLineChartView == nil)
    {
        _timeLineChartView = [[TimeLineStockChartView alloc]initWithHeight:_chartViewHeight];
        
    }
    
    return _timeLineChartView;
}


- (TranscationTableSectionFooterView *)footerView
{
    if (_footerView == nil)
    {
        _footerView = [[TranscationTableSectionFooterView alloc]initWithReuseIdentifier:@""];
                
        [_footerView.leftButton addTarget:self action:@selector(footerViewLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.rightButton addTarget:self action:@selector(footerViewRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _footerView;
}

#pragma mark - FooterView ButtonClick

- (void)dismissRechargeViewControllerNotification:(NSNotification *)notification
{
    BOOL isBuyUp = [notification.userInfo[@"isBuyUp"] boolValue];
    
    if (isBuyUp)
    {
        [self footerViewLeftButtonClick];
    }
    else
    {
         [self footerViewRightButtonClick];
    }
}

- (void)footerViewLeftButtonClick
{
    
    if (_isClosed)
    {
        //休市中
        TransactionClosedTipView *closedTipView = [[TransactionClosedTipView alloc]init];
        [closedTipView show];
        closedTipView.closedTipConfirmButtonClick = ^()
        {
            [self closedTipKnowTransactionTime];
        };

        return;
    }
    
    if ([AuthorizationManager isLoginState] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    if ([AuthorizationManager isHaveFourLevelWithViewController:self IsNeedCancelClick:NO])
    {
        //买涨
        self.buyProductView.isBuyUp = YES;
        [self.buyProductView show];
    }
}

- (void)footerViewRightButtonClick
{

    if (_isClosed)
    {
        //休市中
        TransactionClosedTipView *closedTipView = [[TransactionClosedTipView alloc]init];
        [closedTipView show];
        closedTipView.closedTipConfirmButtonClick = ^()
        {
            [self closedTipKnowTransactionTime];
        };
        return;
    }

    if ([AuthorizationManager isLoginState] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    if ([AuthorizationManager isHaveFourLevelWithViewController:self IsNeedCancelClick:NO])
    {
        //买跌
        self.buyProductView.isBuyUp = NO;
        [self.buyProductView show];
    }
}

- (void)closedTipKnowTransactionTime
{
    LoadImageViewController *newTeach = [[LoadImageViewController alloc]initWithTitle:@"交易时间" ImagePath:[NewTeachBundle pathForResource:@"newTeachDetaile_01" ofType:@"png"]];
    newTeach.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newTeach animated:YES];
}

- (TransactionHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[TransactionHttpManager alloc]init];
    }
    
    return _httpManager;
}

- (NSTimer *)timer
{
    if (_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(realTimeUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    
    return _timer;
}


- (TradeDetaileView *)tradeView
{
    if (_tradeView == nil)
    {
        _tradeView = [[TradeDetaileView alloc]init];
    }
    
    return _tradeView;
}

- (StockTopSegmentView *)topSegmentView
{
    if(_topSegmentView == nil)
    {
        __weak __typeof__(self) weakSelf = self;

        _topSegmentView = [[StockTopSegmentView alloc]init];
        _topSegmentView.stockTopSegmentView = ^(NSString *type)
        {
            _type = type;

            NSString *string = [NSString stringWithFormat:@"查看k线图类型=%@",type];            
            [weakSelf accessK_TimeLineChart];
        };
    }
    return _topSegmentView;
}

- (StockChartView *)stockChartView
{
    if(_stockChartView == nil)
    {
        _stockChartView = [[StockChartView alloc]initWithHeight:_chartViewHeight];
    }
    return _stockChartView;
}


#pragma mark - Http Request

- (void)realTimeUpdate
{
    [self accessToMarketQuotation];
    [self accessK_TimeLineChart];
    [self accessProductList];
    [self accessBuyUpOrDown];
}

/* 获取行情报价 */
- (void)accessToMarketQuotation
{
    __weak __typeof__(self) weakSelf = self;
    
    [self.httpManager accessToMarketQuotationCompletionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         _isClosed = NO;
         if (error)
         {
             if (error.code == 1100)
             {
                 //休市
                 _isClosed = YES;
                 [weakSelf accessFalseToMarketQuotation];
             }
         }
         else
         {
             [weakSelf.tradeView updateTradeDetaileView:resultDict];
         }
         
     }];
}

/* 休市时获取行情报价的假数据 */
- (void)accessFalseToMarketQuotation
{
    __weak __typeof__(self) weakSelf = self;
    
    NSDictionary *parameterDict = @{@"contract":@"HGAG",@"type":@"2"};
    
    [self.httpManager accessK_TimeLineChartWithParameterDict:parameterDict CompletionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         if (resultDict && [resultDict isKindOfClass:[NSDictionary class]])
         {
             NSArray *dataArray = [resultDict objectForKey:@"dataList"];
             
             if (dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count)
             {
                 NSArray *array = dataArray.lastObject;
                 [weakSelf.tradeView updateFalseTradeDetaileView:array LastPrice:nil];
             }
         }
     }];
    
    NSDictionary *dict = @{@"contract":@"HGAG",@"type":@"1"};
    
    [self.httpManager accessK_TimeLineChartWithParameterDict:dict CompletionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         if (resultDict && [resultDict isKindOfClass:[NSDictionary class]])
         {
             NSLog(@"resultDict =======  %@",resultDict);
             
             NSArray *dataArray = [resultDict objectForKey:@"dataList"];
             
             if (dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count)
             {
                 NSString *string = [NSString stringWithFormat:@"%@",dataArray.lastObject];
                 [weakSelf.tradeView updateFalseTradeDetaileView:nil LastPrice:string];
             }
         }
     }];
    
    
    
}

/* 获取账户余额 */
- (void)accessBalanceOfAccount
{
    __weak __typeof__(self) weakSelf = self;
    
    if([AuthorizationManager isBindingMobile] == NO)
    {
        return;
    }
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *dict = @{@"mobile_phone":account.username};
    [self.httpManager accessBalanceOfAccountWithParameterDict:dict CompletionBlock:^(NSString *urlString, NSError *error)
     {
         if (error)
         {
             
         }
         else
         {
             weakSelf.buyProductView.balanceOfAccountString = urlString;
         }
     }];

}

/* 获取代金券数量 */
- (void)accessCouponNumber
{
    __weak __typeof__(self) weakSelf = self;
    
    [self.httpManager queryCouponCountCompletionBlock:^(NSUInteger count)
    {
        weakSelf.buyProductView.couponNumberString = [NSString stringWithFormat:@"%ld",(unsigned long)count];

    }];
}

/* 获取k-线图 */
- (void)accessK_TimeLineChart
{
    __weak __typeof__(self) weakSelf = self;
    
    NSDictionary *parameterDict = @{@"contract":@"HGAG",@"type":_type};
    
    
    
    [self.httpManager accessK_TimeLineChartWithParameterDict:parameterDict CompletionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         if (resultDict && [resultDict isKindOfClass:[NSDictionary class]])
         {
//             NSLog(@"resultDict =======  %@",resultDict);
             
             NSArray *dataArray = [resultDict objectForKey:@"dataList"];
             NSArray *dateArray = [resultDict objectForKey:@"dateList"];
             
             if (dataArray && dateArray && [dataArray isKindOfClass:[NSArray class]] && [dateArray isKindOfClass:[NSArray class]])
             {
                 
                 if ([_type isEqualToString:@"1"])
                 {
                     weakSelf.timeLineChartView.hidden = NO;
                     weakSelf.stockChartView.hidden = YES;
                     [weakSelf.stockChartView stockChartViewDisAppear];
                     
                     [weakSelf.timeLineChartView updateStockChartViewWithDataArray:dataArray DateArray:dateArray];
                 }
                 else
                 {
                     weakSelf.timeLineChartView.hidden = YES;
                     [weakSelf.timeLineChartView timeLineStockChartViewDisAppear];
                     weakSelf.stockChartView.hidden = NO;

                     Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithDataArray:dataArray DateArray:dateArray];
                     weakSelf.stockChartView.kLineModels = groupModel.models;
                     [weakSelf.stockChartView updateStockChartViewWithType:_type];
                 }
             }
         }
     }];
}

/* 获取产品列表 */
- (void)accessProductList
{
    __weak __typeof__(self) weakSelf = self;
    
    [self.httpManager accessProductListCompletionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         if (error)
         {
             
         }
         else
         {
             [weakSelf.buyProductView updateBuyUpOrDownProductInfoDict:resultDict];
         }
     }];
}

/* 获取买张买跌比例 */
- (void)accessBuyUpOrDown
{
    __weak __typeof__(self) weakSelf = self;
    
    [self.httpManager accessBuyUpOrDownCompletionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         if (error)
         {
             
         }
         else
         {
             int up = (int) ([resultDict[@"up"] floatValue] * 100 );
             int down = (int)([resultDict[@"down"] floatValue] * 100);
             
             weakSelf.footerView.leftLable.text = [NSString stringWithFormat:@"%d%% 用户买涨",up];
             weakSelf.footerView.rightLable.text = [NSString stringWithFormat:@"%d%% 用户买跌",down];
         }
     }];
}


@end
