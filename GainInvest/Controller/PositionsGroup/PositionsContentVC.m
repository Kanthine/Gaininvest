//
//  PositionsContentVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/16.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"PositionsTableCell"

#import "PositionsContentVC.h"
#import "PositionsTableCell.h"

#import "TransactionHttpManager.h"
#import <MJRefresh.h>

#import "MainTabBarController.h"

@interface PositionsContentVC ()
<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger _currentPage;
}
@property (nonatomic ,strong) NSTimer *timer;

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<PositionsModel *> *listArray;

@end

@implementation PositionsContentVC

- (void)dealloc
{
    _httpManager = nil;
    _timer = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"-------------     持仓1     -----------------");

    
    if ([AuthorizationManager isEffectiveToken] == NO || [UIApplication sharedApplication].applicationState != UIApplicationStateActive)
    {
        return;
    }
    
    
    
    
    
    
    _currentPage = 1;
    self.tableView.hidden = NO;
    [self.tableView.mj_header beginRefreshing];
    [self timer];

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

#pragma mark - UITableViewDelegate

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49 - 44) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 145;
        _tableView.backgroundColor = RGBA(239, 239, 244, 1);
        [_tableView registerNib:[UINib nibWithNibName:@"PositionsTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
        
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
    PositionsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    cell.currentViewController = self;
    PositionsModel *model = self.listArray[indexPath.row];
    [cell updatePositionsTableCellWithModel:model];
    
    return cell;
}


- (IBAction)emptyDataGoTransactionButtonClick:(UIButton *)sender
{
    UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabBar setSelectedIndex:1];
}

- (TransactionHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[TransactionHttpManager alloc]init];
    }
    
    return _httpManager;
}


- (NSMutableArray<PositionsModel *> *)listArray
{
    if (_listArray == nil)
    {
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
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

- (void)realTimeUpdate
{
    [self requestNetworkGetData];
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
    //    _tableView.mj_footer = footer;
}

- (void)pullDownRefreshData
{
    _currentPage = 1;
    
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData)
    {
        self.tableView.mj_footer.state = MJRefreshStateIdle;
    }
    
    [self requestNetworkGetData];
    
}

- (void)pullUpLoadData
{
    _currentPage ++;
    
    [self requestNetworkGetData];
}

- (void)requestNetworkGetData
{
    if ([AuthorizationManager isBindingMobile]== NO)
    {
        [self stopRefreshWithMoreData:NO];
        return;
    }
    
    __weak __typeof__(self) weakSelf = self;
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *dict = @{@"mobile_phone":account.username};
    
    [self.httpManager accessOpenPositionListWithParameterDict:dict CompletionBlock:^(NSMutableArray<PositionsModel *> *listArray, NSError *error)
    {
        if (!error)
        {
            if (_currentPage == 1)
            {
                weakSelf.listArray = listArray;
                [weakSelf stopRefreshWithMoreData:YES];

            }
            else
            {
                if (listArray.count)
                {
                    [weakSelf.listArray addObjectsFromArray:listArray];
                    [weakSelf stopRefreshWithMoreData:YES];

                }
                else
                {
                    [weakSelf stopRefreshWithMoreData:NO];
                }
            }
            
            [weakSelf.tableView reloadData];
        }
        else
        {
            [weakSelf stopRefreshWithMoreData:NO];
            [ErrorTipView errorTip:error.domain SuperView:weakSelf.view];
        }
        

    }];
}


- (void)stopRefreshWithMoreData:(BOOL)isMoreData
{
    if (self.listArray.count == 0)
    {
        self.tableView.hidden = YES;
    }
    else
    {
        self.tableView.hidden = NO;
    }
    
    
    
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
    if (_listArray.count < 6)
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


@end
