//
//  TransactionBuyUpOrDownView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/23.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define AnimationDuration 0.2

#import "TransactionBuyUpOrDownView.h"
#import <Masonry.h>


#import "TransactionViewController.h"
#import "RechargeViewController.h"

#import "UIColor+Y_StockChart.h"


@interface TransactionBuyUpOrDownView()

{
    BOOL _isUseCoupon;
    NSInteger _currentProductIndex;
    NSArray *_productListArray;
}

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *kindLeftView;
@property (nonatomic, strong) UIView *kindMiddleView;
@property (nonatomic, strong) UIView *kindRightView;


@property (nonatomic, strong) UIView *slideCountView;
@property (nonatomic, strong) UIView *slideGainView;
@property (nonatomic, strong) UIView *slideLossView;


@property (nonatomic, strong) UIView *bottomView;



@end

@implementation TransactionBuyUpOrDownView

#pragma mark - Private Method

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _isUseCoupon = NO;
        [self addSubview:self.coverButton];
        [self addSubview:self.contentView];
    }
    
    return self;
}

- (UIButton *)coverButton
{
    if (_coverButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blackColor];
        button.alpha = 0.0;
        [button addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);

        
        _coverButton = button;
    }
    
    return _coverButton;
}

- (UIView *)contentView
{
    if (_contentView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        
        
        
        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 20)];
        topLable.tag = 1;
        topLable.text = @"余额：0元";
        topLable.textColor = TextColorGray;
        topLable.textAlignment = NSTextAlignmentLeft;
        topLable.font = [UIFont systemFontOfSize:15];
        [view addSubview:topLable];

        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [topButton addTarget:self action:@selector(pushRechargeViewControllerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [topButton setTitle:@"充值" forState:UIControlStateNormal];
        [topButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        topButton.titleLabel.font = [UIFont systemFontOfSize:15];
        topButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        topButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        topButton.frame = CGRectMake(ScreenWidth - 70, 0, 70, 40);
        [view addSubview:topButton];

        
        
        [view addSubview:self.kindLeftView];
        [view addSubview:self.kindMiddleView];
        [view addSubview:self.kindRightView];
        
        self.kindLeftView.frame = CGRectMake(10, CGRectGetMaxY(topButton.frame), (ScreenWidth - 40) / 3.0, (ScreenWidth - 50) / 3.0);
        self.kindMiddleView.frame = CGRectMake(CGRectGetMaxX(self.kindLeftView.frame) + 10, CGRectGetMaxY(topButton.frame), CGRectGetWidth(self.kindLeftView.frame), CGRectGetWidth(self.kindLeftView.frame));
        self.kindRightView.frame = CGRectMake(CGRectGetMaxX(self.kindMiddleView.frame) + 10, CGRectGetMaxY(topButton.frame), CGRectGetWidth(self.kindMiddleView.frame), CGRectGetWidth(self.kindMiddleView.frame));

        
        
        UIButton *buyUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyUpButton.tag = 20;
        [buyUpButton setTitle:@"买涨" forState:UIControlStateNormal];
        [buyUpButton addTarget:self action:@selector(chooseBuyUpOrDownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        buyUpButton.layer.cornerRadius = 5;
        buyUpButton.layer.borderWidth = 1;
        buyUpButton.clipsToBounds = YES;
        [buyUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buyUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        buyUpButton.titleLabel.font = [UIFont systemFontOfSize:15];
        buyUpButton.frame = CGRectMake(10, CGRectGetMaxY(self.kindLeftView.frame) + 15,  CGRectGetWidth(self.kindMiddleView.frame) + 20, 40);
        buyUpButton.selected = YES;
        [self setBuyUPButtonSelectStateButton:buyUpButton];
        [view addSubview:buyUpButton];
        
        
        UIButton *buyDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyDownButton.tag = 30;
        buyDownButton.selected = NO;
        buyDownButton.layer.cornerRadius = 5;
        [buyDownButton addTarget:self action:@selector(chooseBuyUpOrDownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        buyDownButton.layer.borderWidth = 1;
        buyDownButton.clipsToBounds = YES;
        [buyDownButton setTitle:@"买跌" forState:UIControlStateNormal];
        [buyDownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buyDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];        buyDownButton.titleLabel.font = [UIFont systemFontOfSize:15];
        buyDownButton.frame = CGRectMake(ScreenWidth - CGRectGetWidth(buyUpButton.frame) - 10, CGRectGetMaxY(self.kindLeftView.frame) + 15, CGRectGetWidth(buyUpButton.frame), 40);
        [self setBuyUPButtonSelectStateButton:buyDownButton];
        [view addSubview:buyDownButton];

        
        [view addSubview:self.slideCountView];
        [view addSubview:self.slideGainView];
        [view addSubview:self.slideLossView];

        self.slideCountView.frame = CGRectMake(0, CGRectGetMaxY(buyDownButton.frame) + 20, ScreenWidth,85);
        self.slideGainView.frame = CGRectMake(0, CGRectGetMaxY(self.slideCountView.frame) + 10, ScreenWidth,50);
        self.slideLossView.frame = CGRectMake(0, CGRectGetMaxY(self.slideGainView.frame) + 10, ScreenWidth,50);

        [view addSubview:self.bottomView];
        self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.slideLossView.frame), ScreenWidth,54);

        
        
        
        view.frame = CGRectMake(0, ScreenHeight, ScreenWidth, CGRectGetMaxY(self.bottomView.frame));
        _contentView = view;
    }
    
    return _contentView;
}

- (UIView *)kindLeftView
{
    if (_kindLeftView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = RGBA(240, 242, 245, 1);
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        view.layer.borderWidth = 1;
        view.layer.borderColor = RGBA(237, 238, 240, 1).CGColor;
        
        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 20)];
        [topLable sizeToFit];
        topLable.tag = 1;
        topLable.text = @"银币0.1元/千克";
        topLable.textColor = TextColorGray;
        topLable.textAlignment = NSTextAlignmentCenter;
        topLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:topLable];

        [topLable mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.mas_equalTo(@10);
            make.left.mas_equalTo(@0);
            make.right.mas_equalTo(@0);
        }];
        
        
        
        UILabel *bottomLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 20)];
        bottomLable.tag = 3;
        bottomLable.text = @"元/手";
        bottomLable.textColor = TextColorGray;
        bottomLable.textAlignment = NSTextAlignmentCenter;
        bottomLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:bottomLable];
        [bottomLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.bottom.mas_equalTo(@-8);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];

        
        UILabel *middleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 20)];
        middleLable.tag = 2;
        middleLable.text = @"200";
        middleLable.textColor = TextColorGray;
        middleLable.textAlignment = NSTextAlignmentCenter;
        middleLable.font = [UIFont systemFontOfSize:25];
        [view addSubview:middleLable];
        [middleLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.center.equalTo(view);
         }];

        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 101;
        [button addTarget:self action:@selector(kindLeftViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];

        
        [self setKindViewSelectState:YES SuperView:view Index:0];

        _kindLeftView = view;
    }
    
    return _kindLeftView;
}

