//
//  PositionsContentVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/16.
//  Copyright © 2017年 苏沫离. All rights reserved.
//
//持仓


#define CellIdentifer @"PositionsTableCell"

#import "PositionsContentVC.h"
#import "PositionsTableCell.h"

#import "MainTabBarController.h"

@interface PositionsContentVC ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<OrderInfoModel *> *listArray;

@end

@implementation PositionsContentVC

#pragma mark - life cycle

- (void)dealloc{
    _timer = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([AuthorizationManager isEffectiveToken] == NO ||
        [UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        return;
    }
    [self timer];
    [self requestNetworkGetData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat height = MAX(CGRectGetHeight(self.view.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds) - 89 - 88 - 44);
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), height);
}

- (void)realTimeUpdate{
    [self.tableView reloadData];
    [self requestNetworkGetData];
}

#pragma mark - response click

- (IBAction)emptyDataGoTransactionButtonClick:(UIButton *)sender{
    UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabBar setSelectedIndex:1];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PositionsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.currentViewController = self;
    OrderInfoModel *model = self.listArray[indexPath.row];
    [cell updatePositionsTableCellWithModel:model];
    return cell;
}

#pragma mark - Request

- (void)requestNetworkGetData{
    if ([AuthorizationManager isBindingMobile]== NO){
        return;
    }
    
    [OrderInfoModel getAllPositions:^(NSMutableArray<OrderInfoModel *> * _Nonnull modelsArray) {
        self.listArray = modelsArray;
        [self.tableView reloadData];
    }];
}

#pragma mark - setter and getters

- (NSTimer *)timer{
    if (_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(realTimeUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (NSMutableArray<OrderInfoModel *> *)listArray{
    if (_listArray == nil){
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds) - 64 - 49 - 44) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 145;
        _tableView.backgroundColor = RGBA(239, 239, 244, 1);
        [_tableView registerNib:[UINib nibWithNibName:@"PositionsTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
    }
    return _tableView;
}

@end
