//
//  TranscationTableSectionFooterView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/22.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "TranscationTableSectionFooterView.h"
#import <Masonry.h>
#import "UIColor+Y_StockChart.h"


@implementation TranscationTableSectionFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.contentView.backgroundColor = NavBarBackColor;
        
        [self.contentView addSubview:self.leftButton];
        [self.contentView addSubview:self.rightButton];

        [self.contentView addSubview:self.leftLable];
        [self.contentView addSubview:self.rightLable];

        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.mas_equalTo(@30);
             make.height.mas_equalTo(@40);
         }];

        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.equalTo(_leftButton.mas_right).with.offset(20);
             make.height.mas_equalTo(@40);
             make.right.mas_equalTo(@-30);
             make.width.equalTo(_leftButton);
         }];

        
        
        [self.leftLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_leftButton.mas_bottom).with.offset(10);
             make.centerX.equalTo(_leftButton);
             make.width.equalTo(_leftButton);
         }];
        
        [self.rightLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_rightButton.mas_bottom).with.offset(10);
             make.centerX.equalTo(_rightButton);
             make.width.equalTo(_rightButton);
         }];

    }
    
    return self;
}

- (UIButton *)leftButton
{
    if (_leftButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor decreaseColor];
        [button setTitle:@"买涨" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        
        _leftButton = button;
    }
    
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (_rightButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor increaseColor];
        [button setTitle:@"买跌" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        _rightButton = button;
    }
    
    return _rightButton;
}

- (UILabel *)leftLable
{
    if (_leftLable == nil)
    {
        UILabel *bottomLable = [[UILabel alloc]init];
        bottomLable.text = @"66% 用户买涨";
        bottomLable.font = [UIFont systemFontOfSize:13];
        bottomLable.textColor = TextColorGray;
        bottomLable.textAlignment = NSTextAlignmentCenter;
        
        _leftLable = bottomLable;
    }
    
    return _leftLable;
}

- (UILabel *)rightLable
{
    if (_rightLable == nil)
    {
        UILabel *bottomLable = [[UILabel alloc]init];
        bottomLable.text = @"34% 用户买跌";
        bottomLable.font = [UIFont systemFontOfSize:13];
        bottomLable.textColor = TextColorGray;
        bottomLable.textAlignment = NSTextAlignmentCenter;
        _rightLable = bottomLable;
    }
    
    return _rightLable;
}

@end