- (UIView *)kindMiddleView
{
    if (_kindMiddleView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        view.layer.borderWidth = 1;
        view.layer.borderColor = RGBA(237, 238, 240, 1).CGColor;
        
        
        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 20)];
        [topLable sizeToFit];
        topLable.tag = 1;
        topLable.text = @"银币0.1元/千克";
        topLable.textColor = TextColorGray;
        topLable.textAlignment = NSTextAlignmentCenter;
        topLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:topLable];
        [topLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
        
        
        
        UILabel *bottomLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 20)];
        bottomLable.tag = 3;
        bottomLable.text = @"元/手";
        bottomLable.textColor = TextColorGray;
        bottomLable.textAlignment = NSTextAlignmentCenter;
        bottomLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:bottomLable];
        [bottomLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.bottom.mas_equalTo(@-8);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
        
        
        UILabel *middleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 20)];
        middleLable.tag = 2;
        middleLable.text = @"200";
        middleLable.textColor = TextColorGray;
        middleLable.textAlignment = NSTextAlignmentCenter;
        middleLable.font = [UIFont systemFontOfSize:25];
        [view addSubview:middleLable];
        [middleLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.center.equalTo(view);
         }];
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 102;
        [button addTarget:self action:@selector(kindLeftViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];

        
        [self setKindViewSelectState:NO SuperView:view Index:1];

        _kindMiddleView = view;
    }
    
    return _kindMiddleView;
}

- (UIView *)kindRightView
{
    if (_kindRightView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        view.layer.borderWidth = 1;
        view.layer.borderColor = RGBA(237, 238, 240, 1).CGColor;
        
        
        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 20)];
        topLable.tag = 1;
        topLable.text = @"银币0.1元/千克";
        topLable.textColor = TextColorGray;
        topLable.textAlignment = NSTextAlignmentCenter;
        topLable.font = [UIFont systemFontOfSize:14];
        [topLable sizeToFit];
        [view addSubview:topLable];
        
        [topLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
        
        
        
        UILabel *bottomLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 20)];
        bottomLable.tag = 3;
        bottomLable.text = @"元/手";
        bottomLable.textColor = TextColorGray;
        bottomLable.textAlignment = NSTextAlignmentCenter;
        bottomLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:bottomLable];
        [bottomLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.bottom.mas_equalTo(@-8);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
        
        
        UILabel *middleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 20)];
        middleLable.tag = 2;
        middleLable.text = @"200";
        middleLable.textColor = TextColorGray;
        middleLable.textAlignment = NSTextAlignmentCenter;
        middleLable.font = [UIFont systemFontOfSize:25];
        [view addSubview:middleLable];
        [middleLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.center.equalTo(view);
         }];
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 103;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(kindLeftViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];

        
        [self setKindViewSelectState:NO SuperView:view Index:2];
        _kindRightView = view;
    }
    
    return _kindRightView;
}



