//
//  ProfitRollTableHeaderView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/23.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "ProfitRollTableHeaderView.h"

#import <Masonry.h>

#import "ProfitRollDeatileVC.h"


@interface ProfitRollTableHeaderView()

{
    NSMutableArray *_listArray;
}

@property (nonatomic ,strong) UIImage *textBackImage;

@end

@implementation ProfitRollTableHeaderView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
        self.backgroundColor = NavBarBackColor;
        
        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 20)];
        topLable.tag = 66;
        topLable.textColor = RGBA(123, 128, 144, 1);
        topLable.textAlignment = NSTextAlignmentCenter;
        topLable.font = [UIFont systemFontOfSize:15];
        [self addSubview:topLable];
        

        CGFloat x_backImageView = 20.0;
        UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ProfitRoll_Back"]];
        backImageView.frame = CGRectMake(x_backImageView, CGRectGetMaxY(topLable.frame) + 15, ScreenWidth - x_backImageView * 2, (ScreenWidth - x_backImageView * 2) / 50.0 * 19.0);
        backImageView.backgroundColor = [UIColor clearColor];
        backImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:backImageView];
        
        
        CGFloat firstWidth = CGRectGetHeight(backImageView.frame) * 65 / 190.0;
        CGFloat yPoint_FirstImageView = CGRectGetHeight(backImageView.frame) * 54 / 190.0;
        UIImageView *firstImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, firstWidth, firstWidth)];
        firstImageView.clipsToBounds = YES;
        firstImageView.layer.cornerRadius = firstWidth / 2.0;
        firstImageView.center = CGPointMake(backImageView.center.x, backImageView.center.y - yPoint_FirstImageView);
        backImageView.contentMode = UIViewContentModeScaleAspectFit;
        firstImageView.tag = 1;
        [self addSubview:firstImageView];
        
        
        
        UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.tag = 31;
        [firstButton addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        firstButton.frame = CGRectMake(CGRectGetMinX(firstImageView.frame) - 20, CGRectGetMinY(firstImageView.frame) - 20, CGRectGetWidth(firstImageView.frame) + 40, CGRectGetHeight(firstImageView.frame) + 40);
        [self addSubview:firstButton];
        
        
        
        CGFloat secondWidth = CGRectGetHeight(backImageView.frame) * 48 / 190.0;
        CGFloat xPoint_SecondImageView = CGRectGetWidth(backImageView.frame) * 201 / 500.0;
        UIImageView *secondImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, secondWidth, secondWidth)];
        secondImageView.center = CGPointMake(backImageView.center.x - xPoint_SecondImageView, backImageView.center.y - 5 / 190.0 * CGRectGetHeight(backImageView.frame) );
        secondImageView.contentMode = UIViewContentModeScaleAspectFit;
        secondImageView.clipsToBounds = YES;
        secondImageView.layer.cornerRadius = secondWidth / 2.0;
        secondImageView.tag = 2;
        [self addSubview:secondImageView];

        
        UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        secondButton.tag = 32;
        [secondButton addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        secondButton.frame = CGRectMake(CGRectGetMinX(secondImageView.frame) - 20, CGRectGetMinY(secondImageView.frame) - 20, CGRectGetWidth(secondImageView.frame) + 40, CGRectGetHeight(secondImageView.frame) + 40);
        [self addSubview:secondButton];

        
        
        UIImageView *thirdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, secondWidth, secondWidth)];
        thirdImageView.center = CGPointMake(backImageView.center.x + xPoint_SecondImageView, backImageView.center.y - 5 / 190.0 * CGRectGetHeight(backImageView.frame) );
        thirdImageView.contentMode = UIViewContentModeScaleAspectFit;
        thirdImageView.clipsToBounds = YES;
        thirdImageView.layer.cornerRadius = secondWidth / 2.0;
        thirdImageView.tag = 3;
        [self addSubview:thirdImageView];

        
        UIButton *thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        thirdButton.tag = 33;
        [thirdButton addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        thirdButton.frame = CGRectMake(CGRectGetMinX(thirdImageView.frame) - 20, CGRectGetMinY(thirdImageView.frame) - 20, CGRectGetWidth(thirdImageView.frame) + 40, CGRectGetHeight(thirdImageView.frame) + 40);
        [self addSubview:thirdButton];
        

        
        UILabel *firstNameLable = [[UILabel alloc]init];
        firstNameLable.tag = 4;
        firstNameLable.textColor = [UIColor whiteColor];
        firstNameLable.textAlignment = NSTextAlignmentCenter;
        firstNameLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:firstNameLable];
        [firstNameLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(firstImageView.mas_centerX);
             make.centerY.equalTo(firstImageView.mas_centerY).with.offset(55);
        }];
        
        UILabel *secondNameLable = [[UILabel alloc]init];
        secondNameLable.tag = 5;
        secondNameLable.textColor = [UIColor whiteColor];
        secondNameLable.textAlignment = NSTextAlignmentCenter;
        secondNameLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:secondNameLable];
        [secondNameLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(secondImageView.mas_centerX);
             make.centerY.equalTo(secondImageView.mas_centerY).with.offset(48);
         }];

        
        UILabel *thirdNameLable = [[UILabel alloc]init];
        thirdNameLable.tag = 6;
        thirdNameLable.textColor = [UIColor whiteColor];
        thirdNameLable.textAlignment = NSTextAlignmentCenter;
        thirdNameLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:thirdNameLable];
        [thirdNameLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(thirdImageView.mas_centerX);
             make.centerY.equalTo(thirdImageView.mas_centerY).with.offset(48);
         }];

        
        UILabel *firstGainLable = [[UILabel alloc]init];
        firstGainLable.tag = 7;
        firstGainLable.textColor = [UIColor whiteColor];
        firstGainLable.textAlignment = NSTextAlignmentCenter;
        firstGainLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:firstGainLable];
        [firstGainLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(firstNameLable.mas_centerX);
             make.centerY.equalTo(firstNameLable.mas_centerY).with.offset(30);
         }];
        
        UILabel *secondGainLable = [[UILabel alloc]init];
        secondGainLable.tag = 8;
        secondGainLable.textColor = [UIColor whiteColor];
        secondGainLable.textAlignment = NSTextAlignmentCenter;
        secondGainLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:secondGainLable];
        [secondGainLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(secondNameLable.mas_centerX);
             make.centerY.equalTo(secondNameLable.mas_centerY).with.offset(30);
         }];
        
        
        UILabel *thirdGainLable = [[UILabel alloc]init];
        thirdGainLable.tag = 9;
        thirdGainLable.textColor = [UIColor whiteColor];
        thirdGainLable.textAlignment = NSTextAlignmentCenter;
        thirdGainLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:thirdGainLable];
        [thirdGainLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(thirdNameLable.mas_centerX);
             make.centerY.equalTo(thirdNameLable.mas_centerY).with.offset(30);
         }];

        
        
        UILabel *firstPriceLable = [[UILabel alloc]init];
        firstPriceLable.tag = 10;
        firstPriceLable.textColor = [UIColor redColor];
        firstPriceLable.textAlignment = NSTextAlignmentCenter;
        firstPriceLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:firstPriceLable];
        [firstPriceLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(firstGainLable.mas_centerX);
             make.centerY.equalTo(firstGainLable.mas_centerY).with.offset(30);
         }];
        
        UILabel *secondPriceLable = [[UILabel alloc]init];
        secondPriceLable.tag = 11;
        secondPriceLable.textColor = [UIColor redColor];
        secondPriceLable.textAlignment = NSTextAlignmentCenter;
        secondPriceLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:secondPriceLable];
        [secondPriceLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(secondGainLable.mas_centerX);
             make.centerY.equalTo(secondGainLable.mas_centerY).with.offset(30);
         }];
        
        
        UILabel *thirdPriceLable = [[UILabel alloc]init];
        thirdPriceLable.tag = 12;
        thirdPriceLable.textColor = [UIColor redColor];
        thirdPriceLable.textAlignment = NSTextAlignmentCenter;
        thirdPriceLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:thirdPriceLable];
        [thirdPriceLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(thirdGainLable.mas_centerX);
             make.centerY.equalTo(thirdGainLable.mas_centerY).with.offset(30);
         }];
        

        UIImageView *firstPriceImageView = [[UIImageView alloc]initWithImage:self.textBackImage];
        firstPriceImageView.backgroundColor = [UIColor clearColor];
        firstPriceImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:firstPriceImageView];
        [firstPriceImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.center.equalTo(firstPriceLable);
             make.width.mas_equalTo(@65);
             make.height.equalTo(firstPriceImageView.mas_width).with.multipliedBy(11 / 25.0);
         }];
        UIImageView *secondPriceImageView = [[UIImageView alloc]initWithImage:self.textBackImage];
        secondPriceImageView.backgroundColor = [UIColor clearColor];
        secondPriceImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:secondPriceImageView];
        [secondPriceImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.center.equalTo(secondPriceLable);
             make.width.equalTo(firstPriceImageView);
             make.height.equalTo(secondPriceImageView.mas_width).with.multipliedBy(11 / 25.0);
         }];


        UIImageView *thirdPriceImageView = [[UIImageView alloc]initWithImage:self.textBackImage];
        thirdPriceImageView.backgroundColor = [UIColor clearColor];
        thirdPriceImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:thirdPriceImageView];
        [thirdPriceImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.center.equalTo(thirdPriceLable);
             make.width.equalTo(firstPriceImageView);
             make.height.equalTo(thirdPriceImageView.mas_width).with.multipliedBy(11 / 25.0);
         }];

        
        
        
        self.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(backImageView.frame) + 75);
        
        [self setDefaultText];
        
        
        NSLog(@"self.frame ======== %@",[NSValue valueWithCGRect:self.frame]);
        
        
    }
    
    return self;
}

