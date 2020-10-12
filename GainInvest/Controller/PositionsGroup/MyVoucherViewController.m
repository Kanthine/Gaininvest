//
//  MyVoucherViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"VoucherListTableCell"

#import "MyVoucherViewController.h"
#import "VoucherListTableCell.h"
#import "LoadImageViewController.h"


@interface MyVoucherViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UIView *noDataTipView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<CouponModel *> *listArray;

@end

@implementation MyVoucherViewController

#pragma mark - life cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"我的代金券";
    self.navigationItem.leftBarButtonItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"使用规则" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestNetworkGetData];
}

#pragma mark - response click

- (void)leftNavBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarItemClick{
    LoadImageViewController *newTeach = [[LoadImageViewController alloc]initWithTitle:@"代金券规则" ImagePath: [NewTeachBundle pathForResource:@"newTeachDetaile_04" ofType:@"png"]];
    newTeach.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newTeach animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoucherListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    CouponModel *model = self.listArray[indexPath.row];
    [cell updateVoucherListTableCellWithModel:model];
    return cell;
}

#pragma mark - RequestData

- (void)requestNetworkGetData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.listArray = [DemoData couponArrayWithType:@""];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setCoupongcount];
            [self.tableView reloadData];
        });
    });
}

- (void)setCoupongcount{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSUInteger num = 0;
        [_listArray enumerateObjectsUsingBlock:^(CouponModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
             NSTimeInterval interval = [self getRemainingTimeWithEndTime:obj.endTime];
             if (obj.flag == 1 && interval > 0){
                 num ++;
             }
         }];
        NSLog(@"num ========= %ld",num);
        [UserLocalData setCouponCount:num];
    });
}

- (NSTimeInterval)getRemainingTimeWithEndTime:(NSString *)endTime{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *date = [formatter dateFromString:endTime];
    
    NSTimeInterval timeBetween = [date timeIntervalSinceDate:[NSDate date]];
    return timeBetween;
}

#pragma mark - setter and getters

- (UIView *)noDataTipView{
    if (_noDataTipView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds) - 64)];
        view.backgroundColor = RGBA(250, 250, 255, 1);
        
        //377 ： 263
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(UIScreen.mainScreen.bounds) - 150) / 2.0, 100, 150, 105)];
        imageView.image = [UIImage imageNamed:@"noData"];
        [view addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, CGRectGetWidth(UIScreen.mainScreen.bounds), 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = TextColorGray;
        lable.font = [UIFont systemFontOfSize:15];
        lable.text = @"您当前没有可用的优惠券";
        [view addSubview:lable];
        _noDataTipView = view;
    }
    return _noDataTipView;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds) - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = RGBA(239, 239, 244, 1);
        
        // 664 ： 196
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        CGFloat cellHeight =  ( CGRectGetWidth(UIScreen.mainScreen.bounds) - 20 ) * 196 / 664.0 + 20.0;
        _tableView.rowHeight = cellHeight;
        [_tableView registerNib:[UINib nibWithNibName:@"VoucherListTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
    }
    
    return _tableView;
}
@end
