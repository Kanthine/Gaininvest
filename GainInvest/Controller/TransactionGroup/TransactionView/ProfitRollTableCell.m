//
//  ProfitRollTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/23.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "ProfitRollTableCell.h"


@implementation ProfitRollTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code

    if (ScreenWidth < 330)
    {
        [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if ([obj isKindOfClass:[UILabel class]])
            {
                UILabel *lable = (UILabel *)obj;
                lable.font = [UIFont systemFontOfSize:12];
            }
        }];

        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)updateProfitRollTableCell:(InorderModel *)model
{
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"placeholderHeader"]];
    self.nameLable.text = model.mobile;
    self.gainLable.text = [NSString stringWithFormat:@"%.1f%%",[model.plPercent floatValue] * 100];

}

@end
