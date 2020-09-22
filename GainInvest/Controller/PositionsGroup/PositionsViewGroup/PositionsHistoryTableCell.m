//
//  PositionsHistoryTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/16.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "PositionsHistoryTableCell.h"


@interface PositionsHistoryTableCell()

{
    __weak IBOutlet UIImageView *_couponImageView;
}


@end

@implementation PositionsHistoryTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updatePositionsHistoryTableCellWithModel:(TradeModel *)model
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
        _couponImageView.hidden = NO;

    }
    else
    {
        //没使用
        _couponImageView.hidden = YES;
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
    
    
    
    NSString *sellPrice = @"";
    if (model.sellPrice > 0)
    {
       sellPrice = [NSString stringWithFormat:@"%.0f",model.sellPrice];
    }
    self.latestPriceLable.text = sellPrice;

    
    NSString *sellTime;
    if (model.sellTime && model.sellTime.length > 0)
    {
        sellTime = model.sellTime;
    }
    else
    {
        sellTime = @"";
    }

    
    
    self.openPositionTimeLable.text = [NSString stringWithFormat:@"%@",model.addTime];
    self.closePositionTimeLable.text = [NSString stringWithFormat:@"%@",sellTime];
    self.orderNumLable.text = [NSString stringWithFormat:@"%.0f",model.orderId];
    
    self.feeLable.text = [NSString stringWithFormat:@"%.1f",model.fee];
    
}


@end
