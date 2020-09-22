//
//  TranscationTableSectionHeaderView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/22.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "TranscationTableSectionHeaderView.h"
#import <Masonry.h>

@interface TranscationTableSectionHeaderView()

@property (nonatomic ,strong) UIView *leftContentView;
@property (nonatomic ,strong) UIView *rightContentView;

@end

@implementation TranscationTableSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.contentView.backgroundColor = TableGrayColor;

        [self.contentView addSubview:self.leftContentView];
        [self.contentView addSubview:self.rightContentView];
        
        CGFloat width = ScreenWidth / 2.0 - 0.5;
        
        [self.leftContentView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@-12);
             make.width.mas_equalTo(@(width));
         }];
        
        [self.rightContentView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@-12);
             make.width.mas_equalTo(@(width));
         }];
    }
    
    return self;
}

- (UIView *)leftContentView
{
    if (_leftContentView == nil)
    {
        UIView *leftContentView = [[UIView alloc]init];
        leftContentView.backgroundColor = [UIColor whiteColor];

        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_Teach"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [leftContentView addSubview:imageView];
        
        
        
        
        UILabel *topLable = [[UILabel alloc]init];
        topLable.text = @"投资学院";
        topLable.font = [UIFont systemFontOfSize:15];
        topLable.textColor = [UIColor blackColor];
        [leftContentView addSubview:topLable];
        
        
        
        
        UILabel *bottomLable = [[UILabel alloc]init];
        bottomLable.text = @"什么是盈投资?";
        bottomLable.font = [UIFont systemFontOfSize:13];
        bottomLable.textColor = TextColorGray;
        [leftContentView addSubview:bottomLable];

        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.mas_equalTo(leftContentView);
             make.centerX.mas_equalTo(leftContentView.mas_centerX).with.offset(-45);
             make.width.mas_equalTo(@40);
             make.height.mas_equalTo(@40);
         }];
        
        [topLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.mas_equalTo(leftContentView.mas_centerY).with.offset(-10);
             make.left.equalTo(imageView.mas_right).with.offset(10);
         }];
        
        [bottomLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(topLable.mas_bottom).with.offset(5);
             make.left.equalTo(imageView.mas_right).with.offset(10);
             make.right.mas_equalTo(@0);
         }];

        
        [leftContentView addSubview:self.leftButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];

        
        
        _leftContentView = leftContentView;
    }
    
    return _leftContentView;
}

- (UIView *)rightContentView
{
    if (_rightContentView == nil)
    {
        UIView *rightContentView = [[UIView alloc]init];
        rightContentView.backgroundColor = [UIColor whiteColor];

        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_Gain"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [rightContentView addSubview:imageView];
        
        
        
        
        UILabel *topLable = [[UILabel alloc]init];
        topLable.text = @"盈利榜";
        topLable.font = [UIFont systemFontOfSize:15];
        topLable.textColor = [UIColor blackColor];
        [rightContentView addSubview:topLable];
        
        
        
        
        [rightContentView addSubview:self.gainLable];
        
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.mas_equalTo(rightContentView);
             make.centerX.mas_equalTo(rightContentView.mas_centerX).with.offset(-45);
             make.width.mas_equalTo(@40);
             make.height.mas_equalTo(@40);
         }];
        
        [topLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.mas_equalTo(rightContentView.mas_centerY).with.offset(-10);
             make.left.equalTo(imageView.mas_right).with.offset(10);
         }];
        
        [self.gainLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(topLable.mas_bottom).with.offset(5);
             make.left.equalTo(imageView.mas_right).with.offset(10);
             make.right.mas_equalTo(@0);
         }];
        
        

        
        
        [rightContentView addSubview:self.rightButton];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
        
        _rightContentView = rightContentView;
    }
    
    return _rightContentView;
}


- (UIButton *)leftButton
{
    if (_leftButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        
        _leftButton = button;
    }
    
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (_rightButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        
        _rightButton = button;
    }
    
    return _rightButton;
}

- (UILabel *)gainLable
{
    if (_gainLable == nil)
    {
        UILabel *bottomLable = [[UILabel alloc]init];
        bottomLable.text = @"盈利榜 盈利 66%";
        bottomLable.font = [UIFont systemFontOfSize:13];
        bottomLable.textColor = TextColorGray;
        bottomLable.numberOfLines = 2;
        
        _gainLable = bottomLable;
    }
    
    return _gainLable;
}


@end
