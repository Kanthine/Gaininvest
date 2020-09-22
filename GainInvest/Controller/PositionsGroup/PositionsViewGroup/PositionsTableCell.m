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
#import "TransactionHttpManager.h"

@interface PositionsTableCell()


{
    PositionsModel *_model;
}

@end

@implementation PositionsTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)updatePositionsTableCellWithModel:(PositionsModel *)model
{
    _model = model;
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
        self.couponImageView.hidden = NO;
    }
    else
    {
        self.couponImageView.hidden = YES;
    }
    
    
    CGFloat money = ( model.sellPrice - model.buyPrice ) * model.plRatio;
    
    if (model.buyDirection == 1)
    {
        money = - money;
    }
    
    if (money > 0)
    {
        self.plAmountLable.text = [NSString stringWithFormat:@"+%.1f",money];
    }
    else
    {
        self.plAmountLable.text = [NSString stringWithFormat:@"%.1f",money];
    }
    
    self.buyKindLable.text = [NSString stringWithFormat:@"%@%.1f%@%.0f手",model.productName,model.weight,model.spec,model.count];
    self.openPositionLable.text = [NSString stringWithFormat:@"%.0f",model.buyPrice];
    self.latestPriceLable.text = [NSString stringWithFormat:@"%.0f",model.sellPrice];
    self.feeLable.text = [NSString stringWithFormat:@"0"];

    self.lossesLable.text = [NSString stringWithFormat:@"%.0f",model.bottomLimit * 100];
    self.gainTipLable.text = [NSString stringWithFormat:@"%.0f",model.topLimit * 100];
    self.feeLable.text = [NSString stringWithFormat:@"%.1f元",model.fee];
}

/* 更改止盈止损点 */
- (IBAction)updateGainOrLossTipButtonClick:(UIButton *)sender
{
    UpdateGainOrLossTipView *updateView = [[UpdateGainOrLossTipView alloc]initWithTopLimit:_model.topLimit BottomLimit:_model.bottomLimit];
    [updateView show];
    
    updateView.updateGainOrLossTipView = ^(int topLimit,int bottomLimit)
    {
        NSString *top = [NSString stringWithFormat:@"%.2f",topLimit / 100.0];
        NSString *bottom = [NSString stringWithFormat:@"%.2f",bottomLimit / 100.0];
        NSString *orderId = [NSString stringWithFormat:@"%.0f",_model.orderId];
        AccountInfo *account = [AccountInfo standardAccountInfo];
        NSDictionary *dict = @{@"mobile_phone":account.username,
                               @"order_id":orderId,
                               @"contract":_model.contract,
                               @"top_limit":top,
                               @"bottom_limit":bottom};
        
        
        NSLog(@"dict ==== %@",dict);
        
        
        [self.currentViewController.httpManager updatePositionGainOrLossWithParameterDict:dict CompletionBlock:^(NSMutableArray<PositionsModel *> *listArray, NSError *error)
         {
             if (error)
             {
                 [ErrorTipView errorTip:error.domain SuperView:self.currentViewController.view];
             }
             else
             {
                 _model.bottomLimit = bottomLimit / 100.0;
                 _model.topLimit = topLimit / 100.0;
                 self.lossesLable.text = [NSString stringWithFormat:@"%d",bottomLimit];;
                 self.gainTipLable.text = [NSString stringWithFormat:@"%d",topLimit];;
             }
         }];
    };
    
}

/* 平仓 */
- (IBAction)closePositionButtonClick:(UIButton *)sender
{
    ConfirmClosePositionView *closePosition = [[ConfirmClosePositionView alloc]init];
    [closePosition show];
    closePosition.confirmClosePosition = ^()
    {
        NSString *orderId = [NSString stringWithFormat:@"%.0f",_model.orderId];

        AccountInfo *account = [AccountInfo standardAccountInfo];
        NSDictionary *dict = @{@"mobile_phone":account.username,
                               @"order_id":orderId,
                               @"contract":_model.contract};

        
        NSLog(@"dict ==== %@",dict);
        
        [self.currentViewController.httpManager closePositionWithParameterDict:dict CompletionBlock:^(NSMutableArray<PositionsModel *> *listArray, NSError *error)
         {
             if (error)
             {
                 [ErrorTipView errorTip:error.domain SuperView:self.currentViewController.view];
             }
             else
             {
                 [ErrorTipView errorTip:@"平仓成功" SuperView:self.currentViewController.view];
             }
             
         }];
    };
}

@end
