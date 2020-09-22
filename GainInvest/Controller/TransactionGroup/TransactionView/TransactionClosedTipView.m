//
//  TransactionClosedTipView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/20.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define AnimationDuration 0.2
#define OriginalScale 0.9


#import "TransactionClosedTipView.h"
#import <Masonry.h>


@interface TransactionClosedTipView()

{
    CGFloat _contentWeight;
}

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation TransactionClosedTipView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _contentWeight = ScreenWidth - 60;
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
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
        //[button addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        _coverButton = button;
    }
    
    return _coverButton;
}


- (UIView *)contentView
{
    if (_contentView == nil)
    {
        CGFloat height =  _contentWeight / 234.0 * 160.0;

        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        view.frame = CGRectMake(30, 0, ScreenWidth - 60 ,  height);
        view.center = self.center;
        
        
        // 225 ：135
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, _contentWeight, 20)];
        lable.text = @"已休市";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor blackColor];
        lable.font = [UIFont systemFontOfSize:17];
        [view addSubview:lable];
        
        
        UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tipButton setTitle:@"当前为休市时间" forState:UIControlStateNormal];
        [tipButton setTitleColor:TextColorGray forState:UIControlStateNormal];
        tipButton.titleLabel.font = [UIFont systemFontOfSize:13];
        tipButton.titleLabel.numberOfLines = 0;
        tipButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        tipButton.frame = CGRectMake( 15,50, _contentWeight - 30, height - 50 - 45);
        [view addSubview:tipButton];
        
        
        CGFloat y = height - 45;
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"知道了" forState:UIControlStateNormal];
        [cancelButton setTitleColor:TextColorGray forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelButton.backgroundColor = TableGrayColor;
        cancelButton.frame = CGRectMake( 0,y, _contentWeight / 2.0 - 0.5, 45);
        [view addSubview:cancelButton];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"了解更多" forState:UIControlStateNormal];
        button.backgroundColor = TableGrayColor;
        [button setTitleColor:TextColorBlue forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 1;
        button.frame = CGRectMake(_contentWeight / 2.0 + 0.5,y , _contentWeight / 2.0, 45);
        [view addSubview:button];
            

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
    self.closedTipConfirmButtonClick();
    [self dismissPickerView];
}

- (void)cancelButtonClick
{
    [self dismissPickerView];
}


#pragma mark - Draw


@end
