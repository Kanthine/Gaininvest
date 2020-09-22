//
//  TradeDetaileView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/22.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define MelanicColor RGBA(114, 119, 136, 1)

#import "TradeDetaileView.h"
#import "UIColor+Y_StockChart.h"
#import <Masonry.h>

@interface TradeDetaileView()

@property (nonatomic ,strong) UIView *leftContentView;
@property (nonatomic ,strong) UIView *rightContentView;

@end

@implementation TradeDetaileView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self initSubView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initSubView];
    }
    
    return self;
}

- (void)initSubView
{
    self.backgroundColor = NavBarBackColor;

    [self addSubview:self.leftContentView];
    [self addSubview:self.rightContentView];
    
    [self.leftContentView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(@0);
         make.left.mas_equalTo(@0);
         make.width.mas_equalTo(@160);
         make.bottom.mas_equalTo(@0);
     }];
    
    [self.rightContentView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(@0);
         make.left.equalTo(_leftContentView.mas_right).with.offset(0);
         make.right.mas_equalTo(@0);
//         make.width.equalTo(_leftContentView);
     }];
}





- (UIView *)leftContentView
{
    if (_leftContentView == nil)
    {
        UIView *leftContentView = [[UIView alloc]init];
        leftContentView.backgroundColor = [UIColor clearColor];
        
        
        
        UILabel *topLeftLable = [[UILabel alloc]init];
        topLeftLable.tag = 1;
        topLeftLable.text = @"----";
        topLeftLable.textAlignment = NSTextAlignmentLeft;
        topLeftLable.font = [UIFont systemFontOfSize:25];
        topLeftLable.textColor = [UIColor redColor];
        [leftContentView addSubview:topLeftLable];
        [topLeftLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@10);
         }];

        
        
        UILabel *middleLeftLable = [[UILabel alloc]init];
        middleLeftLable.tag = 2;
        middleLeftLable.text = @"----";
        middleLeftLable.textAlignment = NSTextAlignmentCenter;
        middleLeftLable.font = [UIFont systemFontOfSize:12];
        middleLeftLable.textColor = [UIColor redColor];
        [leftContentView addSubview:middleLeftLable];
        
        UILabel *middleRightLable = [[UILabel alloc]init];
        middleRightLable.tag = 3;
        middleRightLable.text = @"----";
        middleRightLable.textAlignment = NSTextAlignmentRight;
        middleRightLable.font = [UIFont systemFontOfSize:12];
        middleRightLable.textColor = [UIColor redColor];
        [leftContentView addSubview:middleRightLable];
        
        
        [middleLeftLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(topLeftLable.mas_bottom).with.offset(2);
             make.left.mas_equalTo(@10);
         }];
        
        [middleRightLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(middleLeftLable.mas_top).with.offset(0);
             make.left.equalTo(middleLeftLable.mas_right).with.offset(15);
         }];
        
        
        
        UILabel *bottomLable = [[UILabel alloc]init];
        bottomLable.tag = 4;
        bottomLable.text = @"休市中";
        bottomLable.textAlignment = NSTextAlignmentCenter;
        bottomLable.font = [UIFont systemFontOfSize:12];
        bottomLable.textColor = MelanicColor;
        [leftContentView addSubview:bottomLable];

        [bottomLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(middleLeftLable.mas_bottom).with.offset(2);
             make.left.mas_equalTo(@10);
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
        rightContentView.backgroundColor = [UIColor clearColor];
        
        
        UILabel *middleLeftLable = [[UILabel alloc]init];
        middleLeftLable.text = @"今开:";
        middleLeftLable.textAlignment = NSTextAlignmentLeft;
        middleLeftLable.font = [UIFont systemFontOfSize:14];
        middleLeftLable.textColor = MelanicColor;
        [rightContentView addSubview:middleLeftLable];
        CGFloat lableWidth = [middleLeftLable.text boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : middleLeftLable.font} context:nil].size.width + 3;

        UILabel *middleRightLable = [[UILabel alloc]init];
        middleRightLable.text = @"最高:";
        middleRightLable.textAlignment = NSTextAlignmentLeft;
        middleRightLable.font = [UIFont systemFontOfSize:14];
        middleRightLable.textColor = MelanicColor;
        [rightContentView addSubview:middleRightLable];

        
        
        
        [middleLeftLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@5);
             make.left.mas_equalTo(@0);
             make.width.mas_equalTo(@(lableWidth));
         }];
        
        [middleRightLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.mas_equalTo(middleLeftLable);
             make.centerX.mas_equalTo(rightContentView.mas_centerX).with.offset(lableWidth / 2.0);
             make.width.equalTo(middleLeftLable);
         }];
        
        
        
        
        
        
        
        UILabel *bottomLeftLable = [[UILabel alloc]init];
        bottomLeftLable.text = @"昨收:";
        bottomLeftLable.textAlignment = NSTextAlignmentLeft;
        bottomLeftLable.font = [UIFont systemFontOfSize:14];
        bottomLeftLable.textColor = MelanicColor;
        [rightContentView addSubview:bottomLeftLable];
        
        UILabel *bottomRightLable = [[UILabel alloc]init];
        bottomRightLable.text = @"最低:";
        bottomRightLable.textAlignment = NSTextAlignmentLeft;
        bottomRightLable.font = [UIFont systemFontOfSize:14];
        bottomRightLable.textColor = MelanicColor;
        [rightContentView addSubview:bottomRightLable];
        
        
        [bottomLeftLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(middleLeftLable.mas_bottom).with.offset(10);
             make.left.mas_equalTo(@0);
             make.width.equalTo(middleLeftLable);
         }];
        
        [bottomRightLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.mas_equalTo(bottomLeftLable);
             make.centerX.mas_equalTo(middleRightLable);
             make.width.equalTo(middleLeftLable);
         }];

        
        
        
        
        
        UILabel *middleLeftContentLable = [[UILabel alloc]init];
        middleLeftContentLable.text = @"----";
        middleLeftContentLable.tag = 4;
        middleLeftContentLable.adjustsFontSizeToFitWidth = YES;
        middleLeftContentLable.textAlignment = NSTextAlignmentLeft;
        middleLeftContentLable.font = [UIFont systemFontOfSize:14];
        middleLeftContentLable.textColor = [UIColor whiteColor];
        [rightContentView addSubview:middleLeftContentLable];
        
        UILabel *middleRightContentLable = [[UILabel alloc]init];
        middleRightContentLable.text = @"----";
        middleRightContentLable.tag = 5;
        middleRightContentLable.adjustsFontSizeToFitWidth = YES;
        middleRightContentLable.textAlignment = NSTextAlignmentLeft;
        middleRightContentLable.font = [UIFont systemFontOfSize:14];
        middleRightContentLable.textColor = [UIColor whiteColor];;
        [rightContentView addSubview:middleRightContentLable];
        
        
        
        
        [middleLeftContentLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.mas_equalTo(middleLeftLable);
             make.left.equalTo(middleLeftLable.mas_right);
             make.right.equalTo(middleRightLable.mas_left);
         }];
        [middleRightContentLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.mas_equalTo(middleLeftLable);
             make.left.equalTo(middleRightLable.mas_right);
             make.right.mas_equalTo(@0);
         }];
        
        
        
        
        
        UILabel *bottomLeftContentLable = [[UILabel alloc]init];
        bottomLeftContentLable.adjustsFontSizeToFitWidth = YES;
        bottomLeftContentLable.text = @"----";
        bottomLeftContentLable.tag = 6;
        bottomLeftContentLable.textAlignment = NSTextAlignmentLeft;
        bottomLeftContentLable.font = [UIFont systemFontOfSize:14];
        bottomLeftContentLable.textColor = [UIColor whiteColor];
        [rightContentView addSubview:bottomLeftContentLable];
        
        UILabel *bottomRightContentLable = [[UILabel alloc]init];
        bottomRightContentLable.tag = 7;
        bottomRightContentLable.text = @"----";
        bottomRightContentLable.adjustsFontSizeToFitWidth = YES;
        bottomRightContentLable.textAlignment = NSTextAlignmentLeft;
        bottomRightContentLable.font = [UIFont systemFontOfSize:14];
        bottomRightContentLable.textColor = [UIColor whiteColor];;
        [rightContentView addSubview:bottomRightContentLable];
        
        
        
        
        [bottomLeftContentLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.mas_equalTo(bottomLeftLable);
             make.left.equalTo(bottomLeftLable.mas_right);
             make.right.equalTo(bottomRightLable.mas_left);
         }];
        [bottomRightContentLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.mas_equalTo(bottomLeftLable);
             make.left.equalTo(bottomRightLable.mas_right);
             make.right.mas_equalTo(@0);
         }];
        

        
        
        
        _rightContentView = rightContentView;
    }
    
    return _rightContentView;
}

