//
//  PositionsHistoryTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/16.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "PositionsHistoryTableCell.h"


@interface PositionsHistoryTableCell()

{
    __weak IBOutlet UIImageView *_couponImageView;
}


@end

@implementation PositionsHistoryTableCell

- (void)updatePositionsHistoryTableCellWithModel:(OrderInfoModel *)model{
    self.buyUpOrDownLable.text = model.isBuyDrop ? @"买跌" : @"买涨";

    //是否使用优惠券
    _couponImageView.hidden = !model.isUseCoupon;
    
    
    if (model.plAmount > 0){//浮动盈亏
        self.plAmountLable.text = [NSString stringWithFormat:@"+%.2f",model.plAmount];
    }else{
        self.plAmountLable.text = [NSString stringWithFormat:@"%.2f",model.plAmount];
    }
    
    
    self.buyKindLable.text = [NSString stringWithFormat:@"%@%.1f%@%.0f手",model.productInfo.name,model.productInfo.weight,model.productInfo.spec,model.count];
    self.openPositionLable.text = [NSString stringWithFormat:@"%.0f",model.buyPrice];
    
    
    
    NSString *sellPrice = @"";
    if (model.sellPrice > 0){
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
    self.orderNumLable.text = [NSString stringWithFormat:@"%ld",model.orderId];
    
    self.feeLable.text = [NSString stringWithFormat:@"%.1f",model.fee];
}
@end
