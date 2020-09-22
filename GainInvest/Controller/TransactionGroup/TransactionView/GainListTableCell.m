//
//  GainListTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/16.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "GainListTableCell.h"

@implementation GainListTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateGainListTableCellWithModel:(TradeModel *)model
{
    NSString *nameStr = [NSString stringWithFormat:@"%@(%.1f元)",model.proDesc,model.buyMoney];
    NSString *priceStr = @"";
    if (model.plAmount > 0)
    {
        priceStr = [NSString stringWithFormat:@"+%.1f元(%.1f%%)",model.plAmount,model.plAmount / model.buyMoney * 100.0];
    }
    else
    {
        priceStr = [NSString stringWithFormat:@"%.1f元(%.1f%%)",model.plAmount,model.plAmount / model.buyMoney * 100.0];
    }
    
    
    self.nameLable.text = nameStr;
    self.timeLable.text = model.sellTime;
    self.priceLable.text = priceStr;

}

@end
