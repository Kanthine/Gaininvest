//
//  ActivateTradePwdView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/13.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define AnimationDuration 0.2
#define OriginalScale 0.9


#import "ActivateTradePwdView.h"
#import <Masonry.h>


@interface ActivateTradePwdView()

{
    CGFloat _contentWeight;
}

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation ActivateTradePwdView

- (instancetype)initWithState:(ActivateTradePwdState)viewState
{
    self = [super init];
    
    if (self)
    {
        _viewState = viewState;
        
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
//        [button addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        _coverButton = button;
    }
    
    return _coverButton;
}

- (NSMutableAttributedString *)setAttributeText
{
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"还没有设置交易密码？现在去"];
    [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string1.length)];
    [string1 addAttribute:NSForegroundColorAttributeName value:TextColorGray range:NSMakeRange(0, string1.length)];
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"设置"];
    [string2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string2.length)];
    [string2 addAttribute:NSForegroundColorAttributeName value:TextColorBlue range:NSMakeRange(0, string2.length)];
    
    [string1 appendAttributedString:string2];
    return string1;
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
        height = _contentWeight * 0.5;

        CGFloat y = height - 45;
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:TextColorGray forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelButton.backgroundColor = TableGrayColor;
        cancelButton.frame = CGRectMake( 0,y, _contentWeight / 2.0 - 0.5, 45);
        [view addSubview:cancelButton];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = TableGrayColor;
        [button setTitleColor:TextColorBlue forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 1;
        button.frame = CGRectMake(_contentWeight / 2.0 + 0.5,y , _contentWeight / 2.0, 45);
        [view addSubview:button];
        
        
        if (_viewState == ActivateTradePwdStateActivateTrade)
        {
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, _contentWeight, 20)];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor blackColor];
            lable.font = [UIFont systemFontOfSize:17];
            lable.text = @"请输入交易密码";
            [view addSubview:lable];
            
            
            UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 35 + (height - 45 - 35 - 40) / 2.0, _contentWeight, 40)];
            lable1.text = @"为了保障您的资金安全\n交易大厅2小时自动注销";
            lable1.textAlignment = NSTextAlignmentCenter;
            lable1.textColor = TextColorGray;
            lable1.numberOfLines = 0;
            lable1.font = [UIFont systemFontOfSize:14];
            [view addSubview:lable1];
            
            
            [button setTitle:@"重新输入" forState:UIControlStateNormal];
            
        }
        else if (_viewState == ActivateTradePwdStateRemoteLogin)
        {
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, _contentWeight, 20)];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor blackColor];
            lable.font = [UIFont systemFontOfSize:17];
            lable.text = @"退出通知";
            [view addSubview:lable];
            
            UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 35 + (height - 45 - 35 - 40) / 2.0, _contentWeight, 40)];
            lable1.text = @"您的账号已在别的设备登录，如果\n您需要在这台设备使用，请重新登录";
            lable1.textAlignment = NSTextAlignmentCenter;
            lable1.textColor = TextColorGray;
            lable1.numberOfLines = 0;
            lable1.font = [UIFont systemFontOfSize:14];
            [view addSubview:lable1];
                        
            
            [cancelButton setTitle:@"退出" forState:UIControlStateNormal];
            [button setTitle:@"重新登录" forState:UIControlStateNormal];
        }
        else
        {
            
            UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0,(height - 45 - 40) / 2.0, _contentWeight, 40)];
            lable1.text = @"您暂时没有开通该交易品的交\n易权限，开户后即可进行交易";
            lable1.numberOfLines = 0;
            lable1.textAlignment = NSTextAlignmentCenter;
            lable1.textColor = [UIColor blackColor];
            lable1.font = [UIFont systemFontOfSize:15];
            [view addSubview:lable1];
            
            [button setTitle:@"去开户" forState:UIControlStateNormal];
        }
        


        
        view.frame = CGRectMake(30, 0, ScreenWidth - 60 ,  height);
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
    self.activateTradePwdViewConfirmButtonClick();
    [self dismissPickerView];
}

- (void)cancelButtonClick
{
    self.activateTradePwdViewCancelButtonClick();
    [self dismissPickerView];
}


@end
