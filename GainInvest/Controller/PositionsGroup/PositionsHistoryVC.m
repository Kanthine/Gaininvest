//
//  PositionsHistoryVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/16.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define ViewHeight (ScreenHeight - 64 - 49 - 44)
#define CellIdentifer @"PositionsHistoryTableCell"
#define CellIIncomedentifer @"PositionsIncomeDetaileTableCell"
#define HeaderIdentifer @"PositionsHistoryTableSectionHeaderView"

#import "PositionsHistoryVC.h"

#import "PositionsHistoryTableCell.h"
#import "PositionsIncomeDetaileTableCell.h"
#import "PositionsHistoryTableHeaderView.h"
#import "PositionsHistoryTableSectionHeaderView.h"

#import "IncomeDetaileViewController.h"
#import "RechargeViewController.h"
#import "WithdrawViewController.h"
#import "MyVoucherViewController.h"

#import "TransactionHttpManager.h"
#import "MainTabBarController.h"

#import <MJRefresh.h>

@interface PositionsHistoryVC ()
<UITableViewDelegate,UITableViewDataSource>

{
    BOOL _isTradeList;
    NSInteger _currentPage;
}

@property (nonatomic ,strong) PositionsHistoryTableHeaderView *tableHeaderView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *noDataTipView;
@property (nonatomic ,strong) NSMutableArray<TradeModel *> *listArray;
@property (nonatomic ,strong) TransactionHttpManager *httpManager;

@end

@implementation PositionsHistoryVC

- (void)dealloc
{
    _httpManager = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _currentPage = 0;
    _isTradeList = YES;
    [self.view addSubview:self.tableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([AuthorizationManager isEffectiveToken] == NO || [UIApplication sharedApplication].applicationState != UIApplicationStateActive)
    {
        self.tableHeaderView.balanceLable.text = @"0.0";
        return;
    }


    
    [self.tableView.mj_header beginRefreshing];
    [self requestNetworkGetBalanceOfAccount];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray<TradeModel *> *)listArray
{
    if (_listArray == nil)
    {
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
}

- (TransactionHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[TransactionHttpManager alloc]init];
    }
    
    return _httpManager;
}

- (PositionsHistoryTableHeaderView *)tableHeaderView
{
    if (_tableHeaderView == nil)
    {
        _tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"PositionsHistoryTableHeaderView" owner:nil options:nil].firstObject;
        _tableHeaderView.frame = CGRectMake(0, 0, ScreenWidth, 140);
        [_tableHeaderView.lookMyCouponButton addTarget:self action:@selector(lookVoucherButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView.rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView.withdrawButton addTarget:self action:@selector(withdrawButtonClick) forControlEvents:UIControlEventTouchUpInside];


    }
    
    return _tableHeaderView;
}

- (UIView *)noDataTipView
{
    if (_noDataTipView == nil)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49 - CGRectGetHeight(self.tableHeaderView.frame))];
        view.backgroundColor = RGBA(250, 250, 255, 1);
        
        //377 ： 263
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - 150) / 2.0, 50, 150, 105)];
        imageView.image = [UIImage imageNamed:@"noData"];
        [view addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, ScreenWidth, 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = TextColorGray;
        lable.font = [UIFont systemFontOfSize:15];
        lable.text = @"暂无数据";
        [view addSubview:lable];
        
        _noDataTipView = view;
    }
    
    return _noDataTipView;
}



- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ViewHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 192;
        _tableView.backgroundColor = RGBA(239, 239, 244, 1);
        [_tableView registerNib:[UINib nibWithNibName:@"PositionsHistoryTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
        [_tableView registerNib:[UINib nibWithNibName:CellIIncomedentifer bundle:nil] forCellReuseIdentifier:CellIIncomedentifer];

        [_tableView registerClass:[PositionsHistoryTableSectionHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];

        _tableView.tableHeaderView = self.tableHeaderView;
        
        [self setTableViewRefresh];

    }
    
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isTradeList)
    {
        return 192;
    }
    
    return 72;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PositionsHistoryTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];

    [headerView.leftButton addTarget:self action:@selector(sectionHeaderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.rightButton addTarget:self action:@selector(sectionHeaderButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    
    if (_isTradeList)
    {
        headerView.leftButton.selected = YES;
        headerView.rightButton.selected = NO;
    }
    else
    {
        headerView.leftButton.selected = NO;
        headerView.rightButton.selected = YES;
    }
    
    
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeModel *model = self.listArray[indexPath.row];
    if (_isTradeList)
    {
        PositionsHistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
        [cell updatePositionsHistoryTableCellWithModel:model];
        return cell;

    }
    else
    {
        PositionsIncomeDetaileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIIncomedentifer forIndexPath:indexPath];
        [cell updatePositionsHistoryTableCellWithModel:model];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - SectionHeader Button Click

- (void)sectionHeaderButtonClick:(UIButton *)sender
{
    if (sender.selected == YES)
    {
        return;
    }
    
    sender.selected = YES;
    if (sender.tag == 2)
    {
        UIButton *button = [sender.superview viewWithTag:3];
        button.selected = NO;
        _isTradeList = YES;
    }else if (sender.tag == 3){
        UIButton *button = [sender.superview viewWithTag:2];
        button.selected = NO;
        _isTradeList = NO;
    }
    [self pullDownRefreshData];    
}

- (void)incomeDetaileButtonClick
{
    //收支明细
    IncomeDetaileViewController *incomeVC = [[IncomeDetaileViewController alloc]init];
    incomeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:incomeVC animated:YES];
}


#pragma mark - Table Header Button Click

- (void)withdrawButtonClick
{
    if ([AuthorizationManager isLoginState])
    {
        if ([AuthorizationManager isEffectiveToken])
        {
            //提现
            WithdrawViewController *withdrawVC = [[WithdrawViewController alloc]init];
            withdrawVC.accountMoney = self.tableHeaderView.balanceLable.text;
            withdrawVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:withdrawVC animated:YES];
        }
        else
        {
            [AuthorizationManager getEffectiveTokenWithViewController:self IsNeedCancelClick:YES];
        }

    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
    
}

- (void)rechargeButtonClick
{
    if ([AuthorizationManager isLoginState])
    {
        
        if ([AuthorizationManager isEffectiveToken])
        {
            //充值
            RechargeViewController *rechargeVC = [[RechargeViewController alloc]init];
            rechargeVC.hidesBottomBarWhenPushed = YES;
            rechargeVC.isBuyUp = -1;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
        else
        {
            [AuthorizationManager getEffectiveTokenWithViewController:self IsNeedCancelClick:YES];
        }
        
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }

    
}

- (void)lookVoucherButtonClick
{
    if ([AuthorizationManager isLoginState])
    {
        
        if ([AuthorizationManager isEffectiveToken])
        {
            //查看优惠券
            MyVoucherViewController *voucherVC = [[MyVoucherViewController alloc]init];
            voucherVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:voucherVC animated:YES];
        }
        else
        {
            [AuthorizationManager getEffectiveTokenWithViewController:self IsNeedCancelClick:YES];
        }
        
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }

}

#pragma mark - Request

- (void)setTableViewRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
                            {
                                [weakSelf pullDownRefreshData];
                            }];
    
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
                                         {
                                             [weakSelf pullUpLoadData];
                                         }];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    _tableView.mj_footer = footer;
}

- (void)pullDownRefreshData
{
    _currentPage = 0;
    
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData)
    {
        self.tableView.mj_footer.state = MJRefreshStateIdle;
    }
    
    if (_isTradeList)
    {
        [self requestNetworkGetTradeListData];
    }
    else
    {
        [self requestNetworkGetIncomeDetaileListData];
    }
    
    
}

- (void)pullUpLoadData
{
    _currentPage ++;
    
    if (_isTradeList)
    {
        [self requestNetworkGetTradeListData];
    }
    else
    {
        [self requestNetworkGetIncomeDetaileListData];
    }
}

/* 交易记录 */
- (void)requestNetworkGetTradeListData
{
    if ([AuthorizationManager isBindingMobile] == NO)
    {
        [self stopRefreshWithMoreData:NO];
        return;
    }
    
    NSString *pageString = [NSString stringWithFormat:@"%ld",_currentPage * 20];
    NSString *endPageString = [NSString stringWithFormat:@"%ld",_currentPage * 20 + 20];
    __weak __typeof__(self) weakSelf = self;

    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *dict = @{@"cur_page":pageString,@"cur_size":endPageString,
                           @"mobile_phone":account.username,@"type":@"cg",
                           @"st":[self getStartTime],@"et":[self getCurrentTime]};
    
    
    NSLog(@"dict ===== %@",dict);
    
    [self.httpManager accessTradeListWithParameterDict:dict CompletionBlock:^(NSMutableArray<TradeModel *> *listArray, NSError *error)
     {
         
         if (!error)
         {
             if (_currentPage == 0)
             {
                 weakSelf.listArray = listArray;
                 [self stopRefreshWithMoreData:YES];
             }
             else
             {
                 if (listArray.count)
                 {
                     [weakSelf.listArray addObjectsFromArray:listArray];
                     [self stopRefreshWithMoreData:YES];
                 }
                 else
                 {
                     [self stopRefreshWithMoreData:NO];
                 }
             }
             [self sortArrayWithDate];
                          
             [self.tableView reloadData];
         }
         else
         {
             [self stopRefreshWithMoreData:NO];
         }

        
    }];    
}

