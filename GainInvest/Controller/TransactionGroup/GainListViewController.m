//
//  GainListViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/16.
//  Copyright © 2017年 苏沫离. All rights reserved.
//
#define CellIdentifer @"GainListTableCell"

#import "GainListViewController.h"
#import "GainListTableCell.h"

#import "ClosePositionDetaileVC.h"

@interface GainListViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *noDataTipView;

@property (nonatomic ,strong) NSMutableArray<TradeModel *> *listArray;
@end

@implementation GainListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"今日盈利单";
    self.navigationItem.leftBarButtonItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestNetworkGetTradeListData];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)leftNavBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GainListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    TradeModel *model = self.listArray[indexPath.row];
    [cell updateGainListTableCellWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TradeModel *model = self.listArray[indexPath.row];
    ClosePositionDetaileVC *detaileVC = [[ClosePositionDetaileVC alloc]initWithModel:model];
    [self.navigationController pushViewController:detaileVC animated:YES];
}

#pragma mark - Request

/* 交易记录 */
- (void)requestNetworkGetTradeListData{
    NSDictionary *dict = @{@"type":@"cg",@"st":[self getStartTime],@"et":[self getCurrentTime]};
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<TradeModel *> *listArray = [DemoData accessTradeListWithParameterDict:dict];
        [self.listArray removeAllObjects];
        [listArray enumerateObjectsUsingBlock:^(TradeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
             if (obj.plAmount > 0){
                 [self.listArray addObject:obj];
             }
         }];
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
    NSDate *startDate = [NSDate dateWithTimeInterval: -24 * 60 * 60 sinceDate:date];
    timeString = [formatter stringFromDate:startDate];
    return timeString;
}

- (void)sortArrayWithDate{
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //从小到大排序
       [weakSelf.listArray sortUsingComparator:^NSComparisonResult(TradeModel *obj1,TradeModel * obj2){
            NSTimeInterval timeBetween = [[weakSelf getDateWithString:obj1.addTime] timeIntervalSinceDate:[weakSelf getDateWithString:obj2.addTime]];
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

- (NSMutableArray<TradeModel *> *)listArray{
    if (_listArray == nil){
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (UIView *)noDataTipView{
    if (_noDataTipView == nil){
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

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 71;
        _tableView.backgroundColor = RGBA(239, 239, 244, 1);
        [_tableView registerNib:[UINib nibWithNibName:@"GainListTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
    }
    return _tableView;
}

@end
