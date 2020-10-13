//
//  ClosePositionDetaileVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/16.
//  Copyright © 2017年 苏沫离. All rights reserved.
//
#define BUFFER_SIZE 1024 * 100


#import "ClosePositionDetaileVC.h"
#import "AppDelegate.h"
@interface ClosePositionDetaileVC ()

{
    OrderInfoModel *_model;
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

@end

@implementation ClosePositionDetaileVC

- (instancetype)initWithModel:(OrderInfoModel *)model{
    self = [super initWithNibName:@"ClosePositionDetaileVC" bundle:nil];
    if (self){
        _model = model;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = [NSString stringWithFormat:@"%@详情",_model.remark];
    self.navigationItem.leftBarButtonItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];

    [self updatePositionsDetaileWithModel:_model];
}

- (void)updatePositionsDetaileWithModel:(OrderInfoModel *)model{
    
    self.buyUpOrDownLable.text = model.isBuyDrop ? @"买跌" : @"买涨";
    //是否使用优惠券
    self.buyMethodLable.text = model.isUseCoupon ? @"代金券" : @"现金";
    
    if (model.plAmount > 0){//浮动盈亏
        self.plAmountLable.text = [NSString stringWithFormat:@"+%.2f",model.plAmount];
    }else{
        self.plAmountLable.text = [NSString stringWithFormat:@"%.2f",model.plAmount];
    }
    
    //白银种类
    self.buyKindLable.text = [NSString stringWithFormat:@"%@%.1f%@%ld手",model.productInfo.name,model.productInfo.weight,model.productInfo.spec,(long)model.count];
    self.openPositionLable.text = [NSString stringWithFormat:@"%.0f",model.buyPrice];
    self.latestPriceLable.text = [NSString stringWithFormat:@"%.0f",model.sellPrice];
    self.feeLable.text = [NSString stringWithFormat:@"0"];
    
    self.openPositionTimeLable.text = [NSString stringWithFormat:@"%@",model.addTime];
    self.closePositionTimeLable.text = [NSString stringWithFormat:@"%@",model.sellTime];
    self.orderNumLable.text = [NSString stringWithFormat:@"%ld",model.orderId];
    self.feeLable.text = [NSString stringWithFormat:@"%.1f",model.fee];
}

- (void)leftNavBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showShareResult:(NSString *)string Succees:(BOOL)isSucceed{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                             {}];
    [alertView addAction:action];
    
    if (isSucceed){
        UIAlertAction *lookAction = [UIAlertAction actionWithTitle:@"去查看盈利榜" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
             [self leftNavBarButtonClick];
         }];
        [alertView addAction:lookAction];
        
    }else{
        UIAlertAction *againAction = [UIAlertAction actionWithTitle:@"再次晒单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){}];
    
        [alertView addAction:againAction];
    }
    
    [self presentViewController:alertView animated:YES completion:nil];
}

@end