- (UIView *)slideCountView
{
    if (_slideCountView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 101;

        
        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 16)];
        topLable.tag = 1;
        topLable.text = @"买几手：0";
        topLable.textColor = TextColorGray;
        topLable.textAlignment = NSTextAlignmentCenter;
        topLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:topLable];
        
        
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_BuyDown"]];
        leftImageView.frame = CGRectMake(10, CGRectGetMaxY(topLable.frame) + 5, 20, 20);
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:leftImageView];
        
        
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_BuyUp"]];
        rightImageView.frame = CGRectMake(ScreenWidth - 30,CGRectGetMaxY(topLable.frame) + 5, 20, 20);
        rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:rightImageView];

        
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame), leftImageView.frame.origin.y, 60, CGRectGetHeight(leftImageView.frame))];
        leftLable.text = @"0手";
        leftLable.tag = 2;
        leftLable.textColor = TextColorGray;
        leftLable.textAlignment = NSTextAlignmentCenter;
        leftLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:leftLable];

        
        UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(rightImageView.frame) - 60, rightImageView.frame.origin.y , 60, CGRectGetHeight(leftImageView.frame))];
        rightLable.text = @"10手";
        rightLable.tag = 3;
        rightLable.textColor = TextColorGray;
        rightLable.textAlignment = NSTextAlignmentCenter;
        rightLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:rightLable];
        
        
        UISlider *slide = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLable.frame), rightImageView.frame.origin.y , ScreenWidth - 2 * CGRectGetMaxX(leftLable.frame), 30)];
        slide.tag = 4;
        slide.value = 5;
        slide.minimumValue = 0;
        slide.maximumValue = 10;
        [slide setValue:0 animated:YES];
        [slide addTarget:self action:@selector(slideValueChangeClick:) forControlEvents:UIControlEventValueChanged];
        slide.center = CGPointMake(topLable.center.x, rightImageView.center.y);
        [view addSubview:slide];

        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.tag = 5;
        [leftButton addTarget:self action:@selector(changeSlideValueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.frame = CGRectMake(0, 7, CGRectGetMaxX(leftLable.frame) - 10, 35);
        [view addSubview:leftButton];
        
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.tag = 6;
        rightButton.backgroundColor = [UIColor clearColor];
        [rightButton addTarget:self action:@selector(changeSlideValueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.frame = CGRectMake(ScreenWidth - CGRectGetWidth(leftButton.frame), leftButton.frame.origin.y, CGRectGetWidth(leftButton.frame), CGRectGetHeight(leftButton.frame));
        [view addSubview:rightButton];
        
        
        
        UILabel *couponLable = [[UILabel alloc]init];
        couponLable.backgroundColor = [UIColor clearColor];
        couponLable.tag = 7;
        couponLable.text = @"使用体验券(当前可用1张)";
        couponLable.textColor = TextColorGray;
        couponLable.textAlignment = NSTextAlignmentRight;
        couponLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:couponLable];
        [couponLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(rightImageView.mas_bottom).with.offset(10);
             make.right.mas_equalTo(@-10);
         }];
        UIImageView *couponImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ImageTransaction_CouponNoUse"] highlightedImage:[UIImage imageNamed:@"Transaction_CouponUse"]];
        couponImageView.tag = 8;
        couponImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:couponImageView];
        [couponImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(couponLable.mas_centerY);
             make.right.equalTo(couponLable.mas_left).with.offset(-4);
             make.width.mas_equalTo(@16);
             make.height.mas_equalTo(@16);
         }];
        UIButton *couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
        couponButton.tag = 9;
        couponButton.backgroundColor = [UIColor clearColor];
        [couponButton addTarget:self action:@selector(couponButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:couponButton];
        [couponButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(slide.mas_bottom);
             make.left.equalTo(couponImageView.mas_left).with.offset(-20);
             make.height.mas_equalTo(@35);
             make.width.mas_equalTo(@60);

         }];
        
        UIView *grayView = [UIView new];
        grayView.backgroundColor = TableGrayColor;
        [view addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.bottom.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@10);
         }];
        [view bringSubviewToFront:couponButton];
        
        _slideCountView = view;
    }
    
    return _slideCountView;
}


