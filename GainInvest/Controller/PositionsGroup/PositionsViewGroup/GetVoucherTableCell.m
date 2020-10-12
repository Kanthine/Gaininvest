//
//  GetVoucherTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "GetVoucherTableCell.h"

@implementation GetVoucherTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    //660 ： 280
    self.imageView.frame =CGRectMake(10,10,CGRectGetWidth(UIScreen.mainScreen.bounds) - 20, GetVoucherTableCellHeight - 10);
    self.imageView.contentMode =UIViewContentModeScaleAspectFit;
}

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

@end
