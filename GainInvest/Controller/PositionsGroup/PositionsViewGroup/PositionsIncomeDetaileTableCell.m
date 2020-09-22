//
//  PositionsIncomeDetaileTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/13.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "PositionsIncomeDetaileTableCell.h"


@interface PositionsIncomeDetaileTableCell()


{
    __weak IBOutlet UIImageView *_couponImageView;
}

@end



@implementation PositionsIncomeDetaileTableCell

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

- (void)updatePositionsHistoryTableCellWithModel:(TradeModel *)model
{
    self.nameLable.text = model.remark;
    self.priceLable.text = [NSString stringWithFormat:@"%.2f元",model.money];
    self.resultLable.text = [model.remark stringByAppendingString:@"成功"];
    self.resultLable.text = @"";
    
    
    if ([self.nameLable.text containsString:@"建仓"])
    {
        self.timeLable.text = model.addTime;
    }
    else if ([self.nameLable.text containsString:@"平仓"])
    {
        self.timeLable.text = model.sellTime;
    }
    else
    {
        self.timeLable.text = model.addTime;
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
}


@end