- (UIView *)slideGainView
{
    if (_slideGainView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        view.tag = 102;
        
        
        
        
        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 16)];
        topLable.tag = 1;
        topLable.text = @"止损：不限";
        topLable.textColor = TextColorGray;
        topLable.textAlignment = NSTextAlignmentCenter;
        topLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:topLable];
        
        
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_BuyDown"]];
        leftImageView.frame = CGRectMake(10, CGRectGetMaxY(topLable.frame) + 5, 20, 20);
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:leftImageView];
        
        
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_BuyUp"]];
        rightImageView.frame = CGRectMake(ScreenWidth - 30,CGRectGetMaxY(topLable.frame) + 5, 20, 20);
        rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:rightImageView];
        
        
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame), leftImageView.frame.origin.y, 60, CGRectGetHeight(leftImageView.frame))];
        leftLable.text = @"不限";
        leftLable.textColor = TextColorGray;
        leftLable.textAlignment = NSTextAlignmentCenter;
        leftLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:leftLable];
        
        
        UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(rightImageView.frame) - 60, rightImageView.frame.origin.y , 60, CGRectGetHeight(leftImageView.frame))];
        rightLable.text = @"50点";
        rightLable.textColor = TextColorGray;
        rightLable.textAlignment = NSTextAlignmentCenter;
        rightLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:rightLable];
        
        
        UISlider *slide = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLable.frame), rightImageView.frame.origin.y , ScreenWidth - 2 * CGRectGetMaxX(leftLable.frame), 30)];
        slide.tag = 4;
        slide.minimumValue = 0;
        slide.maximumValue = 5;
        [slide setValue:0 animated:YES];
        [slide addTarget:self action:@selector(slideValueChangeClick:) forControlEvents:UIControlEventValueChanged];
        slide.center = CGPointMake(topLable.center.x, rightImageView.center.y);
        [view addSubview:slide];
        
        
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.tag = 5;
        [leftButton addTarget:self action:@selector(changeSlideValueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.frame = CGRectMake(0, 7, CGRectGetMaxX(leftLable.frame) - 10, 35);
        [view addSubview:leftButton];
        
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.tag = 6;
        [rightButton addTarget:self action:@selector(changeSlideValueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.frame = CGRectMake(ScreenWidth - CGRectGetWidth(leftButton.frame), leftButton.frame.origin.y, CGRectGetWidth(leftButton.frame), CGRectGetHeight(leftButton.frame));
        [view addSubview:rightButton];

        
        _slideGainView = view;
    }
    
    return _slideGainView;
}

- (UIView *)slideLossView
{
    if (_slideLossView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 103;
        
        
        
        
        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 16)];
        topLable.tag = 1;
        topLable.text = @"止盈：不限";
        topLable.textColor = TextColorGray;
        topLable.textAlignment = NSTextAlignmentCenter;
        topLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:topLable];
        
        
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_BuyDown"]];
        leftImageView.frame = CGRectMake(10, CGRectGetMaxY(topLable.frame) + 5, 20, 20);
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:leftImageView];
        
        
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_BuyUp"]];
        rightImageView.frame = CGRectMake(ScreenWidth - 30,CGRectGetMaxY(topLable.frame) + 5, 20, 20);
        rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:rightImageView];
        
        
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame), leftImageView.frame.origin.y, 60, CGRectGetHeight(leftImageView.frame))];
        leftLable.text = @"不限";
        leftLable.textColor = TextColorGray;
        leftLable.textAlignment = NSTextAlignmentCenter;
        leftLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:leftLable];
        
        
        UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(rightImageView.frame) - 60, rightImageView.frame.origin.y , 60, CGRectGetHeight(leftImageView.frame))];
        rightLable.text = @"50点";
        rightLable.textColor = TextColorGray;
        rightLable.textAlignment = NSTextAlignmentCenter;
        rightLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:rightLable];
        
        
        UISlider *slide = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLable.frame), rightImageView.frame.origin.y , ScreenWidth - 2 * CGRectGetMaxX(leftLable.frame), 30)];
        slide.tag = 4;
        slide.minimumValue = 0;
        slide.maximumValue = 5;
        [slide setValue:0 animated:YES];
        [slide addTarget:self action:@selector(slideValueChangeClick:) forControlEvents:UIControlEventValueChanged];
        slide.center = CGPointMake(topLable.center.x, rightImageView.center.y);
        [view addSubview:slide];
        
        
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.tag = 5;
        [leftButton addTarget:self action:@selector(changeSlideValueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.frame = CGRectMake(0, 7, CGRectGetMaxX(leftLable.frame) - 10, 35);
        [view addSubview:leftButton];
        
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.tag = 6;
        [rightButton addTarget:self action:@selector(changeSlideValueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.frame = CGRectMake(ScreenWidth - CGRectGetWidth(leftButton.frame), leftButton.frame.origin.y, CGRectGetWidth(leftButton.frame), CGRectGetHeight(leftButton.frame));
        [view addSubview:rightButton];
        
        _slideLossView = view;
    }
    
    return _slideLossView;
}

- (UIView *)bottomView
{
    if (_bottomView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        
        UIView *grayView = [UIView new];
        grayView.backgroundColor = TableGrayColor;
        [view addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.mas_equalTo(@0);
            make.left.mas_equalTo(@0);
            make.right.mas_equalTo(@0);
            make.height.mas_equalTo(@10);
        }];
        
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.tag = 4;
        rightButton.backgroundColor = RGBA(252, 71, 75, 1);
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightButton setTitle:@"下单" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(placeAnOrderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(grayView.mas_bottom);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.width.mas_equalTo(@100);
         }];

        
        UILabel *leftLable = [[UILabel alloc]init];
        leftLable.text = @"总计";
        leftLable.textColor = [UIColor blackColor];
        leftLable.textAlignment = NSTextAlignmentLeft;
        leftLable.font = [UIFont systemFontOfSize:15];
        [view addSubview:leftLable];
        [leftLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(rightButton.mas_centerY);
             make.left.mas_equalTo(@10);
         }];

        
        UILabel *priceLable = [[UILabel alloc]init];
        priceLable.tag = 1;
        priceLable.text = @"100";
        priceLable.textColor = [UIColor redColor];
        priceLable.textAlignment = NSTextAlignmentLeft;
        priceLable.font = [UIFont systemFontOfSize:16];
        [view addSubview:priceLable];
        [priceLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(leftLable.mas_centerY);
             make.left.equalTo(leftLable.mas_right).with.offset(5);
         }];

        
        UILabel *unitLable = [[UILabel alloc]init];
        unitLable.tag = 3;
        unitLable.text = @"元";
        unitLable.textColor = [UIColor blackColor];
        unitLable.textAlignment = NSTextAlignmentLeft;
        unitLable.font = [UIFont systemFontOfSize:15];
        [view addSubview:unitLable];
        [unitLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(priceLable.mas_centerY);
             make.left.equalTo(priceLable.mas_right).with.offset(1);
         }];

        UILabel *feeLable = [[UILabel alloc]init];
        feeLable.tag = 2;
        feeLable.text = @"(手续费: 24元)";
        feeLable.textColor = [UIColor blackColor];
        feeLable.textAlignment = NSTextAlignmentLeft;
        feeLable.font = [UIFont systemFontOfSize:13];
        [view addSubview:feeLable];
        [feeLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(unitLable.mas_centerY);
             make.left.equalTo(unitLable.mas_right).with.offset(3);
         }];

        
        _bottomView = view;
    }

    return _bottomView;
}

