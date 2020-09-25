//
//  GetVoucherViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define CellIdentifer @"GetVoucherTableCell"
#define BUFFER_SIZE 1024 * 100



#import "GetVoucherViewController.h"


#import "TransactionHttpManager.h"
#import "GetVoucherTableCell.h"
#import "RechargeViewController.h"
#import "MyVoucherViewController.h"
#import "ProfitRollViewController.h"
#import "AppDelegate.h"

@interface GetVoucherViewController ()
<UITableViewDelegate,UITableViewDataSource>


{
    UIButton *_rightItem;
}

@property (nonatomic ,strong) TransactionHttpManager *httpManager;

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<NSString *> *imagePathArray;

@end

@implementation GetVoucherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    
    __weak __typeof__(self) weakSelf = self;
    APPDELEGETE.libWeChatShareResult = ^(NSError *error)
    {
        [weakSelf handleWeChatShareResult:error];
    };;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestGetCouponCount];
    
    [self updateTableList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"获取代金券";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    _rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightItem.adjustsImageWhenHighlighted = NO;
    _rightItem.imageEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 0);
    _rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightItem setImage:[UIImage imageNamed:@"navBar_Coupon"] forState:UIControlStateNormal];
    [_rightItem addTarget:self action:@selector(lookMyCouponClick) forControlEvents:UIControlEventTouchUpInside];
    _rightItem.frame = CGRectMake(0, 0, 44, 44);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightItem];
    self.navigationItem.rightBarButtonItem = rightItem;
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
        _tableView.backgroundColor = NavBarBackColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = GetVoucherTableCellHeight;
        [_tableView registerClass:[GetVoucherTableCell class] forCellReuseIdentifier:CellIdentifer];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetVoucherTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:self.imagePathArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        [self tableViewDidSelectRegisterClick];
    }
    else if (indexPath.row == 1)
    {
        [self tableViewDidSelectFirstrecharge];
    }
    else if (indexPath.row == 2)
    {
        [self tableViewDidSelectShareClick];
    }
    else if (indexPath.row == 3)
    {
        [self tableViewDidSelectProfitRollClick];
    }
}

