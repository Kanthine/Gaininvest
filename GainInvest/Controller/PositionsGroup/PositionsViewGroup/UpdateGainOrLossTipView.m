//
//  UpdateGainOrLossTipView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/13.
//  Copyright © 2017年 苏沫离. All rights reserved.
//


#define AnimationDuration 0.2
#define OriginalScale 0.9


#import "UpdateGainOrLossTipView.h"
#import <Masonry.h>


@interface UpdateGainOrLossTipView()

{
    CGFloat _contentWeight;
    CGFloat _topLimit;
    CGFloat _bottomLimit;
}

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *slideGainView;
@property (nonatomic, strong) UIView *slideLossView;

@end

@implementation UpdateGainOrLossTipView

- (instancetype)initWithTopLimit:(CGFloat)topLimit BottomLimit:(CGFloat)bottomLimit
{
    self = [super init];
        
    if (self){
        _topLimit = topLimit * 10;
        _bottomLimit = bottomLimit * 10;
        _contentWeight = CGRectGetWidth(UIScreen.mainScreen.bounds) - 60;
        self.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds));
        
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
        button.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds));
        
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
        
        
        [view addSubview:self.slideGainView];
        [view addSubview:self.slideLossView];
        self.slideGainView.frame = CGRectMake(0,10, _contentWeight,50);
        self.slideLossView.frame = CGRectMake(0, CGRectGetMaxY(self.slideGainView.frame) + 10, _contentWeight,50);

        
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
        cancelButton.frame = CGRectMake( 10, CGRectGetMaxY(self.slideLossView.frame) + 10, (_contentWeight - 30) / 2.0, 45);
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
        button.frame = CGRectMake( CGRectGetMaxX(cancelButton.frame) + 10, CGRectGetMaxY(self.slideLossView.frame) + 10 , (_contentWeight - 30) / 2.0, 45);
        [view addSubview:button];
        
        
        view.frame = CGRectMake(30, 0, CGRectGetWidth(UIScreen.mainScreen.bounds) - 60 ,  CGRectGetMaxY(button.frame) + 10 );
        view.center = self.center;
        view.alpha = 0;
        view.transform = CGAffineTransformMakeScale( OriginalScale,  OriginalScale);
        _contentView = view;
        
        
        NSLog(@"[NSValue valueWithCGRect:view.frame] ==== %@",[NSValue valueWithCGRect:view.frame]);
    }
    
    return _contentView;
}


- (UIView *)slideGainView
{
    if (_slideGainView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        view.tag = 100;
        
        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _contentWeight, 16)];
        topLable.tag = 1;
        topLable.textColor = TextColorGray;
        topLable.textAlignment = NSTextAlignmentCenter;
        topLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:topLable];
        
        if (_bottomLimit > 0)
        {
            topLable.text = [NSString stringWithFormat:@"止损：%.0f点",_bottomLimit * 10];
        }
        else
        {
            topLable.text = @"止损：不限";
        }
        
        
        
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_BuyDown"]];
        leftImageView.frame = CGRectMake(10, CGRectGetMaxY(topLable.frame) + 5, 20, 20);
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:leftImageView];
        
        
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_BuyUp"]];
        rightImageView.frame = CGRectMake(_contentWeight - 30,CGRectGetMaxY(topLable.frame) + 5, 20, 20);
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
        
        
        UISlider *slide = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLable.frame), rightImageView.frame.origin.y , _contentWeight - 2 * CGRectGetMaxX(leftLable.frame), 30)];
        slide.tag = 4;
        slide.minimumValue = 0;
        slide.maximumValue = 5;
        [slide setValue:_bottomLimit animated:YES];
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
        rightButton.frame = CGRectMake(_contentWeight - CGRectGetWidth(leftButton.frame), leftButton.frame.origin.y, CGRectGetWidth(leftButton.frame), CGRectGetHeight(leftButton.frame));
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
        view.tag = 101;
        
        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _contentWeight, 16)];
        topLable.tag = 1;
        topLable.text = @"止盈：不限";
        topLable.textColor = TextColorGray;
        topLable.textAlignment = NSTextAlignmentCenter;
        topLable.font = [UIFont systemFontOfSize:14];
        [view addSubview:topLable];
        if (_topLimit > 0)
        {
            topLable.text = [NSString stringWithFormat:@"止盈：%.0f点",_topLimit * 10];
        }
        else
        {
            topLable.text = @"止盈：不限";
        }

        
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_BuyDown"]];
        leftImageView.frame = CGRectMake(10, CGRectGetMaxY(topLable.frame) + 5, 20, 20);
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:leftImageView];
        
        
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_BuyUp"]];
        rightImageView.frame = CGRectMake(_contentWeight - 30,CGRectGetMaxY(topLable.frame) + 5, 20, 20);
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
        
        
        UISlider *slide = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLable.frame), rightImageView.frame.origin.y , _contentWeight - 2 * CGRectGetMaxX(leftLable.frame), 30)];
        slide.tag = 4;
        slide.minimumValue = 0;
        slide.maximumValue = 5;
        [slide setValue:_topLimit animated:YES];
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
        rightButton.frame = CGRectMake(_contentWeight - CGRectGetWidth(leftButton.frame), leftButton.frame.origin.y, CGRectGetWidth(leftButton.frame), CGRectGetHeight(leftButton.frame));
        [view addSubview:rightButton];
        
        _slideLossView = view;
    }
    
    return _slideLossView;
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

- (void)confirmButtonClick{
    if (_topLimit < 10) {
        _topLimit = _topLimit * 10;
    }
    if (_bottomLimit < 10) {
        _bottomLimit = _bottomLimit * 10;
    }
    
    self.updateGainOrLossTipView(_topLimit,_bottomLimit);
    [self dismissPickerView];
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
    }
    
    NSString *string = [topLable.text componentsSeparatedByString:@"："].firstObject;
    int value = [[NSString stringWithFormat:@"%f",slide.value] intValue];
    value = value * 10;
    if (slide.superview.tag == 101)
    {
        topLable.text = [NSString stringWithFormat:@"%@：%d手",string,value];
    }
    else
    {
        if (value == 0)
        {
            topLable.text = [NSString stringWithFormat:@"%@：不限",string];
        }
        else
        {
            topLable.text = [NSString stringWithFormat:@"%@：%d点",string,value];
        }
    }
    
    if (sender.superview.tag == 100)
    {
        _bottomLimit = value;
    }
    else
    {
        _topLimit = value;
    }
}

- (void)slideValueChangeClick:(UISlider *)slide{
    UILabel *topLable = [slide.superview viewWithTag:1];
    
    NSString *string = [topLable.text componentsSeparatedByString:@"："].firstObject;
    int value = [[NSString stringWithFormat:@"%f",slide.value] intValue];
    value = value * 10;
    if (value == 0){
        topLable.text = [NSString stringWithFormat:@"%@：不限",string];
    }else{
        topLable.text = [NSString stringWithFormat:@"%@：%d点",string,value];
    }
    
    if (slide.superview.tag == 100){
        _bottomLimit = value;
    }else{
        _topLimit = value;
    }

}



@end
