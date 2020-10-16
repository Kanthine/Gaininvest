//
//  PositionsTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/24.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "PositionsTableCell.h"

#import "UpdateGainOrLossTipView.h"
#import "ConfirmClosePositionView.h"

#import "PositionsContentVC.h"

@interface PositionsTableCell()

{
    OrderInfoModel *_model;
}

@end

@implementation PositionsTableCell

- (void)updatePositionsTableCellWithModel:(OrderInfoModel *)model{
    _model = model;

    if (model.isUseCoupon){//是否使用优惠券
        self.couponImageView.hidden = NO;
    }else{
        self.couponImageView.hidden = YES;
    }
    
    self.buyUpOrDownLable.text = model.isBuyDrop ? @"买跌" : @"买涨";
    
    if (model.plAmount > 0){
        self.plAmountLable.text = [NSString stringWithFormat:@"+%.1f",model.plAmount];
    }else{
        self.plAmountLable.text = [NSString stringWithFormat:@"%.1f",model.plAmount];
    }
    
    self.buyKindLable.text = [NSString stringWithFormat:@"%@%@%@%ld手",model.productInfo.name,model.productInfo.weight,model.productInfo.spec,(long)model.count];
    self.openPositionLable.text = [NSString stringWithFormat:@"%.0f 元",model.buyPrice];
    
    self.latestPriceLable.text = [NSString stringWithFormat:@"%.1f 元",StockCurrentData.currentStock.quote.floatValue * model.count];
    
    self.lossesLable.text = [NSString stringWithFormat:@"%.0f",model.bottomLimit * 100];
    self.gainTipLable.text = [NSString stringWithFormat:@"%.0f",model.topLimit * 100];
    self.feeLable.text = [NSString stringWithFormat:@"%.1f元",model.fee];
}

/** 修改持仓的止盈止损点
 *
 * mobile_phone：手机号
 * order_id ：订单号
 * contract ：商品符号
 * top_limit ：止盈比例
 * bottom_limit ：止损比例
 */
- (IBAction)updateGainOrLossTipButtonClick:(UIButton *)sender{
    UpdateGainOrLossTipView *updateView = [[UpdateGainOrLossTipView alloc]initWithTopLimit:_model.topLimit BottomLimit:_model.bottomLimit];
    [updateView show];
    
    updateView.updateGainOrLossTipView = ^(int topLimit,int bottomLimit){
        _model.bottomLimit = bottomLimit / 100.0;
        _model.topLimit = topLimit / 100.0;
        [OrderInfoModel updateModel:_model];
        self.lossesLable.text = [NSString stringWithFormat:@"%d",bottomLimit];;
        self.gainTipLable.text = [NSString stringWithFormat:@"%d",topLimit];;
    };
}

/** 平仓
 * mobile_phone：手机号
 * order_id ：订单号
 * contract ：商品符号
 */
- (IBAction)closePositionButtonClick:(UIButton *)sender{
    ConfirmClosePositionView *closePosition = [[ConfirmClosePositionView alloc]init];
    [closePosition show];
    closePosition.confirmClosePosition = ^(){
        [_model closePosition];
        [ErrorTipView errorTip:@"平仓成功" SuperView:self.currentViewController.view];
    };
}

@end
