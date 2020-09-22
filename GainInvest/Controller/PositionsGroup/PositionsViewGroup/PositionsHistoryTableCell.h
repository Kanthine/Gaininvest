//
//  PositionsHistoryTableCell.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/16.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionsHistoryTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *buyUpOrDownLable;//买涨买跌
@property (weak, nonatomic) IBOutlet UILabel *buyKindLable;//白银种类
@property (weak, nonatomic) IBOutlet UILabel *plAmountLable;//浮动盈亏
@property (weak, nonatomic) IBOutlet UILabel *openPositionLable;//买入价
@property (weak, nonatomic) IBOutlet UILabel *openPositionTimeLable;//买入时间
@property (weak, nonatomic) IBOutlet UILabel *latestPriceLable;//平仓价
@property (weak, nonatomic) IBOutlet UILabel *closePositionTimeLable;//平仓时间
@property (weak, nonatomic) IBOutlet UILabel *orderNumLable;//订单号
@property (weak, nonatomic) IBOutlet UILabel *feeLable;//手续费

- (void)updatePositionsHistoryTableCellWithModel:(TradeModel *)model;


@end
