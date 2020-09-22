//
//  NewHandTeachTableCell.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/8.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "NewHandTeachTableCell.h"
#import <Masonry.h>

@implementation NewHandTeachTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self.contentView addSubview:self.teachImageView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.teachImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
        }];
        
    }
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (UIImageView *)teachImageView
{
    if (_teachImageView == nil)
    {
        _teachImageView = [[UIImageView alloc]init];
    }
    
    return _teachImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