- (UIImage *)textBackImage
{
    if (_textBackImage == nil)
    {
        UIImage *image = [UIImage imageNamed:@"ProfitRoll_BackText"];// 25 ： 11
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 10, 3, 10) resizingMode:UIImageResizingModeStretch];
        _textBackImage = image;
    }
    
    return _textBackImage;
}

- (void)setDefaultText
{
    UILabel *topLable = [self viewWithTag:66];
    topLable.text = [self getCurrentTime];
    
    
    UIImageView *firstImageView = [self viewWithTag:1];
    firstImageView.image = [UIImage imageNamed:@""];
    
    UIImageView *secondImageView = [self viewWithTag:2];
    secondImageView.image = [UIImage imageNamed:@""];
    
    UIImageView *thirdImageView = [self viewWithTag:3];
    thirdImageView.image = [UIImage imageNamed:@""];
    
    UILabel *firstNameLable = [self viewWithTag:4];
    firstNameLable.text = @"";
    
    UILabel *secondNameLable = [self viewWithTag:5];
    secondNameLable.text = @"";
    
    UILabel *thirdNameLable = [self viewWithTag:6];
    thirdNameLable.text = @"";
    
    
    UILabel *firstGainLable = [self viewWithTag:7];
    firstGainLable.text = @"";
    
    UILabel *secondGainLable = [self viewWithTag:8];
    secondGainLable.text = @"";
    
    UILabel *thirdGainLable = [self viewWithTag:9];
    thirdGainLable.text = @"";
    
    
    
    UILabel *firstPriceLable = [self viewWithTag:10];
    firstPriceLable.text = @"";
    
    UILabel *secondPriceLable = [self viewWithTag:11];
    secondPriceLable.text = @"";
    
    UILabel *thirdPriceLable = [self viewWithTag:12];
    thirdPriceLable.text = @"";
    

}