#pragma mark - Public Method

- (void)setIsBuyUp:(BOOL)isBuyUp
{
    _isBuyUp = isBuyUp;
    
    UIButton *buyUpButton = [self.contentView viewWithTag:20];
    UIButton *buyDownButton = [self.contentView viewWithTag:30];
    if (isBuyUp)
    {
        buyUpButton.selected = YES;
        buyDownButton.selected = NO;
    }
    else
    {
        buyUpButton.selected = NO;
        buyDownButton.selected = YES;
    }
    [self setBuyUPButtonSelectStateButton:buyUpButton];
    [self setBuyUPButtonSelectStateButton:buyDownButton];
    
}

- (void)setBalanceOfAccountString:(NSString *)balanceOfAccountString
{
    _balanceOfAccountString = balanceOfAccountString;
    
    UILabel *topLable = [self.contentView viewWithTag:1];
    topLable.text = [NSString stringWithFormat:@"余额：%@元",balanceOfAccountString];
}

- (void)setCouponNumberString:(NSString *)couponNumberString
{
    _couponNumberString = couponNumberString;
    
    UILabel *couponLable = [self.slideCountView viewWithTag:7];
    couponLable.text = [NSString stringWithFormat:@"使用体验券(当前可用%@张)",couponNumberString];
    UIButton *couponButton = [self.slideCountView viewWithTag:9];

    if ([couponNumberString isEqualToString:@"0"])
    {
        UIImageView *couponImageView = [self.slideCountView viewWithTag:8];
        couponImageView.highlighted = NO;
        
        couponButton.selected = NO;
        couponButton.enabled = NO;
        
        _isUseCoupon = NO;
    }
    else
    {
        couponButton.enabled = YES;
    }
    
    
    
}


