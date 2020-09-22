//
//  IncomeDetaileViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 longlong. All rights reserved.
//



#define CellIdentifer @"IncomeDetaileTableCell"



#import "IncomeDetaileViewController.h"

#import "TransactionHttpManager.h"
#import "IncomeDetaileTableCell.h"

#import <MJRefresh.h>


@interface IncomeDetaileViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) TransactionHttpManager *httpManager;

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<NSString *> *imagePathArray;

@end

@implementation IncomeDetaileViewController

- (void)dealloc
{
    _httpManager = nil;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
        [self requestNetworkGetData];
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
    self.navigationItem.title = @"收支明细";
    
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 75;
        [_tableView registerNib:[UINib nibWithNibName:@"IncomeDetaileTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IncomeDetaileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - RequestData

- (void)requestNetworkGetData
{
    
    NSDictionary *parametersDict = @{@"cur_page":@"1",@"cur_size":@"200",@"parent_id":@""};
    
    //    [self.httpManager getAreaListWithParameterDict:parametersDict CompletionBlock:^(NSMutableArray<AreaModel *> *listArray, NSError *error)
    //     {
    //         if (!error)
    //         {
    //             if (listArray.count)
    //             {
    //                 [self.areaListArray removeAllObjects];
    //                 [_areaListArray addObjectsFromArray:listArray];
    //             }
    //             else
    //             {
    //
    //             }
    //
    //             [self.tableView reloadData];
    //         }
    //         else
    //         {
    //
    //         }
    //
    //     }];
    
    
}

- (NSMutableArray *)imagePathArray
{
    if (_imagePathArray == nil)
    {
        _imagePathArray = [NSMutableArray array];
    }
    return _imagePathArray;
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

