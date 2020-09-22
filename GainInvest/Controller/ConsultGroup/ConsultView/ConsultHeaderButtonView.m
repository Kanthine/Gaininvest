//
//  ConsultHeaderButtonView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/9.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "ConsultHeaderButtonView.h"
#import <Masonry.h>
@interface ConsultHeaderButtonView ()

@property (nonatomic ,strong) UILabel *lable;
@end

@implementation ConsultHeaderButtonView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Image:(NSString *)image
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        [self addSubview:self.imageView];
        self.imageView.image = [UIImage imageNamed:image];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.centerX.equalTo(self.mas_centerX);
             make.width.mas_equalTo(_imageView.mas_height).multipliedBy(1);
//             make.left.mas_equalTo(@20);
//             make.right.mas_equalTo(@-20);
         }];
        
        [self addSubview:self.lable];
        self.lable.text = title;
        [self.lable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_imageView.mas_bottom).with.offset(5);
             make.left.mas_equalTo(@0);
             make.bottom.equalTo(self).with.offset(-10);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@20);
         }];
        
        
        
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.mas_equalTo(@0);
            make.left.mas_equalTo(@0);
            make.bottom.mas_equalTo(@0);
            make.right.mas_equalTo(@0);
        }];
    }
    
    return self;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView = imageView;
    }
    
    return _imageView;
}

- (UILabel *)lable
{
    if (_lable == nil)
    {
        UILabel *lable = [[UILabel alloc]init];
        lable.textColor = TextColorBlack;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:14];
        _lable = lable;
    }
    
    return _lable;
}

- (UIButton *)button
{
    if (_button == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.adjustsImageWhenDisabled = NO;
        button.adjustsImageWhenHighlighted = NO;
        _button = button;
    }
    
    return _button;
}


@end