- (void)tableViewDidSelectRegisterClick
{
    if ([AuthorizationManager isLoginState] == NO)
    {
        //未注册时，注册领取代金券
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    if ([AuthorizationManager isBindingMobile] == NO)
    {
        [AuthorizationManager getBindingMobileWithViewController:self IsNeedCancelClick:NO];
        return;
    }
    
    if ([AuthorizationManager isRemoteLoginWithViewController:self])
    {
        return;
    }
    
    if ([AuthorizationManager isOpenAccountInStockExchange] == NO)
    {
        [AuthorizationManager openAccountInStockExchangeWithViewController:self IsNeedCancelClick:NO];
        return;
    }    
}

- (void)tableViewDidSelectFirstrecharge
{
    //第一次充值
    if ([AuthorizationManager isLoginState] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    if ([AuthorizationManager isBindingMobile] == NO)
    {
        [AuthorizationManager getBindingMobileWithViewController:self IsNeedCancelClick:NO];
        
        return;
    }
    
    if ([AuthorizationManager isRemoteLoginWithViewController:self])
    {
        return;
    }

    
    if ([AuthorizationManager isOpenAccountInStockExchange] == NO)
    {
        [AuthorizationManager openAccountInStockExchangeWithViewController:self IsNeedCancelClick:NO];
        
        return;
    }
    
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    if ([account.isRecharge isEqualToString:@"1"]){
        //充值过
    }else{
        if ([AuthorizationManager isEffectiveToken]){
            //未充值 -- > 充值
            RechargeViewController *rechargeVC = [[RechargeViewController alloc]init];
            rechargeVC.hidesBottomBarWhenPushed = YES;
            rechargeVC.isBuyUp = -1;
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }else{
            [AuthorizationManager getEffectiveTokenWithViewController:self IsNeedCancelClick:NO];
        }        
    }
}

- (void)tableViewDidSelectShareClick
{
    if ([AuthorizationManager isLoginState] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
    else
    {
        [self shareButtonClick];
    }
}

- (void)tableViewDidSelectProfitRollClick
{
    if ([AuthorizationManager isLoginState] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
    else
    {
        ProfitRollViewController *profitRoll = [[ProfitRollViewController alloc]init];
        profitRoll.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:profitRoll animated:YES];
    }
}

- (void)shareButtonClick{    

}

- (void)handleWeChatShareResult:(NSError *)err{
    [_rightItem setImage:[UIImage imageNamed:@"navBar_CouponNews"] forState:UIControlStateSelected];
    [self showShareResult:@"您已成功分享，我们将发送代金券到您个人账户，请注意查收" Succees:YES];
}

- (void)showShareResult:(NSString *)string Succees:(BOOL)isSucceed
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                             {}];
    [alertView addAction:action];

    
    if (isSucceed)
    {
        UIAlertAction *lookAction = [UIAlertAction actionWithTitle:@"去查看代金券" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
         {
             [self lookMyCouponClick];
         }];
        [alertView addAction:lookAction];

    }
    else
    {
        UIAlertAction *againAction = [UIAlertAction actionWithTitle:@"再次分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                      {
                                          [self shareButtonClick];
                                      }];
        [alertView addAction:againAction];
    }
    
    [self presentViewController:alertView animated:YES completion:nil];
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

- (void)updateTableList{
    [self.imagePathArray removeAllObjects];
    
    NSString *image1Str = nil;
    if ([AuthorizationManager isOpenAccountInStockExchange]){
        image1Str = [NewTeachBundle pathForResource:@"getcoupon_regist" ofType:@"png"];//已注册
    }else{
        image1Str = [NewTeachBundle pathForResource:@"getcoupon_registNo" ofType:@"png"];//未注册
    }

    NSString *image2Str = nil;
    if ([AuthorizationManager isLoginState]){
        AccountInfo *account = [AccountInfo standardAccountInfo];
        if ([account.isRecharge isEqualToString:@"1"]){
            image2Str = [NewTeachBundle pathForResource:@"getcoupon_firstrecharge_gray" ofType:@"png"];//已充值
        }else{
            image2Str = [NewTeachBundle pathForResource:@"getcoupon_firstrecharge" ofType:@"png"];//未充值
        }
    }else{
        image2Str = [NewTeachBundle pathForResource:@"getcoupon_firstrecharge" ofType:@"png"];//未充值
    }
    
    NSString *image3Str = [NewTeachBundle pathForResource:@"getcoupon_share" ofType:@"png"];//去分享
    NSString *image4Str = [NewTeachBundle pathForResource:@"getcoupon_rank" ofType:@"png"];//去晒单
    NSString *image5Str = [NewTeachBundle pathForResource:@"getcoupon_firstrecharge_gray" ofType:@"png"];//已充值
    
    [_imagePathArray addObject:image1Str];
    [_imagePathArray addObject:image2Str];
    [_imagePathArray addObject:image3Str];
    [_imagePathArray addObject:image4Str];
    [_imagePathArray addObject:image5Str];

    [self.tableView reloadData];
}

- (void)lookMyCouponClick{
    if ([AuthorizationManager isLoginState] == NO){
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    if ([AuthorizationManager isHaveFourLevelWithViewController:self IsNeedCancelClick:NO]){
        MyVoucherViewController *voucherVC = [[MyVoucherViewController alloc]init];
        voucherVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:voucherVC animated:YES];
    }
}

- (void)requestGetCouponCount{
    if ([AuthorizationManager isLoginState] == NO)
    {
        [_rightItem setImage:[UIImage imageNamed:@"navBar_Coupon"] forState:UIControlStateNormal];
        
        return;
    }
    
    if ([AuthorizationManager isOpenAccountInStockExchange] == NO)
    {
        [_rightItem setImage:[UIImage imageNamed:@"navBar_CouponNews"] forState:UIControlStateNormal];
        return;
    }
    
    NSUInteger count = DemoData.queryCouponCount;
    NSUInteger oldCount = [UserLocalData getCouponCount];
    if (count == oldCount){
        [_rightItem setImage:[UIImage imageNamed:@"navBar_Coupon"] forState:UIControlStateNormal];
    }else{
        [UserLocalData setCouponCount:count];
        [_rightItem setImage:[UIImage imageNamed:@"navBar_CouponNews"] forState:UIControlStateNormal];
    }
}

@end
