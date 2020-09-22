//
//  PositionsTableCell.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/24.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PositionsContentVC;
@interface PositionsTableCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;

@property (weak, nonatomic) IBOutlet UILabel *plAmountLable;//浮动盈亏

@property (weak, nonatomic) IBOutlet UILabel *buyUpOrDownLable;//买涨买跌
@property (weak, nonatomic) IBOutlet UILabel *buyKindLable;//白银种类
@property (weak, nonatomic) IBOutlet UILabel *openPositionLable;//建仓价
@property (weak, nonatomic) IBOutlet UILabel *latestPriceLable;//最新价
@property (weak, nonatomic) IBOutlet UILabel *feeLable;//手续费
@property (weak, nonatomic) IBOutlet UILabel *lossesLable;//止损点
@property (weak, nonatomic) IBOutlet UILabel *gainTipLable;//止盈点


@property (weak, nonatomic) IBOutlet UIButton *updateGainOrLossTipButton;//更改止盈止损点

@property (weak, nonatomic) IBOutlet UIButton *closePositionButton;//平仓


@property (weak ,nonatomic) PositionsContentVC *currentViewController;

- (void)updatePositionsTableCellWithModel:(PositionsModel *)model;


@end
