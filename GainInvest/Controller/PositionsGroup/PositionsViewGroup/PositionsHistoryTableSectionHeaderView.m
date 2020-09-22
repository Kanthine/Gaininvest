//
//  PositionsHistoryTableSectionHeaderView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "PositionsHistoryTableSectionHeaderView.h"
#import <Masonry.h>
@implementation PositionsHistoryTableSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];

        
        [self.contentView addSubview:self.leftButton];
        [self.contentView addSubview:self.rightButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
        }];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.left.equalTo(_leftButton.mas_right);
             make.width.equalTo(_leftButton.mas_width);
         }];

        
        UIView *lineView = UIView.new;
        lineView.backgroundColor = LineGrayColor;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.height.mas_equalTo(@1);
             make.right.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
         }];
    }
    
    return self;
}


- (UIButton *)leftButton
{
    if (_leftButton == nil)
    {
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.tag = 2;
        [leftButton setTitle:@"交易记录" forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [leftButton setTitleColor:TextColorGray forState:UIControlStateNormal];
        [leftButton setTitleColor:TextColorBlack forState:UIControlStateSelected];
        leftButton.selected = YES;
        
        
        _leftButton = leftButton;
    }
    
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (_rightButton == nil)
    {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.tag = 3;
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightButton setTitleColor:TextColorGray forState:UIControlStateNormal];
        [rightButton setTitleColor:TextColorBlack forState:UIControlStateSelected];
        [rightButton setTitle:@"收支明细" forState:UIControlStateNormal];
        
        _rightButton = rightButton;
    }
    
    return _rightButton;
}




@end
