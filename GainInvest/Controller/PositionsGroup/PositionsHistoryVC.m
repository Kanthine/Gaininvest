//
//  PositionsHistoryVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/16.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"PositionsHistoryTableCell"
#define CellIIncomedentifer @"PositionsIncomeDetaileTableCell"
#define HeaderIdentifer @"PositionsHistoryTableSectionHeaderView"

#import "PositionsHistoryVC.h"

#import "PositionsHistoryTableCell.h"
#import "PositionsIncomeDetaileTableCell.h"
#import "PositionsHistoryTableHeaderView.h"
#import "PositionsHistoryTableSectionHeaderView.h"
#import "RechargeViewController.h"
#import "WithdrawViewController.h"
#import "MyVoucherViewController.h"
#import "MainTabBarController.h"

@interface PositionsHistoryVC ()
<UITableViewDelegate,UITableViewDataSource>

{
    BOOL _isTradeList;
}

@property (nonatomic ,strong) PositionsHistoryTableHeaderView *tableHeaderView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *noDataTipView;
@property (nonatomic ,strong) NSMutableArray<PositionsModel *> *listArray;

@end

@implementation PositionsHistoryVC

#pragma mark - setter and getters

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _isTradeList = YES;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([AuthorizationManager isEffectiveToken] == NO ||
        [UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        self.tableHeaderView.balanceLable.text = @"0.0";
        return;
    }
    
    [self pullDownRefreshData];
    /* 账户余额 */
    self.tableHeaderView.balanceLable.text = AccountInfo.standardAccountInfo.balance;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isTradeList){
        return 192;
    }
    return 72;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PositionsHistoryTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];

    [headerView.leftButton addTarget:self action:@selector(sectionHeaderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.rightButton addTarget:self action:@selector(sectionHeaderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isTradeList){
        headerView.leftButton.selected = YES;
        headerView.rightButton.selected = NO;
    }else{
        headerView.leftButton.selected = NO;
        headerView.rightButton.selected = YES;
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PositionsModel *model = self.listArray[indexPath.row];
    if (_isTradeList){
        PositionsHistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
        [cell updatePositionsHistoryTableCellWithModel:model];
        return cell;

    }else{
        PositionsIncomeDetaileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIIncomedentifer forIndexPath:indexPath];
        [cell updatePositionsHistoryTableCellWithModel:model];
        return cell;
    }
}

#pragma mark - response click

- (void)sectionHeaderButtonClick:(UIButton *)sender{
    if (sender.selected == YES){
        return;
    }
    sender.selected = YES;
    if (sender.tag == 2){
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

#pragma mark - Table Header Button Click

- (void)withdrawButtonClick{
    if ([AuthorizationManager isLoginState]){
        if ([AuthorizationManager isEffectiveToken]){
            //提现
            WithdrawViewController *withdrawVC = [[WithdrawViewController alloc]init];
            withdrawVC.accountMoney = AccountInfo.standardAccountInfo.balance;
            withdrawVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:withdrawVC animated:YES];
        }else{
            [AuthorizationManager getEffectiveTokenWithViewController:self IsNeedCancelClick:YES];
        }
    }else{
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
}

- (void)rechargeButtonClick{
    if ([AuthorizationManager isLoginState]){
        if ([AuthorizationManager isEffectiveToken]){
            //充值
            RechargeViewController *rechargeVC = [[RechargeViewController alloc]init];
            rechargeVC.hidesBottomBarWhenPushed = YES;
            rechargeVC.isBuyUp = -1;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }else{
            [AuthorizationManager getEffectiveTokenWithViewController:self IsNeedCancelClick:YES];
        }
    }else{
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
}

- (void)lookVoucherButtonClick{
    if ([AuthorizationManager isLoginState]){
        if ([AuthorizationManager isEffectiveToken]){
            //查看优惠券
            MyVoucherViewController *voucherVC = [[MyVoucherViewController alloc]init];
            voucherVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:voucherVC animated:YES];
        }else{
            [AuthorizationManager getEffectiveTokenWithViewController:self IsNeedCancelClick:YES];
        }
    }else{
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
}

#pragma mark - Request

- (void)pullDownRefreshData{
    if (_isTradeList){
        [self requestNetworkGetTradeListData];
    }else{
        [self requestNetworkGetIncomeDetaileListData];
    }
}

/* 交易记录 */
- (void)requestNetworkGetTradeListData{
    if ([AuthorizationManager isBindingMobile] == NO){
        return;
    }
    NSDictionary *dict = @{@"type":@"cg",@"st":[self getStartTime],@"et":[self getCurrentTime]};
    NSLog(@"dict ===== %@",dict);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.listArray = [DemoData accessTradeListWithParameterDict:dict];
        [self sortArrayWithDate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

/* 收支明细 ---- > 查询平仓流水 */
- (void)requestNetworkGetIncomeDetaileListData{
    NSDictionary *dict = @{@"type":@"all",@"st":[self getStartTime],@"et":[self getCurrentTime]};
    NSLog(@"dict ===== %@",dict);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.listArray = [DemoData accessIncomeDetaileListWithParameterDict:dict];
        [self sortArrayWithDate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (NSString *)getCurrentTime{
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

- (NSString *)getStartTime{
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

- (void)sortArrayWithDate{
    //从小到大排序
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf.listArray sortUsingComparator:^NSComparisonResult(PositionsModel *obj1,PositionsModel * obj2){
             NSTimeInterval timeBetween = [[weakSelf getDateWithString:obj1.addTime] timeIntervalSinceDate:[weakSelf getDateWithString:obj2.addTime]];
             
             // 平仓时 使用的是出价时间
             if ([obj1.remark containsString:@"平仓"] && [obj2.remark containsString:@"平仓"]){
                 timeBetween = [[weakSelf getDateWithString:obj1.sellTime] timeIntervalSinceDate:[weakSelf getDateWithString:obj2.sellTime]];
             }else if ([obj1.remark containsString:@"平仓"]){
                 timeBetween = [[weakSelf getDateWithString:obj1.sellTime] timeIntervalSinceDate:[weakSelf getDateWithString:obj2.addTime]];
             }else if ([obj2.remark containsString:@"平仓"]){
                 timeBetween = [[weakSelf getDateWithString:obj1.addTime] timeIntervalSinceDate:[weakSelf getDateWithString:obj2.sellTime]];
             }
                
             if (timeBetween < 0){
                 return NSOrderedDescending;
             }else{
                 return NSOrderedAscending;
             }
         }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    });
}

- (NSDate *)getDateWithString:(NSString *)timeString{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:timeString];
    return date;
}

#pragma mark - setter and getters

- (NSMutableArray<PositionsModel *> *)listArray{
    if (_listArray == nil){
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (PositionsHistoryTableHeaderView *)tableHeaderView{
    if (_tableHeaderView == nil){
        _tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"PositionsHistoryTableHeaderView" owner:nil options:nil].firstObject;
        _tableHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 140);
        [_tableHeaderView.lookMyCouponButton addTarget:self action:@selector(lookVoucherButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView.rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView.withdrawButton addTarget:self action:@selector(withdrawButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableHeaderView;
}

- (UIView *)noDataTipView{
    if (_noDataTipView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds) - 64 - 49 - CGRectGetHeight(self.tableHeaderView.frame))];
        view.backgroundColor = RGBA(250, 250, 255, 1);
        
        //377 ： 263
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(UIScreen.mainScreen.bounds) - 150) / 2.0, 50, 150, 105)];
        imageView.image = [UIImage imageNamed:@"noData"];
        [view addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, CGRectGetWidth(UIScreen.mainScreen.bounds), 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = TextColorGray;
        lable.font = [UIFont systemFontOfSize:15];
        lable.text = @"暂无数据";
        [view addSubview:lable];
        
        _noDataTipView = view;
    }
    return _noDataTipView;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 192;
        _tableView.backgroundColor = RGBA(239, 239, 244, 1);
        [_tableView registerNib:[UINib nibWithNibName:@"PositionsHistoryTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
        [_tableView registerNib:[UINib nibWithNibName:CellIIncomedentifer bundle:nil] forCellReuseIdentifier:CellIIncomedentifer];

        [_tableView registerClass:[PositionsHistoryTableSectionHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];

        _tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}

@end