- (void)updateProfitRollTableHeaderView:(NSMutableArray<InorderModel *> *)listArray
{
    _listArray = listArray;
    
    UILabel *topLable = [self viewWithTag:66];
    topLable.text = [self getCurrentTime];
    
    
    if (listArray && listArray.count)
    {
        InorderModel *firstModel = listArray[0];
        UIImageView *firstImageView = [self viewWithTag:1];
        [firstImageView sd_setImageWithURL:[NSURL URLWithString:firstModel.headImg] placeholderImage:[UIImage imageNamed:@"placeholderHeader"]];

        
        NSLog(@"firstImageView ======= %@",firstImageView);
        NSLog(@"firstModel.headImg ======= %@",firstModel.headImg);
        
        
        UILabel *firstNameLable = [self viewWithTag:4];
        firstNameLable.text = firstModel.mobile;
        
        UILabel *firstGainLable = [self viewWithTag:7];
        firstGainLable.text = [NSString stringWithFormat:@"盈利 %.1f%%",[firstModel.plPercent floatValue] * 100];
        
        UILabel *firstPriceLable = [self viewWithTag:10];
        firstPriceLable.text = @"￥160";

    }
    
    
    if (listArray && listArray.count >1)
    {
        
        InorderModel *secondModel = listArray[1];
        UIImageView *secondImageView = [self viewWithTag:2];
        [secondImageView sd_setImageWithURL:[NSURL URLWithString:secondModel.headImg] placeholderImage:[UIImage imageNamed:@"placeholderHeader"]];
        
        
        UILabel *secondNameLable = [self viewWithTag:5];
        secondNameLable.text = secondModel.mobile;
        
        
        UILabel *secondGainLable = [self viewWithTag:8];
        secondGainLable.text = [NSString stringWithFormat:@"盈利 %.1f%%",[secondModel.plPercent floatValue] * 100];

        UILabel *secondPriceLable = [self viewWithTag:11];
        secondPriceLable.text = @"￥80";
    }
    
    
    
    if (listArray && listArray.count > 2)
    {
        InorderModel *thirdModel = listArray[2];
        
        UIImageView *thirdImageView = [self viewWithTag:3];
        [thirdImageView sd_setImageWithURL:[NSURL URLWithString:thirdModel.headImg] placeholderImage:[UIImage imageNamed:@"placeholderHeader"]];
        
        UILabel *thirdNameLable = [self viewWithTag:6];
        thirdNameLable.text = thirdModel.mobile;
        
        
        UILabel *thirdGainLable = [self viewWithTag:9];
        thirdGainLable.text = [NSString stringWithFormat:@"盈利 %.1f%%",[thirdModel.plPercent floatValue] * 100];
        
        
        UILabel *thirdPriceLable = [self viewWithTag:12];
        thirdPriceLable.text = @"￥32";
    }
    
}


- (NSString*)getCurrentTime
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    
    
    return [formatter stringFromDate:[NSDate date]];
}

- (void)headerButtonClick:(UIButton *)sender
{
    NSInteger rank = sender.tag - 30;
    
    
    ProfitRollDeatileVC *detaileVC = [[ProfitRollDeatileVC alloc]initWithNibName:@"ProfitRollDeatileVC" bundle:nil];
    
    detaileVC.rankLevel = rank;
    if (rank == 1 && _listArray && _listArray.count)
    {
        detaileVC.model = _listArray[0];
        detaileVC.awardMoney = 160;
        
        [self.viewController.navigationController pushViewController:detaileVC animated:YES];

    }
    else if (rank == 2 && _listArray && _listArray.count > 1)
    {
        detaileVC.model = _listArray[1];
        detaileVC.awardMoney = 80;
        
        [self.viewController.navigationController pushViewController:detaileVC animated:YES];

    }
    else if(rank == 3 && _listArray && _listArray.count > 2)
    {
        detaileVC.model = _listArray[2];
        detaileVC.awardMoney = 32;
        
        [self.viewController.navigationController pushViewController:detaileVC animated:YES];

    }
    
    
    
}





@end
