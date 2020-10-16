//
//  ProfitRollViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/23.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"ProfitRollTableCell"

#import "ProfitRollViewController.h"
#import "ProfitRollTableHeaderView.h"
#import "ProfitRollTableCell.h"
#import "GainListViewController.h"
#import "ProfitRollDeatileVC.h"

@interface ProfitRollViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) ProfitRollTableHeaderView *tableHeaderView;
@property (nonatomic ,strong) UIView *footerView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<InorderModel *> *listArray;
@end

@implementation ProfitRollViewController

#pragma mark - life cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"盈利榜";
    self.navigationItem.leftBarButtonItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [self requestNetworkGetData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([AuthorizationManager isLoginState]){
        AccountInfo *account = [AccountInfo standardAccountInfo];
        UIImageView *portraitImageView = [self.footerView viewWithTag:1];
        [portraitImageView sd_setImageWithURL:[NSURL URLWithString:account.head] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - getTabBarHeight());
    self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(self.view.bounds), getTabBarHeight());
}

#pragma mark - response click

- (void)leftNavBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)orderButtonClick{
    if ([AuthorizationManager isLoginState] == NO){
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    if ([AuthorizationManager isHaveFourLevelWithViewController:self IsNeedCancelClick:NO]){
        GainListViewController *gainListVC = [[GainListViewController alloc]init];
        [self.navigationController pushViewController:gainListVC animated:YES];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.listArray && self.listArray.count > 3){
        return self.listArray.count - 3;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfitRollTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    InorderModel *model = self.listArray[indexPath.row];
    if (self.listArray && self.listArray.count > 3){
        model = self.listArray[indexPath.row + 3];
    }
    
    [cell updateProfitRollTableCell:model];

    NSInteger rank = indexPath.row + 4;
    cell.rankingLable.text = [NSString stringWithFormat:@"%ld",(long)rank];
    
    if (rank < 11){
        cell.priceLable.text = @"￥16";
    }else{
        cell.priceLable.text = @"￥8";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InorderModel *model = self.listArray[indexPath.row];
    if (self.listArray && self.listArray.count > 3){
        model = self.listArray[indexPath.row + 3];
    }
    
    ProfitRollDeatileVC *detaileVC = [[ProfitRollDeatileVC alloc]initWithNibName:@"ProfitRollDeatileVC" bundle:nil];
    detaileVC.model = model;
    
    NSInteger rank = indexPath.row + 4;
    detaileVC.rankLevel = rank;
    if (rank < 11){
        detaileVC.awardMoney = 16;
    }else{
        detaileVC.awardMoney = 8;
    }
    [self.navigationController pushViewController:detaileVC animated:YES];
}

#pragma mark - RequestData

- (void)requestNetworkGetData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.listArray = InorderModel.inorderModelArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableHeaderView updateProfitRollTableHeaderView:self.listArray];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - setter and getters

- (ProfitRollTableHeaderView *)tableHeaderView{
    if (_tableHeaderView == nil){
        _tableHeaderView = [[ProfitRollTableHeaderView alloc]init];
        _tableHeaderView.viewController = self;
    }
    return _tableHeaderView;
}

- (UIView *)footerView{
    if (_footerView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), getTabBarHeight())];
        view.backgroundColor = [UIColor whiteColor];
        
        CGFloat contentHeight = 49.0;
        
        UIImageView *portraitImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"owner_Header"]];
        portraitImageView.tag = 1;
        portraitImageView.frame = CGRectMake(10, (contentHeight - 30) / 2.0, 30, 30);
        portraitImageView.layer.cornerRadius = 15;
        portraitImageView.clipsToBounds = YES;
        portraitImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:portraitImageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(portraitImageView.frame) + 8,  (contentHeight - 16) / 2.0, 160, 16)];
        lable.text = @"立即晒单，占据榜首";
        lable.textColor = TextColorGray;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textAlignment = NSTextAlignmentLeft;
        [view addSubview:lable];
        
        CGFloat orderLableWidth = 42.0;
        UILabel *orderLable = [[UILabel alloc]initWithFrame:CGRectMake(-8, CGRectGetWidth(view.bounds) - orderLableWidth + 10, orderLableWidth, orderLableWidth)];
        orderLable.text = @"晒单";
        orderLable.textColor = [UIColor whiteColor];
        orderLable.font = [UIFont fontWithName:BoldFontName size:16];
        orderLable.textAlignment = NSTextAlignmentCenter;
        orderLable.backgroundColor = TextColorBlue;
        orderLable.layer.cornerRadius = orderLableWidth / 2.0;
        orderLable.clipsToBounds = YES;
        [view addSubview:orderLable];
        
        CALayer *orderBackLayer = [CALayer layer];
        orderBackLayer.frame = CGRectMake(CGRectGetWidth(view.bounds) - 10 - orderLableWidth,-8, orderLableWidth - 2, orderLableWidth - 2);
        orderBackLayer.backgroundColor = [UIColor whiteColor].CGColor;
        orderBackLayer.cornerRadius = orderLableWidth / 2.0 - 1;
        orderBackLayer.masksToBounds = NO;
        orderBackLayer.shadowColor=[UIColor blackColor].CGColor;
        orderBackLayer.shadowOffset=CGSizeMake(1,4);
        orderBackLayer.shadowOpacity = .8f;
        orderBackLayer.shadowRadius = 3;
        [view.layer insertSublayer:orderBackLayer below:orderLable.layer];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 100, CGRectGetHeight(view.bounds));
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(orderButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        _footerView = view;
    }
    return _footerView;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStylePlain];
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

@end