/* 收支明细 ---- > 查询平仓流水 */
- (void)requestNetworkGetIncomeDetaileListData
{
    NSString *pageString = [NSString stringWithFormat:@"%ld",_currentPage * 20];
    NSString *endPageString = [NSString stringWithFormat:@"%ld",_currentPage * 20 + 20];

    __weak __typeof__(self) weakSelf = self;
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *dict = @{@"cur_page":pageString,@"cur_size":endPageString,
                           @"mobile_phone":account.username,@"type":@"all",
                           @"st":[self getStartTime],@"et":[self getCurrentTime]};
    
    NSLog(@"dict ===== %@",dict);

    [self.httpManager accessIncomeDetaileListWithParameterDict:dict CompletionBlock:^(NSMutableArray<TradeModel *> *listArray, NSError *error)
     {
         
         if (!error)
         {
             if (_currentPage == 0)
             {
                 weakSelf.listArray = listArray;
                 [self stopRefreshWithMoreData:YES];
             }
             else
             {
                 if (listArray.count)
                 {
                     [weakSelf.listArray addObjectsFromArray:listArray];
                     [self stopRefreshWithMoreData:YES];
                 }
                 else
                 {
                     [self stopRefreshWithMoreData:NO];
                 }
             }
             [self sortArrayWithDate];
             [self.tableView reloadData];
         }
         else
         {
             [self stopRefreshWithMoreData:NO];
         }
         
         
     }];
    
    
}

/* 账户余额 */
- (void)requestNetworkGetBalanceOfAccount
{
    __weak __typeof__(self) weakSelf = self;

    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *dict = @{@"mobile_phone":account.username};
    [self.httpManager accessBalanceOfAccountWithParameterDict:dict CompletionBlock:^(NSString *urlString, NSError *error)
    {
        if (error)
        {
            
        }
        else
        {
            weakSelf.tableHeaderView.balanceLable.text = urlString;
        }
        
    }];
}

- (void)stopRefreshWithMoreData:(BOOL)isMoreData
{
    if ([_tableView.mj_header isRefreshing])
    {
        [_tableView.mj_header endRefreshing];
    }
    
    if ([_tableView.mj_footer isRefreshing])
    {
        if (isMoreData)
        {
            [_tableView.mj_footer endRefreshing];
        }
        else
        {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)_tableView.mj_footer;
    //如果底部 提示字体在界面上，则设置空
    if (_listArray.count < 19)
    {
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    }
    else
    {
        [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
    }
    
    
    if (_listArray.count == 0 || _listArray == nil)
    {
        self.tableView.tableFooterView = self.noDataTipView;
    }
    else
    {
        self.tableView.tableFooterView = nil;
        _noDataTipView = nil;
    }
    
}


- (NSString *)getCurrentTime
{
    NSString *timeString = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *date = [NSDate date];
    NSDate *endDate = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:date];
    timeString = [formatter stringFromDate:endDate];
    return timeString;
}

- (NSString *)getStartTime
{
    NSString *timeString = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *date = [NSDate date];
    
    NSDate *startDate = [NSDate dateWithTimeInterval:-28 * 24 * 60 * 60 sinceDate:date];
    
    timeString = [formatter stringFromDate:startDate];
    
    return timeString;
}

- (void)sortArrayWithDate
{
    //从小到大排序
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        [weakSelf.listArray sortUsingComparator:^NSComparisonResult(TradeModel *obj1,TradeModel * obj2)
         {
             NSTimeInterval timeBetween = [[weakSelf getDateWithString:obj1.addTime] timeIntervalSinceDate:[weakSelf getDateWithString:obj2.addTime]];
             
             // 平仓时 使用的是出价时间
             if ([obj1.remark containsString:@"平仓"] && [obj2.remark containsString:@"平仓"])
             {
                 timeBetween = [[weakSelf getDateWithString:obj1.sellTime] timeIntervalSinceDate:[weakSelf getDateWithString:obj2.sellTime]];
             }
             else if ([obj1.remark containsString:@"平仓"])
             {
                 timeBetween = [[weakSelf getDateWithString:obj1.sellTime] timeIntervalSinceDate:[weakSelf getDateWithString:obj2.addTime]];
             }
             else if ([obj2.remark containsString:@"平仓"])
             {
                 timeBetween = [[weakSelf getDateWithString:obj1.addTime] timeIntervalSinceDate:[weakSelf getDateWithString:obj2.sellTime]];
             }
             
             
             if (timeBetween < 0)
             {
                 return NSOrderedDescending;
             }
             else
             {
                 return NSOrderedAscending;
             }
         }];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [weakSelf.tableView reloadData];
                       });
    });
}

- (NSDate *)getDateWithString:(NSString *)timeString
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    
    NSDate *date = [formatter dateFromString:timeString];
    
    return date;

}

@end