- (void)updateBuyUpOrDownProductInfo:(NSArray<NSDictionary *> *)array{
    array = array.firstObject;
    if ( ! (array && [array isKindOfClass:[NSArray class]] && array.count >= 2 ) ){
        return;
    }
    
    //从小到大排序
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2){
        if ([obj1[@"price"] floatValue] >= [obj2[@"price"] floatValue]){
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    
    
    
    _productListArray = array;
    
    {
        UILabel *topLable = [self.kindLeftView viewWithTag:1];
        UILabel *middleLable = [self.kindLeftView viewWithTag:2];
        UILabel *bottomLable = [self.kindLeftView viewWithTag:3];
        
        NSDictionary *dict = array.firstObject;
        NSString *name = dict[@"name"];
        NSString *weight = dict[@"weight"];
        NSString *spec = dict[@"spec"];
        NSString *price = dict[@"price"];
        NSString *unit = dict[@"unit"];

        topLable.text = [NSString stringWithFormat:@"%@ %@%@",name,weight,spec];
        middleLable.text = [NSString stringWithFormat:@"%@",price];
        bottomLable.text = [NSString stringWithFormat:@"%@",unit];
    }
    
    {
        NSDictionary *dict = array[1];
        UILabel *topLable = [self.kindMiddleView viewWithTag:1];
        UILabel *middleLable = [self.kindMiddleView viewWithTag:2];
        UILabel *bottomLable = [self.kindMiddleView viewWithTag:3];
        
        
        NSString *name = dict[@"name"];
        NSString *weight = dict[@"weight"];
        NSString *spec = dict[@"spec"];
        NSString *price = dict[@"price"];
        NSString *unit = dict[@"unit"];
        
        topLable.text = [NSString stringWithFormat:@"%@ %@%@",name,weight,spec];
        middleLable.text = [NSString stringWithFormat:@"%@",price];
        bottomLable.text = [NSString stringWithFormat:@"%@",unit];
    }

    {
        NSDictionary *dict = array[2];
        UILabel *topLable = [self.kindRightView viewWithTag:1];
        UILabel *middleLable = [self.kindRightView viewWithTag:2];
        UILabel *bottomLable = [self.kindRightView viewWithTag:3];
        
        NSString *name = dict[@"name"];
        NSString *weight = dict[@"weight"];
        NSString *spec = dict[@"spec"];
        NSString *price = dict[@"price"];
        NSString *unit = dict[@"unit"];
      
        topLable.text = [NSString stringWithFormat:@"%@ %@%@",name,weight,spec];
        middleLable.text = [NSString stringWithFormat:@"%@",price];
        bottomLable.text = [NSString stringWithFormat:@"%@",unit];
    }

    //更新底部信息
    [self updateBottomViewInfo];

}

// 出现
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    NSLog(@"keyWindow == %@",[UIApplication sharedApplication].keyWindow.subviews);
    
    
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.contentView.transform = CGAffineTransformMakeTranslation(0, - CGRectGetMaxY(self.bottomView.frame));
         self.coverButton.alpha = 0.3;
     }];
    
}

- (void)dismissPickerView
{
    [self dismissPickerViewWithNeedTip:NO Error:nil];
}

// 消失
- (void)dismissPickerViewWithNeedTip:(BOOL)isNeed Error:(NSError *)error
{
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetMaxY(self.bottomView.frame));
         self.coverButton.alpha = 0.0;
     } completion:^(BOOL finished)
     {
         
         [self removeFromSuperview];

         if (isNeed)
         {
             self.transactionResultTip(error);
         }
         
     }];
}



#pragma mark - UpDate UI Stste

- (void)setKindViewSelectState:(BOOL)isSelected SuperView:(UIView *)superView Index:(NSInteger)index
{
    if (isSelected)
    {
        _currentProductIndex = index;
        

        [self updateBottomViewInfo];
    }
    
    
    
    UILabel *topLable = [superView viewWithTag:1];
    UILabel *middleLable = [superView viewWithTag:2];
    UILabel *bottomLable = [superView viewWithTag:3];
    
    
    if (isSelected)
    {
        superView.backgroundColor = RGBA(240, 242, 245, 1);
        topLable.textColor = [UIColor blackColor];
        middleLable.textColor = [UIColor blackColor];
        bottomLable.textColor = [UIColor blackColor];
    }
    else
    {
        superView.backgroundColor = [UIColor whiteColor];
        topLable.textColor = TextColorGray;
        middleLable.textColor = TextColorGray;
        bottomLable.textColor = TextColorGray;
    }
}

- (void)setBuyUPButtonSelectStateButton:(UIButton *)sender
{
    if (sender.selected)
    {
        if (sender.tag == 20)
        {
            //买涨
            
            sender.layer.borderColor = RGBA(252, 71, 75, 1).CGColor;
            sender.backgroundColor = [UIColor decreaseColor];
            
            UIButton *orderButton = [self.bottomView viewWithTag:4];
            orderButton.backgroundColor = [UIColor decreaseColor];

        }
        else if (sender.tag == 30)
        {
            //买跌
            sender.layer.borderColor = RGBA(45, 176, 71, 1).CGColor;
            sender.backgroundColor = [UIColor increaseColor];
            
            UIButton *orderButton = [self.bottomView viewWithTag:4];
            orderButton.backgroundColor = [UIColor increaseColor];
        }
        
    }
    else
    {
        sender.backgroundColor = [UIColor whiteColor];
        sender.layer.borderColor = RGBA(237, 238, 240, 1).CGColor;
    }
}

