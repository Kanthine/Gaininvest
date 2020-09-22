//
//  ProfitRollViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/23.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"ProfitRollTableCell"
#define BottomHeight 49.0


#import "ProfitRollViewController.h"
#import "ProfitRollTableHeaderView.h"
#import "ProfitRollTableCell.h"
#import "GainListViewController.h"
#import "TransactionHttpManager.h"
#import "ProfitRollDeatileVC.h"

#import <Masonry.h>
#import <MJRefresh.h>

@interface ProfitRollViewController ()
<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger _currentPage;
}

@property (nonatomic ,strong) ProfitRollTableHeaderView *tableHeaderView;
@property (nonatomic ,strong) UIView *footerView;
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray<InorderModel *> *listArray;
@property (nonatomic ,strong) TransactionHttpManager *httpManager;

@end

@implementation ProfitRollViewController

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
    [self.view addSubview:self.footerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if ([AuthorizationManager isLoginState])
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        UIImageView *portraitImageView = [self.footerView viewWithTag:1];
        [portraitImageView sd_setImageWithURL:[NSURL URLWithString:account.head] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"盈利榜";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (ProfitRollTableHeaderView *)tableHeaderView
{
    if (_tableHeaderView == nil)
    {
        _tableHeaderView = [[ProfitRollTableHeaderView alloc]init];
        _tableHeaderView.viewController = self;
    }
    
    return _tableHeaderView;
}

- (UIView *)footerView
{
    if (_footerView == nil)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64 - BottomHeight, ScreenWidth, BottomHeight)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *portraitImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"owner_Header"]];
        portraitImageView.tag = 1;
        portraitImageView.layer.cornerRadius = 15;
        portraitImageView.clipsToBounds = YES;
        portraitImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:portraitImageView];
        [portraitImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.centerY.equalTo(view);
            make.left.mas_equalTo(@10);
            make.width.mas_equalTo(@30);
            make.height.mas_equalTo(@30);
        }];
        
        
        UILabel *lable = [[UILabel alloc]init];
        lable.text = @"立即晒单，占据榜首";
        lable.textColor = TextColorGray;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textAlignment = NSTextAlignmentLeft;
        [view addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(portraitImageView);
             make.left.equalTo(portraitImageView.mas_right).with.offset(8);
         }];
        
        CGFloat orderLableWidth = 42.0;
        UILabel *orderLable = [[UILabel alloc]init];
        orderLable.text = @"晒单";
        orderLable.textColor = [UIColor whiteColor];
        orderLable.font = [UIFont fontWithName:BoldFontName size:16];
        orderLable.textAlignment = NSTextAlignmentCenter;
        orderLable.backgroundColor = TextColorBlue;
        orderLable.layer.cornerRadius = orderLableWidth / 2.0;
        orderLable.clipsToBounds = YES;
        [view addSubview:orderLable];
        [orderLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@-8);
             make.right.mas_equalTo(@-10);
             make.width.mas_equalTo(@(orderLableWidth));
             make.height.mas_equalTo(@(orderLableWidth));
         }];
        CALayer *orderBackLayer = [CALayer layer];
        orderBackLayer.frame = CGRectMake(ScreenWidth - 10 - orderLableWidth,-8, orderLableWidth - 2, orderLableWidth - 2);
        orderBackLayer.backgroundColor = [UIColor whiteColor].CGColor;
        orderBackLayer.cornerRadius = orderLableWidth / 2.0 - 1;
        orderBackLayer.masksToBounds=NO;
        orderBackLayer.shadowColor=[UIColor blackColor].CGColor;
        orderBackLayer.shadowOffset=CGSizeMake(1,4);
        orderBackLayer.shadowOpacity = .8f;
        orderBackLayer.shadowRadius = 3;
        [view.layer insertSublayer:orderBackLayer below:orderLable.layer];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(orderButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.width.mas_equalTo(@100);
         }];
        
        _footerView = view;
    }
    
    return _footerView;
}

- (void)orderButtonClick
{
    if ([AuthorizationManager isLoginState] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    
    if ([AuthorizationManager isHaveFourLevelWithViewController:self IsNeedCancelClick:NO])
    {
        GainListViewController *gainListVC = [[GainListViewController alloc]init];
        [self.navigationController pushViewController:gainListVC animated:YES];
    }
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - BottomHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = RGBA(239, 239, 244, 1);

        
        [_tableView registerNib:[UINib nibWithNibName:@"ProfitRollTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listArray && self.listArray.count > 3)
    {
        return self.listArray.count - 3;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfitRollTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    
    InorderModel *model = self.listArray[indexPath.row];
    if (self.listArray && self.listArray.count > 3)
    {
        model = self.listArray[indexPath.row + 3];
    }
    
    [cell updateProfitRollTableCell:model];

    NSInteger rank = indexPath.row + 4;
    cell.rankingLable.text = [NSString stringWithFormat:@"%ld",(long)rank];
    
    if (rank < 11)
    {
        cell.priceLable.text = @"￥16";
    }
    else
    {
        cell.priceLable.text = @"￥8";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InorderModel *model = self.listArray[indexPath.row];
    if (self.listArray && self.listArray.count > 3)
    {
        model = self.listArray[indexPath.row + 3];
    }
    
    ProfitRollDeatileVC *detaileVC = [[ProfitRollDeatileVC alloc]initWithNibName:@"ProfitRollDeatileVC" bundle:nil];
    detaileVC.model = model;
    
    NSInteger rank = indexPath.row + 4;
    detaileVC.rankLevel = rank;
    if (rank < 11)
    {
        detaileVC.awardMoney = 16;
    }
    else
    {
        detaileVC.awardMoney = 8;
    }
    
    
    [self.navigationController pushViewController:detaileVC animated:YES];
    
}

#pragma mark - RequestData

- (TransactionHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[TransactionHttpManager alloc]init];
    }
    
    return _httpManager;
}

- (NSMutableArray<InorderModel *> *)listArray
{
    if (_listArray == nil)
    {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)requestNetworkGetData
{
    [self.httpManager inorderListCompletionBlock:^(NSMutableArray<InorderModel *> *listArray, NSError *error)
    {
        if (error)
        {
            
        }
        else
        {
            self.listArray = listArray;
            [self.tableHeaderView updateProfitRollTableHeaderView:listArray];
            [self.tableView reloadData];
        }
        
    }];
    
}


@end
