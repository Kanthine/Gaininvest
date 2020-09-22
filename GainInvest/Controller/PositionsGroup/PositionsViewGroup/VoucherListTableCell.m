//
//  VoucherListTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "VoucherListTableCell.h"

@implementation VoucherListTableCell

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

- (void)updateVoucherListTableCellWithModel:(CouponModel *)model
{
    if (model.flag != 1)
    {
        self.timeLable.hidden = YES;
        self.limitLable.textColor = TextColorGray;
        self.backImageView.image = [UIImage imageNamed:@"positions_VoucherOutTime"];
    }
    else
    {
        
        NSTimeInterval interval = [self getRemainingTimeWithEndTime:model.endTime];
        
        if (interval > 0)
        {
            self.timeLable.hidden = NO;
            
            if (interval > 24 * 60 * 60)
            {
                int hour = ceil(interval / (24 * 60.0 * 60.0) );
                self.timeLable.text = [NSString stringWithFormat:@"剩余%d天",hour];
            }
            else if (interval > 60 * 60)
            {
                int hour = ceil(interval / (60.0 * 60.0) );
                self.timeLable.text = [NSString stringWithFormat:@"剩余%d小时",hour];
            }
            else if (interval > 60)
            {
                int min = ceil(interval / 60.0);
                self.timeLable.text = [NSString stringWithFormat:@"剩余%d分钟",min];
            }
            else if (interval < 60)
            {
                self.timeLable.text = [NSString stringWithFormat:@"剩余%fS",interval];
            }
            
            self.limitLable.textColor = TextColorBlack;
            self.backImageView.image = [UIImage imageNamed:@"positions_VoucherEff"];
        }
        else
        {
            self.timeLable.hidden = YES;
            self.limitLable.textColor = TextColorGray;
            self.backImageView.image = [UIImage imageNamed:@"positions_VoucherOutTime"];
        }
        
        
    }
    
    
    self.priceLable.text = [NSString stringWithFormat:@"￥%.0f",model.rechargeMoney];
    self.limitLable.text = [NSString stringWithFormat:@"限%.0f元/手的产品使用",model.rechargeMoney];
    self.validityLable.text = [NSString stringWithFormat:@"有效期:%@",model.endTime];
}

- (NSTimeInterval )getRemainingTimeWithEndTime:(NSString *)endTime
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *date = [formatter dateFromString:endTime];
    
    NSTimeInterval timeBetween = [date timeIntervalSinceDate:[NSDate date]];
    return timeBetween;
}


@end
