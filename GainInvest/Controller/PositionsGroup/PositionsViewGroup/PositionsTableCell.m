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
    PositionsModel *_model;
}

@end

@implementation PositionsTableCell

- (void)updatePositionsTableCellWithModel:(PositionsModel *)model{
    _model = model;
    if (model.isBuyDrop){
        self.buyUpOrDownLable.text = @"买跌";
    }else{
        self.buyUpOrDownLable.text = @"买涨";
    }
    
    if (model.isUseCoupon){//是否使用优惠券
        self.couponImageView.hidden = NO;
    }else{
        self.couponImageView.hidden = YES;
    }
    
    CGFloat money = ( model.sellPrice - model.buyPrice ) * model.plRatio;
    if (model.isBuyDrop){
        money = - money;
    }
    
    if (money > 0){
        self.plAmountLable.text = [NSString stringWithFormat:@"+%.1f",money];
    }else{
        self.plAmountLable.text = [NSString stringWithFormat:@"%.1f",money];
    }
    
    self.buyKindLable.text = [NSString stringWithFormat:@"%@%.1f%@%.0f手",model.productInfo.name,model.productInfo.weight,model.productInfo.spec,model.count];
    self.openPositionLable.text = [NSString stringWithFormat:@"%.0f",model.buyPrice];
    self.latestPriceLable.text = [NSString stringWithFormat:@"%.0f",model.sellPrice];
    self.feeLable.text = [NSString stringWithFormat:@"0"];
    
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
        self.lossesLable.text = [NSString stringWithFormat:@"%d",bottomLimit];;
        self.gainTipLable.text = [NSString stringWithFormat:@"%d",topLimit];;
    };
    
}

/** 平仓
 * mobile_phone：手机号
 * order_id ：订单号
 * contract ：商品符号
 */
- (IBAction)closePositionButtonClick:(UIButton *)sender
{
    ConfirmClosePositionView *closePosition = [[ConfirmClosePositionView alloc]init];
    [closePosition show];
    closePosition.confirmClosePosition = ^(){
        NSString *orderId = [NSString stringWithFormat:@"%ld",_model.orderId];

        AccountInfo *account = [AccountInfo standardAccountInfo];
        NSDictionary *dict = @{@"mobile_phone":account.username,
                               @"order_id":orderId,
                               @"contract":_model.productInfo.contract};

        
        NSLog(@"dict ==== %@",dict);
        [ErrorTipView errorTip:@"平仓成功" SuperView:self.currentViewController.view];
    };
}

@end
