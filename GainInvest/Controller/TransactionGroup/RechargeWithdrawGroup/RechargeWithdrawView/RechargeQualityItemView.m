//
//  RechargeQualityItemView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/21.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "RechargeQualityItemView.h"
#import "QualityCertificationView.h"

#import <Masonry.h>

@interface RechargeQualityItemView()

{
    NSString *_titieString;
}

@end

@implementation RechargeQualityItemView

- (instancetype)initWithFrame:(CGRect)frame Image:(NSString *)imageName Title:(NSString *)titieString
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _titieString = titieString;
        CGFloat itemSpace = 30;
        if (ScreenWidth > 330 && ScreenWidth < 400)
        {
            itemSpace = 40;
        }
        else if (ScreenWidth > 400)
        {
            itemSpace = 45;
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        imageView.tag = 100;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.mas_equalTo(@(itemSpace));
             make.right.mas_equalTo(@(-itemSpace));
             make.height.mas_equalTo(imageView.mas_width).multipliedBy(1.0);
        }];
        
        
        UILabel *lable = [[UILabel alloc]init];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = titieString;
        lable.textColor = TextColorGray;
        lable.font = [UIFont systemFontOfSize:14];
        [self addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(imageView.mas_bottom).with.offset(6);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
        
        
        [self addSubview:self.itemButton];
        [_itemButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.edges.equalTo(self);
         }];
        
        
        CGRect rect = self.frame;
        rect.size.height = CGRectGetWidth(rect) - itemSpace * 2 + 10 + 6 + 18 + 10;
        self.frame = rect;
    }
    
    return self;
}

- (UIButton *)itemButton
{
    if (_itemButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(qualityViewButtonClick) forControlEvents:UIControlEventTouchUpInside];

        _itemButton = button;
    }
    
    return _itemButton;
}

- (void)qualityViewButtonClick
{
    NSInteger index = self.tag - 10;
    NSArray *imageArray = @[@"Recharge_leaglePlatAlert",@"Recharge_leagleMemberAlert",@"Recharge_leagleQualityAlert"];
    
    [MobClick event:@"PositionsClick" label:_titieString];
    
    [[[QualityCertificationView alloc]initWithImageName:imageArray[index]] show];
    
    
    if (index == 0)
    {
        [FirstLaunchPage setLookRechargePlatform];
        UIImageView *imageView = [self viewWithTag:100];
        imageView.image = [UIImage imageNamed:@"Recharge_leaglePlat"];
    }
}

@end
