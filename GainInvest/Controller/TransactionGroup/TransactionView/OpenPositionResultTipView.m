//
//  OpenPositionResultTipView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/30.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define AnimationDuration 0.2
#define OriginalScale 0.9


#import "OpenPositionResultTipView.h"
#import <Masonry.h>
#import "DrawSymbolView.h"


@interface OpenPositionResultTipView()

{
    CGFloat _contentWeight;

    NSError *_error;
}

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;
@property (nonatomic ,strong) DrawSymbolView *symbolView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation OpenPositionResultTipView

- (instancetype)initWithError:(NSError *)error
{
    
    self = [super init];
    
    if (self)
    {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _error = error;
        _contentWeight = ScreenWidth - 80;

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
        button.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        _coverButton = button;
    }
    
    return _coverButton;
}

- (DrawSymbolView *)symbolView
{
    if (_symbolView == nil)
    {
        _symbolView = [[DrawSymbolView alloc]init];
        _symbolView.backgroundColor = [UIColor whiteColor];
    }
    
    return _symbolView;
}

- (UIView *)contentView
{
    if (_contentView == nil)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        CGFloat height =  _contentWeight / 234.0 * 160.0;
        
        //
        
        
        CGFloat imageWidth = 60;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((_contentWeight - imageWidth) / 2.0, (height - (imageWidth + 30) - 45) /2.0 , 60, 60)];
//        [view addSubview:imageView];
        [view addSubview:self.symbolView];
        self.symbolView.frame = CGRectMake((_contentWeight - imageWidth) / 2.0, (height - (imageWidth + 30) - 45) /2.0 , 60, 60);
        
        
        UILabel *tipLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, _contentWeight, 20)];
        tipLable.textAlignment = NSTextAlignmentCenter;
        tipLable.textColor = [UIColor blackColor];
        tipLable.font = [UIFont systemFontOfSize:16];
        [view addSubview:tipLable];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"关闭" forState:UIControlStateNormal];
        [cancelButton setTitleColor:TextColorGray forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelButton.backgroundColor = RGBA(240, 242, 245, 1);
        cancelButton.frame = CGRectMake(0,height - 45 , _contentWeight/ 2.0 - 0.5, 45);
        [view addSubview:cancelButton];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = RGBA(240, 242, 245, 1);
        [button setTitleColor:TextColorBlue forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(_contentWeight/ 2.0 + 0.5,height - 45 , _contentWeight/ 2.0 - 0.5, 45);
        [view addSubview:button];
        
        
        
        
        if (_error)
        {
            imageView.image = [UIImage imageNamed:@"Transaction_Faled"];;
            [button setTitle:@"再次交易" forState:UIControlStateNormal];
            tipLable.text = _error.domain;
        }
        else
        {
            imageView.image = [UIImage imageNamed:@"Transaction_Succeed"];;
            [button setTitle:@"查看持仓" forState:UIControlStateNormal];
            tipLable.text = @"建仓成功";
        }
        
        
        
        view.frame = CGRectMake( (ScreenWidth - _contentWeight) / 2.0, 0, _contentWeight,  height);
        view.center = self.center;
        view.alpha = 0;
        view.transform = CGAffineTransformMakeScale( OriginalScale,  OriginalScale);
        _contentView = view;
    }
    
    return _contentView;
}

// 出现
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    if (_error)
    {
        [self.symbolView showInType:SymbolTypeFailed];
    }
    else
    {
        [self.symbolView showInType:SymbolTypeSuccess];
    }
    
    
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.contentView.transform = CGAffineTransformMakeScale(1, 1);
         self.contentView.alpha = 1.0;
         self.coverButton.alpha = 0.3;
     }];
}

// 消失
- (void)dismissPickerView
{
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.contentView.transform = CGAffineTransformMakeScale(OriginalScale, OriginalScale);
         self.contentView.alpha = 0.0;
         self.coverButton.alpha = 0.0;
     } completion:^(BOOL finished)
     {
         [self.contentView removeFromSuperview];
         [self.coverButton removeFromSuperview];
         [self removeFromSuperview];
     }];
}

- (void)confirmButtonClick
{
    [self dismissPickerView];
    
    if (_error)
    {
        self.openPositionLookAgainBuyClick();
    }
    else
    {
        self.openPositionLookPositionClick();
    }
}


@end

