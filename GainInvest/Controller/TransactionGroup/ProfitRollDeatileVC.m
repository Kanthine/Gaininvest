//
//  ProfitRollDeatileVC.m
//  GainInvest
//
//  Created by 苏沫离 on 2017/4/11.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "ProfitRollDeatileVC.h"

@interface ProfitRollDeatileVC ()

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *gainLable;
@property (weak, nonatomic) IBOutlet UILabel *awardPerLable;
@property (weak, nonatomic) IBOutlet UILabel *awardMoneyLable;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;


@property (weak, nonatomic) IBOutlet UILabel *buyUpOrDownLable;//买涨买跌
@property (weak, nonatomic) IBOutlet UILabel *buyKindLable;//白银种类
@property (weak, nonatomic) IBOutlet UILabel *openPositionLable;//买入价
@property (weak, nonatomic) IBOutlet UILabel *latestPriceLable;//平仓价
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLable;//订单类型

@end

@implementation ProfitRollDeatileVC

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headerImageView.layer.cornerRadius = 20;
    self.headerImageView.clipsToBounds = YES;
    
    [self customNavBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUIInfo];
}


- (void)customNavBar{
    self.navigationItem.title = @"盈利详情";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateUIInfo{
    self.timeLable.text = [NSString stringWithFormat:@"%@排名",[self getCurrentTime]];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_model.headImg] placeholderImage:[UIImage imageNamed:@"placeholderHeader"]];
    self.rankLable.text = [NSString stringWithFormat:@"%ld",self.rankLevel];
    self.phoneLable.text = _model.mobile;
    
    self.gainLable.text = _model.plAmount;
    self.awardMoneyLable.text = [NSString stringWithFormat:@"￥%ld",(long)self.awardMoney];
    self.awardPerLable.text = [NSString stringWithFormat:@"%.1f%%",[_model.plPercent floatValue] * 100];
    
    self.buyUpOrDownLable.text = _model.isBuyDrop ? @"买跌" : @"买涨";
    self.buyKindLable.text = [NSString stringWithFormat:@"白银（%@元/手）%@手",_model.price,_model.count];
    self.openPositionLable.text = [NSString stringWithFormat:@"%@",_model.buyPrice];
    self.latestPriceLable.text = [NSString stringWithFormat:@"%@",_model.sellPrice];
    self.orderTypeLable.text = _model.orderType;
}

- (NSString*)getCurrentTime{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:[NSDate date]];
}
@end
