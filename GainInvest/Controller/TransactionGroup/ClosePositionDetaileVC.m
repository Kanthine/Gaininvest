//
//  ClosePositionDetaileVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/16.
//  Copyright © 2017年 苏沫离. All rights reserved.
//
#define BUFFER_SIZE 1024 * 100


#import "ClosePositionDetaileVC.h"

#import "TransactionHttpManager.h"
#import "AppDelegate.h"
@interface ClosePositionDetaileVC ()

{
    TradeModel *_model;
}

@property (weak, nonatomic) IBOutlet UILabel *buyUpOrDownLable;//买涨买跌
@property (weak, nonatomic) IBOutlet UILabel *buyKindLable;//白银种类
@property (weak, nonatomic) IBOutlet UILabel *plAmountLable;//浮动盈亏
@property (weak, nonatomic) IBOutlet UILabel *openPositionLable;//买入价
@property (weak, nonatomic) IBOutlet UILabel *openPositionTimeLable;//买入时间
@property (weak, nonatomic) IBOutlet UILabel *latestPriceLable;//平仓价
@property (weak, nonatomic) IBOutlet UILabel *closePositionTimeLable;//平仓时间
@property (weak, nonatomic) IBOutlet UILabel *orderNumLable;//订单号
@property (weak, nonatomic) IBOutlet UILabel *feeLable;//手续费
@property (weak, nonatomic) IBOutlet UILabel *buyMethodLable;//购买方式

@property (nonatomic ,strong) TransactionHttpManager *httpManager;


@end

@implementation ClosePositionDetaileVC

- (instancetype)initWithModel:(TradeModel *)model
{
    self = [super initWithNibName:@"ClosePositionDetaileVC" bundle:nil];
    
    if (self)
    {
        _model = model;
    }
    
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavBar];

    [self updatePositionsDetaileWithModel:_model];
    
    __weak __typeof__(self) weakSelf = self;
    APPDELEGETE.libWeChatShareResult = ^(NSError *error)
    {
        [weakSelf handleWeChatShareResult:error];
    };;

}

- (void)updatePositionsDetaileWithModel:(TradeModel *)model
{
    
    
    
    if (model.buyDirection == 1)
    {
        self.buyUpOrDownLable.text = @"买跌";
    }
    else
    {
        self.buyUpOrDownLable.text = @"买涨";
    }
    
    if (model.couponFlag == 1)//是否使用优惠券
    {
        //使用
        self.buyMethodLable.text = @"代金券";
    }
    else
    {
        //没使用
        self.buyMethodLable.text = @"现金";
    }
    
    
    if (model.plAmount > 0)//浮动盈亏
    {
        self.plAmountLable.text = [NSString stringWithFormat:@"+%.2f",model.plAmount];
    }
    else
    {
        self.plAmountLable.text = [NSString stringWithFormat:@"%.2f",model.plAmount];
    }
    
    self.buyKindLable.text = [NSString stringWithFormat:@"%@%.1f%@%.0f手",model.proDesc,model.weight,model.spec,model.count];
    self.openPositionLable.text = [NSString stringWithFormat:@"%.0f",model.buyPrice];
    self.latestPriceLable.text = [NSString stringWithFormat:@"%.0f",model.sellPrice];
    self.feeLable.text = [NSString stringWithFormat:@"0"];
    
    self.openPositionTimeLable.text = [NSString stringWithFormat:@"%@",model.addTime];
    self.closePositionTimeLable.text = [NSString stringWithFormat:@"%@",model.sellTime];
    self.orderNumLable.text = [NSString stringWithFormat:@"%.0f",model.orderId];
    
    
    self.feeLable.text = [NSString stringWithFormat:@"%.1f",model.fee];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)customNavBar
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@详情",_model.remark];
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}


- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)shareToWeChat:(UIButton *)sender
{


}

- (TransactionHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[TransactionHttpManager alloc]init];
    }
    
    return _httpManager;
}

- (void)handleWeChatShareResult:(NSError *)err
{
    //微信分享失败
    if (err.code != 0)
    {
        [self showShareResult:@"您分享失败了" Succees:NO];
        return;
    }
    
    NSString *orderId = [NSString stringWithFormat:@"%.0f",_model.orderId];

    NSDictionary *dict = @{@"orderId":orderId};
    [self.httpManager inorderToShareWeChat:dict CompletionBlock:^(NSError *error)
    {
        if (error)
        {
            [self showShareResult:error.domain Succees:NO];
        }
        else
        {
            [self showShareResult:@"您已成功晒单" Succees:YES];
        }
    }];
}

- (void)showShareResult:(NSString *)string Succees:(BOOL)isSucceed
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                             {}];
    [alertView addAction:action];
    
    
    if (isSucceed)
    {
        UIAlertAction *lookAction = [UIAlertAction actionWithTitle:@"去查看盈利榜" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
         {
             [self leftNavBarButtonClick];
         }];
        [alertView addAction:lookAction];
        
    }
    else
    {
        UIAlertAction *againAction = [UIAlertAction actionWithTitle:@"再次晒单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
      {
          [self shareToWeChat:nil];
      }];
    [alertView addAction:againAction];
    }
    
    [self presentViewController:alertView animated:YES completion:nil];
}

@end