- (void)updateTradeDetaileView:(NSDictionary *)marketQuotationDict
{
    marketQuotationDict = marketQuotationDict[@"HGAG"];
    if (marketQuotationDict && [marketQuotationDict isKindOfClass:[NSDictionary class]])
    {

        UILabel *topLableLeft = [self.leftContentView viewWithTag:1];
        UILabel *middleLeftLable = [self.leftContentView viewWithTag:2];
        UILabel *middleRightLable = [self.leftContentView viewWithTag:3];
        UILabel *bottomLableLeft = [self.leftContentView viewWithTag:4];
        
        
        
        bottomLableLeft.text = marketQuotationDict[@"createDate"];
        
        
        
        
        UILabel *middleLeftContentLable = [self.rightContentView viewWithTag:4];
        UILabel *middleRightContentLable = [self.rightContentView viewWithTag:5];
        UILabel *bottomLeftContentLable = [self.rightContentView viewWithTag:6];
        UILabel *bottomRightContentLable = [self.rightContentView viewWithTag:7];
        
        
        int  addedValue = [marketQuotationDict[@"quote"] intValue] - [marketQuotationDict[@"preClose"] intValue];
        float uprate = addedValue / [marketQuotationDict[@"preClose"] floatValue] * 100.0;
        NSString *addedValueString = @"";
        NSString *uprateString = @"";
        if (addedValue > 0)
        {
            addedValueString = [NSString stringWithFormat:@"+%d",addedValue];
            uprateString = [NSString stringWithFormat:@"+%.2f",uprate];
            
            
            topLableLeft.textColor = [UIColor decreaseColor];
            middleLeftLable.textColor = [UIColor decreaseColor];
            middleRightLable.textColor = [UIColor decreaseColor];
            
            NSLog(@"涨的颜色啊");
        }
        else
        {
            addedValueString = [NSString stringWithFormat:@"%d",addedValue];
            uprateString = [NSString stringWithFormat:@"%.2f",uprate];
            
            topLableLeft.textColor = [UIColor increaseColor];
            middleLeftLable.textColor = [UIColor increaseColor];
            middleRightLable.textColor = [UIColor increaseColor];

            
            NSLog(@"跌的颜色啊");
        }
        
        topLableLeft.text = marketQuotationDict[@"quote"];
        middleLeftLable.text = addedValueString;
        middleRightLable.text = [uprateString stringByAppendingString:@"%"];
        
        middleLeftContentLable.text = marketQuotationDict[@"open"];
        middleRightContentLable.text = marketQuotationDict[@"high"];
        bottomLeftContentLable.text = marketQuotationDict[@"preClose"];
        bottomRightContentLable.text = marketQuotationDict[@"low"];
    }

    
}

- (void)updateFalseTradeDetaileView:(NSArray *)array LastPrice:(NSString *)lastPrice
{
    if (array && [array isKindOfClass:[NSArray class]] && array.count > 3)
    {
        UILabel *middleLeftContentLable = [self.rightContentView viewWithTag:4];
        UILabel *middleRightContentLable = [self.rightContentView viewWithTag:5];
        UILabel *bottomLeftContentLable = [self.rightContentView viewWithTag:6];
        UILabel *bottomRightContentLable = [self.rightContentView viewWithTag:7];

        middleLeftContentLable.text = [NSString stringWithFormat:@"%.0f",[array[0] floatValue]];
        middleRightContentLable.text =  [NSString stringWithFormat:@"%.0f",[array[3] floatValue]];
        bottomLeftContentLable.text = [NSString stringWithFormat:@"%.0f",[array[1] floatValue]];
        bottomRightContentLable.text = [NSString stringWithFormat:@"%.0f",[array[2] floatValue]];
    }
    
    
    if (lastPrice && lastPrice.length > 0)
    {
        UILabel *topLableLeft = [self.leftContentView viewWithTag:1];
        topLableLeft.textColor = [UIColor decreaseColor];
        topLableLeft.text = lastPrice;
    }
}


@end