#pragma mark - Button Click

- (void)couponButtonClick:(UIButton *)sender
{
    if ([_couponNumberString isEqualToString:@"0"])
    {
        return;
    }
    
    
    
    sender.selected = !sender.selected;
    UIImageView *couponImageView = [sender.superview viewWithTag:8];
    couponImageView.highlighted = sender.selected;
    _isUseCoupon = sender.selected;
    
    
    
    if (_isUseCoupon)
    {
        // 使用优惠券 假如买的数量大于1手 减值1手
        UISlider *slide = [self.slideCountView viewWithTag:4];
        if (slide.value > 1)
        {
            slide.value = 1;
            UILabel *topLable = [self.slideCountView viewWithTag:1];
            topLable.text = @"买几手：1手";
        }
    }
        
    [self updateBottomViewInfo];
}


- (void)pushRechargeViewControllerButtonClick
{
    [self dismissPickerView];
    
    
    //充值界面
    RechargeViewController *rechargeVC = [[RechargeViewController alloc]init];
    rechargeVC.hidesBottomBarWhenPushed = YES;
    rechargeVC.isBuyUp = _isBuyUp;
    [self.currentViewController.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)kindLeftViewButtonClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    
    [self setKindViewSelectState:YES SuperView:sender.superview Index:index - 1];
    switch (index)
    {
        case 1:
        {
            [self setKindViewSelectState:NO SuperView:self.kindMiddleView Index:1];
            [self setKindViewSelectState:NO SuperView:self.kindRightView Index:2];
        }
            break;
        case 2:
        {
            [self setKindViewSelectState:NO SuperView:self.kindLeftView Index:0];
            [self setKindViewSelectState:NO SuperView:self.kindRightView Index:2];

        }
            break;
        case 3:
        {
            [self setKindViewSelectState:NO SuperView:self.kindLeftView Index:0];
            [self setKindViewSelectState:NO SuperView:self.kindMiddleView Index:1];
        }
            break;
        default:
            break;
    }

}

- (void)chooseBuyUpOrDownButtonClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    sender.selected = YES;
    [self setBuyUPButtonSelectStateButton:sender];
    
    if (index == 20)
    {
        //买涨
        UIButton *button = [_contentView viewWithTag:30];
        button.selected = NO;
        [self setBuyUPButtonSelectStateButton:button];
    }
    else if (index == 30)
    {
        //买跌

        UIButton *button = [_contentView viewWithTag:20];
        button.selected = NO;
        [self setBuyUPButtonSelectStateButton:button];
    }
}

- (void)slideValueChangeClick:(UISlider *)slide
{
    UILabel *topLable = [slide.superview viewWithTag:1];
    
    NSLog(@"slide.value ====== %f",slide.value);
    
    
    NSString *string = [topLable.text componentsSeparatedByString:@"："].firstObject;
    int value = ceil(slide.value);
    if (slide.superview.tag == 101)
    {
        
        if (slide.value > 1 && _isUseCoupon)
        {
            // 优惠券 可买 1 手
            slide.value = 1;
            [ErrorTipView errorTip:@"使用优惠券只能买1手" SuperView:self];
            return;
        }
        
        topLable.text = [NSString stringWithFormat:@"%@：%d手",string,value];
        
        {
            UILabel *priceLable = [self.bottomView viewWithTag:1];
            
            if (_isUseCoupon == NO)
            {
                
                NSDictionary *dict =  _productListArray[_currentProductIndex];
                NSString *feeString = dict[@"fee"];
                float price = [dict[@"price"] floatValue];
                
                price = price * value;
                price = price + [feeString floatValue];
                if (value == 0)
                {
                    price = 0;
                }
                priceLable.text = [NSString stringWithFormat:@"%.1f",price];
            }
            else
            {
                priceLable.text = [NSString stringWithFormat:@"%d",value];
            }
            
        }

    }
    else
    {
        value = value * 10;
        if (value == 0)
        {
            topLable.text = [NSString stringWithFormat:@"%@：不限",string];
            [self updateBottomViewInfo];
        }
        else
        {
           topLable.text = [NSString stringWithFormat:@"%@：%d点",string,value];
        }
    }
}

