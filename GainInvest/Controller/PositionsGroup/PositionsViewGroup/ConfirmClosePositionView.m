//
//  ConfirmClosePositionView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/13.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define AnimationDuration 0.2
#define OriginalScale 0.9


#import "ConfirmClosePositionView.h"
#import <Masonry.h>


@interface ConfirmClosePositionView()

{
    CGFloat _contentWeight;
}

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation ConfirmClosePositionView

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
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        CGFloat height =  _contentWeight / 234.0 * 130;
        
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _contentWeight, height - 65)];
        lable.text = @"确认平仓";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor blackColor];
        lable.font = [UIFont systemFontOfSize:17];
        [view addSubview:lable];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:TextColorGray forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelButton.layer.cornerRadius = 5;
        cancelButton.clipsToBounds = YES;
        cancelButton.layer.borderWidth = 1;
        cancelButton.layer.borderColor = TextColorGray.CGColor;
        cancelButton.backgroundColor = RGBA(220, 220, 220, 1);
        cancelButton.frame = CGRectMake( 10, CGRectGetMaxY(lable.frame) + 10, (_contentWeight - 30) / 2.0, 45);
        [view addSubview:cancelButton];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = UIColorFromRGB(0x576fe3, 1);
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColorFromRGB(0x576fe3, 1).CGColor;
        button.tag = 1;
        button.frame = CGRectMake( CGRectGetMaxX(cancelButton.frame) + 10, CGRectGetMaxY(lable.frame) + 10 , (_contentWeight - 30) / 2.0, 45);
        [view addSubview:button];
        
        
        view.frame = CGRectMake(30, 0, ScreenWidth - 60 ,  CGRectGetMaxY(button.frame) + 10 );
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
    self.confirmClosePosition();
    [self dismissPickerView];
}



@end
