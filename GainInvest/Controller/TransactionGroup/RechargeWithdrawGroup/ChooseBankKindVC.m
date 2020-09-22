//
//  ChooseBankKindVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"UITableViewCell"


#import "ChooseBankKindVC.h"

#import "TransactionHttpManager.h"
#import <MJRefresh.h>

@interface ChooseBankKindVC ()
<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger _currentPage;
}

@property (nonatomic ,strong) TransactionHttpManager *httpManager;

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<NSDictionary *> *bankListArray;
@end

@implementation ChooseBankKindVC

- (void)dealloc
{
    _httpManager = nil;
}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _currentPage = 1;
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
    self.navigationItem.title = @"选择银行";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 45;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifer];
        _tableView.tableFooterView = [UIView new];
        [self setTableViewRefresh];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bankListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    NSString *rankString = _bankListArray[indexPath.row][@"bankName"];
    if ([rankString isEqualToString:self.rankString])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    
    
    cell.textLabel.textColor = TextColorBlack;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = rankString;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidSelectRankKind:)])
    {
        NSDictionary *ranDict = _bankListArray[indexPath.row];

        [self.delegate tableViewDidSelectRankKind:ranDict];
    }
    [self leftNavBarButtonClick];
}

#pragma mark - RequestData

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
//    NSString *pageString = [NSString stringWithFormat:@"%ld",_currentPage];
    
    
    [self.httpManager getBankListCompletionBlock:^(NSMutableArray<NSDictionary *> *listArray, NSError *error)
    {
        if (!error)
        {
            if (_currentPage == 1)
            {
                [self stopRefreshWithMoreData:YES];
                _bankListArray = listArray;
            }
            else
            {
                if (listArray.count)
                {
                    [self stopRefreshWithMoreData:YES];
                    [_bankListArray addObjectsFromArray:listArray];
                }
                else
                {
                    [self stopRefreshWithMoreData:NO];
                }
            }
            
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
    if (_bankListArray.count < 6)
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


- (NSMutableArray<NSDictionary *> *)rankListArray
{
    if (_bankListArray == nil)
    {
        _bankListArray = [NSMutableArray array];
        
//        [_bankListArray addObject:@"中国银行"];
//        [_bankListArray addObject:@"摩根大通"];
//        [_bankListArray addObject:@"联邦银行"];
//        [_bankListArray addObject:@"花旗银行"];
//        [_bankListArray addObject:@"建设银行"];
//        [_bankListArray addObject:@"工商银行"];
//        [_bankListArray addObject:@"农业银行"];
//        [_bankListArray addObject:@"招商银行"];
//        [_bankListArray addObject:@"交通银行"];
//        [_bankListArray addObject:@"光大银行"];
//        [_bankListArray addObject:@"民生银行"];
//        [_bankListArray addObject:@"浦发银行"];
//        [_bankListArray addObject:@"兴业银行"];
//        [_bankListArray addObject:@"协和银行"];
//        [_bankListArray addObject:@"首都银行"];
    }
    
    return _bankListArray;
}

- (TransactionHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[TransactionHttpManager alloc]init];
    }
    
    return _httpManager;
}




@end