- (void)changeSlideValueButtonClick:(UIButton *)sender
{
    UISlider *slide = [sender.superview viewWithTag:4];
    UILabel *topLable = [sender.superview viewWithTag:1];

    if (sender.tag == 5)
    {
        slide.value = slide.value - 1;
    }
    else if (sender.tag == 6)
    {
        slide.value = slide.value + 1;

        if (slide.superview.tag == 101 && slide.value > 1 && _isUseCoupon)
        {
            // 优惠券 可买 1 手
            slide.value = slide.value - 1;
            [ErrorTipView errorTip:@"使用优惠券只能买1手" SuperView:self];
            return;
        }
        
    }
    
    NSString *string = [topLable.text componentsSeparatedByString:@"："].firstObject;
    int value = ceil(slide.value);
    
    if (slide.superview.tag == 101){
        topLable.text = [NSString stringWithFormat:@"%@：%d手",string,value];
        [self updateBottomViewInfo];
    }else{
        value = value * 10;
        if (value == 0){
            topLable.text = [NSString stringWithFormat:@"%@：不限",string];
        }else{
            topLable.text = [NSString stringWithFormat:@"%@：%d点",string,value];
        }
    }
}

/* 下单 */
- (void)placeAnOrderButtonClick:(UIButton *)sender{
    UISlider *slide = [self.slideCountView viewWithTag:4];
    if (slide.value < 1)
    {
        [ErrorTipView errorTip:@"请至少选择1手购买" SuperView:self];
        return;
    }
    UILabel *priceLable = [self.bottomView viewWithTag:1];
    if ([priceLable.text floatValue] > [self.balanceOfAccountString floatValue] && _isUseCoupon == NO)
    {
        [ErrorTipView errorTip:@"账户余额不足" SuperView:self];
        return;
    }
    
    
    if ([self.couponNumberString intValue] < (int)slide.value && _isUseCoupon == YES)
    {
        [ErrorTipView errorTip:@"可用代金券数量不足" SuperView:self];
        return;
    }
    
    
    UISlider *topSlide = [self.slideLossView viewWithTag:4];
    UISlider *bottomSlide = [self.slideGainView viewWithTag:4];
    float topLimit = ((int)topSlide.value ) / 10.0;
    float bottomLimit = ((int)bottomSlide.value ) / 10.0;

    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *productInfoDict = _productListArray[_currentProductIndex];
    
    
    NSLog(@"productInfoDict ===== %@",productInfoDict);
    
    NSString *couponId = [NSString stringWithFormat:@"%@",productInfoDict[@"productId"]];
    NSString *contract = [NSString stringWithFormat:@"%@",productInfoDict[@"contract"]];

    NSString *buyUpStr = @"2";
    if (self.isBuyUp == NO)
    {
        buyUpStr = @"1";
    }
    NSString *numStr = [NSString stringWithFormat:@"%d",(int)slide.value];
    NSString *topStr = [NSString stringWithFormat:@"%.2f",topLimit];
    NSString *bottomStr = [NSString stringWithFormat:@"%.2f",bottomLimit];
    NSString *isUseCoupon = @"0";
    if (_isUseCoupon)
    {
        isUseCoupon = @"1";
    }
    
    
    NSDictionary *dict = @{@"mobile_phone":account.phone,
                           @"product_id":couponId,
                           @"contract":contract,
                           @"type":buyUpStr,
                           @"sl":numStr,
                           @"is_juan":isUseCoupon,
                           @"top_limit":topStr,
                           @"bottom_limit":bottomStr};
//    建仓
    
//    [self dismissPickerViewWithNeedTip:YES Error:error];

//    [self.currentViewController.httpManager openPositionWithParameterDict:dict CompletionBlock:^(NSDictionary *resultDict, NSError *error)
//     {
//    }];
}

- (void)updateBottomViewInfo
{
    if (_productListArray)
    {
        
        UILabel *priceLable = [self.bottomView viewWithTag:1];
        UILabel *feeLable = [self.bottomView viewWithTag:2];
        UILabel *unitLable = [self.bottomView viewWithTag:3];
        
        UISlider *slide = [self.slideCountView viewWithTag:4];
        int value = ceil(slide.value);//多少手
        
        if (_isUseCoupon == NO)
        {
            NSDictionary *dict =  _productListArray[_currentProductIndex];
            NSString *feeString = dict[@"fee"];
            float price = [dict[@"price"] floatValue];
            
            feeLable.text = [NSString stringWithFormat:@"(手续费: %@元)",feeString];
            
            unitLable.text = @"元";
            price = price * value;
            price = price + [feeString floatValue];
            if (value == 0)
            {
                price = 0;
            }
            priceLable.text = [NSString stringWithFormat:@"%.1f",price];
        }
        else
        {
            feeLable.text = [NSString stringWithFormat:@"(手续费: 0元)"];
            priceLable.text = [NSString stringWithFormat:@"%d",value];
            
            unitLable.text = @"张代金券";

        }
    }
}



@end
