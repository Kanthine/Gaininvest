//
//  MyVoucherViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define CellIdentifer @"VoucherListTableCell"



#import "MyVoucherViewController.h"

#import "VoucherListTableCell.h"
#import "LoadImageViewController.h"

#import "TransactionHttpManager.h"

#import <MJRefresh.h>



@interface MyVoucherViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) TransactionHttpManager *httpManager;

@property (nonatomic ,strong) UIView *noDataTipView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<CouponModel *> *listArray;

@end

@implementation MyVoucherViewController

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
    self.navigationItem.title = @"我的代金券";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//rightButton
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"使用规则" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];

}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightBarItemClick
{
    LoadImageViewController *newTeach = [[LoadImageViewController alloc]initWithTitle:@"代金券规则" ImagePath: [NewTeachBundle pathForResource:@"newTeachDetaile_04" ofType:@"png"]];
    newTeach.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newTeach animated:YES];
}

- (UIView *)noDataTipView
{
    if (_noDataTipView == nil)
    {
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
        lable.text = @"您当前没有可用的优惠券";
        [view addSubview:lable];
        
        
        
        _noDataTipView = view;
    }
    
    return _noDataTipView;
}


- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = RGBA(239, 239, 244, 1);
        
        // 664 ： 196
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        CGFloat cellHeight =  ( ScreenWidth - 20 ) * 196 / 664.0 + 20.0;
        _tableView.rowHeight = cellHeight;
        [_tableView registerNib:[UINib nibWithNibName:@"VoucherListTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoucherListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];

    CouponModel *model = self.listArray[indexPath.row];
    [cell updateVoucherListTableCellWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - RequestData

- (void)requestNetworkGetData
{
    AccountInfo *accout = [AccountInfo standardAccountInfo];
    
    NSDictionary *parametersDict = @{@"cur_page":@"0",@"cur_size":@"20",@"mobile_phone":accout.username,@"coupon_type":@""};
    [self.httpManager accessCouponListWithParameterDict:parametersDict CompletionBlock:^(NSMutableArray<CouponModel *> *listArray, NSError *error)
    {
        if (!error)
        {
            if (listArray)
            {
                [self.listArray removeAllObjects];
                [_listArray addObjectsFromArray:listArray];
                
                
                if (_listArray.count == 0)
                {
                    [self.view addSubview:self.noDataTipView];
                    self.tableView.hidden = YES;
                }
                else
                {
                    [_noDataTipView removeFromSuperview];
                    _noDataTipView = nil;
                    self.tableView.hidden = NO;
                }
                [self setCoupongcount];
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

- (NSMutableArray<CouponModel *> *)listArray
{
    if (_listArray == nil)
    {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


- (TransactionHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[TransactionHttpManager alloc]init];
    }
    
    return _httpManager;
}

- (void)setCoupongcount
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        
        __block NSUInteger num = 0;
        [_listArray enumerateObjectsUsingBlock:^(CouponModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             NSTimeInterval interval = [self getRemainingTimeWithEndTime:obj.endTime];
             if (obj.flag == 1 && interval > 0)
             {
                 num ++;
             }
         }];
        
        NSLog(@"num ========= %ld",num);
        
        [UserLocalData setCouponCount:num];

    });
}

- (NSTimeInterval )getRemainingTimeWithEndTime:(NSString *)endTime
{
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


@end
