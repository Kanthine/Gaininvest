//
//  GainListViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/16.
//  Copyright © 2017年 longlong. All rights reserved.
//
#define CellIdentifer @"GainListTableCell"

#import "GainListViewController.h"
#import "GainListTableCell.h"

#import "ClosePositionDetaileVC.h"

#import "TransactionHttpManager.h"
#import <MJRefresh.h>

@interface GainListViewController ()
<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger _currentPage;
}



@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *noDataTipView;

@property (nonatomic ,strong) NSMutableArray<TradeModel *> *listArray;
@property (nonatomic ,strong) TransactionHttpManager *httpManager;
@end

@implementation GainListViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self pullDownRefreshData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)customNavBar
{
    self.navigationItem.title = @"今日盈利单";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (UIView *)noDataTipView
{
    if (_noDataTipView == nil)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        view.backgroundColor = RGBA(250, 250, 255, 1);
        
        //377 ： 263
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - 150) / 2.0, 100, 150, 105)];
        imageView.image = [UIImage imageNamed:@"noData"];
        [view addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, ScreenWidth, 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = TextColorGray;
        lable.font = [UIFont systemFontOfSize:15];
        lable.text = @"暂无可晒盈利单";
        [view addSubview:lable];
                
        _noDataTipView = view;
    }
    
    return _noDataTipView;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 71;
        _tableView.backgroundColor = RGBA(239, 239, 244, 1);
        [_tableView registerNib:[UINib nibWithNibName:@"GainListTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
        [self setTableViewRefresh];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GainListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    TradeModel *model = self.listArray[indexPath.row];

    [cell updateGainListTableCellWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TradeModel *model = self.listArray[indexPath.row];

    ClosePositionDetaileVC *detaileVC = [[ClosePositionDetaileVC alloc]initWithModel:model];
    [self.navigationController pushViewController:detaileVC animated:YES];
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
    [self requestNetworkGetTradeListData];
}

- (void)pullUpLoadData
{
    _currentPage ++;
    [self requestNetworkGetTradeListData];
}

/* 交易记录 */
- (void)requestNetworkGetTradeListData
{
    NSString *pageString = [NSString stringWithFormat:@"%d",_currentPage * 20];
    NSString *endPageString = [NSString stringWithFormat:@"%d",_currentPage * 20 + 20];
    __weak __typeof__(self) weakSelf = self;
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *dict = @{@"cur_page":pageString,@"cur_size":endPageString,
                           @"mobile_phone":account.username,@"type":@"cg",
                           @"st":[self getStartTime],@"et":[self getCurrentTime]};
    
    [self.httpManager accessTradeListWithParameterDict:dict CompletionBlock:^(NSMutableArray<TradeModel *> *listArray, NSError *error)
     {
         
         if (!error)
         {
             if (_currentPage == 0)
             {
                 
                 [weakSelf.listArray removeAllObjects];
                 
                 [listArray enumerateObjectsUsingBlock:^(TradeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                 {
                     
                     if (obj.plAmount > 0)
                     {
                         [weakSelf.listArray addObject:obj];
                     }
                     
                 }];
                 
                 
                 
                 [self stopRefreshWithMoreData:YES];
                 
                 if (_listArray.count == 0)
                 {
                     self.tableView.hidden = YES;
                     [self.view addSubview:self.noDataTipView];
                 }
                 else
                 {
                     [_noDataTipView removeFromSuperview];
                     _noDataTipView = nil;
                     self.tableView.hidden = NO;
                 }

             }
             else
             {
                 if (listArray.count)
                 {
                     [listArray enumerateObjectsUsingBlock:^(TradeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                      {
                          
                          if (obj.plAmount > 0)
                          {
                              [weakSelf.listArray addObject:obj];
                          }
                          
                      }];

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
    
    NSDate *startDate = [NSDate dateWithTimeInterval: -24 * 60 * 60 sinceDate:date];
    
    timeString = [formatter stringFromDate:startDate];
    
    
    return timeString;
}

- (void)sortArrayWithDate
{
    
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
   {
       //从小到大排序
       [weakSelf.listArray sortUsingComparator:^NSComparisonResult(TradeModel *obj1,TradeModel * obj2)
        {
            NSTimeInterval timeBetween = [[weakSelf getDateWithString:obj1.addTime] timeIntervalSinceDate:[weakSelf getDateWithString:obj2.addTime]];
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
