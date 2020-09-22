//
//  ChooseProvinceCityVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 longlong. All rights reserved.
//
#define CellIdentifer @"UITableViewCell"


#import "ChooseProvinceCityVC.h"
#import "TransactionHttpManager.h"

#import <MJRefresh.h>

@interface ChooseProvinceCityVC ()

<UITableViewDelegate,UITableViewDataSource>

{
    AreaModel *_superModel;
    AreaModel *_currentModel;
    
    NSInteger _areaRank;
    
    NSString *_parentIdString;
}

@property (nonatomic ,strong) TransactionHttpManager *httpManager;

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<AreaModel *> *areaListArray;

@end

@implementation ChooseProvinceCityVC

- (void)dealloc
{
    _httpManager = nil;
}

- (instancetype)initWithSuperModel:(AreaModel *)model AreaRank:(NSInteger)areaRank
{
    self = [super init];
    
    if (self)
    {
        if (areaRank == 1)
        {
            _currentModel = model;
        }
        else if (areaRank == 2)
        {
            _superModel = model;
        }
        
        
        _areaRank = areaRank;
        
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
    self.navigationItem.title = @"选择地区";
    
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
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 45;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifer];
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.areaListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    AreaModel *areaModel = _areaListArray[indexPath.row];
    
    if (_areaRank == 1)
    {
        if ([areaModel.internalBaseClassIdentifier isEqualToString:_currentModel.internalBaseClassIdentifier] || [areaModel.name isEqualToString:_currentModel.name])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    
    cell.textLabel.textColor = TextColorBlack;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = areaModel.name;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AreaModel *areaModel = _areaListArray[indexPath.row];

    if (_areaRank == 1)
    {
        _currentModel = areaModel;
        ChooseProvinceCityVC *provinceCityVC  = [[ChooseProvinceCityVC alloc]initWithSuperModel:areaModel AreaRank:2];
        provinceCityVC.delegate = self.delegate;
        provinceCityVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:provinceCityVC animated:YES];
    }
    else if (_areaRank == 2)
    {
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if ([obj isKindOfClass:NSClassFromString(@"WithdrawViewController")] ||
                [obj isKindOfClass:NSClassFromString(@"RechargeInfomationVC")])
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidSelectAreaArray:)])
                {
                    [self.delegate tableViewDidSelectAreaArray:@[_superModel,areaModel]];
                }
                
                
                
                
                [self.navigationController popToViewController:obj animated:YES];
                * stop = YES;
            }
        }];
    }
}

#pragma mark - RequestData

- (void)requestNetworkGetData
{
    NSString *areaId = @"0";
    if (_superModel)
    {
        areaId = _superModel.internalBaseClassIdentifier;
    }
    
    
    NSDictionary *parametersDict = @{@"cur_page":@"1",@"cur_size":@"200",@"parent_id":areaId};

    [self.httpManager getAreaListWithParameterDict:parametersDict CompletionBlock:^(NSMutableArray<AreaModel *> *listArray, NSError *error)
    {
        if (!error)
        {
            if (listArray.count)
            {
                [self.areaListArray removeAllObjects];
                [_areaListArray addObjectsFromArray:listArray];
            }
            else
            {
                
            }
            
            [self.tableView reloadData];
        }
        else
        {
        }

    }];
    

}

- (NSMutableArray<AreaModel *> *)areaListArray
{
    if (_areaListArray == nil)
    {
        _areaListArray = [NSMutableArray array];

    }
    return _areaListArray;
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
