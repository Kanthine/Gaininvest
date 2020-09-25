//
//  PositionsIncomeDetaileTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "PositionsIncomeDetaileTableCell.h"


@interface PositionsIncomeDetaileTableCell()


{
    __weak IBOutlet UIImageView *_couponImageView;
}

@end



@implementation PositionsIncomeDetaileTableCell

- (void)updatePositionsHistoryTableCellWithModel:(TradeModel *)model{
    self.nameLable.text = model.remark;
    self.priceLable.text = [NSString stringWithFormat:@"%.2f元",model.money];
    self.resultLable.text = [model.remark stringByAppendingString:@"成功"];
    self.resultLable.text = @"";
    
    if ([self.nameLable.text containsString:@"平仓"]){
        self.timeLable.text = model.sellTime;
    }else{
        //建仓
        self.timeLable.text = model.addTime;
    }
    
    //是否使用优惠券
    _couponImageView.hidden = !model.isUseCoupon;
}


@end
