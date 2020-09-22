//
//  RechargeMethodVerifyView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/2.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define AnimationDuration 0.2
#define OriginalScale 0.9


#import "RechargeMethodVerifyView.h"

#import <Masonry.h>


@interface RechargeMethodVerifyView()

{
    NSString *_verificationCodeString;
}

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic ,strong) UIView *verCodeView;
@property (nonatomic ,strong) UITextField *verCodeTf;

@end

@implementation RechargeMethodVerifyView

- (instancetype)init
{
    self = [super init];
    
    
    if (self)
    {
        
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
        [button addTarget:self action:@selector(endTfEditing) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        _coverButton = button;
    }
    
    return _coverButton;
}

- (NSMutableAttributedString *)setAttributeText
{
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"我们已发送"];
    [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string1.length)];
    [string1 addAttribute:NSForegroundColorAttributeName value:TextColorGray range:NSMakeRange(0, string1.length)];
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"短信验证码"];
    [string2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string2.length)];
    [string2 addAttribute:NSForegroundColorAttributeName value:TextColorBlack range:NSMakeRange(0, string2.length)];
    
    
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"到这个号码"];
    [string3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string3.length)];
    [string3 addAttribute:NSForegroundColorAttributeName value:TextColorGray range:NSMakeRange(0, string3.length)];

    [string2 appendAttributedString:string3];
    [string1 appendAttributedString:string2];
    return string1;
}

- (UIView *)contentView
{
    if (_contentView == nil)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.userInteractionEnabled = YES;
        view.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTfEditing)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [view addGestureRecognizer:tapGesture];
        
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 5;
        backView.clipsToBounds = YES;
        [view addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@20);
             make.left.mas_equalTo(@20);
             make.bottom.mas_equalTo(@-20);
             make.right.mas_equalTo(@-20);
         }];
        

        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setImage:[UIImage imageNamed:@"RechargeMethod_Cancel"] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor clearColor];
        [view addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.width.mas_equalTo(@40);
             make.height.mas_equalTo(@40);
         }];
        
        UILabel *tipLable = [[UILabel alloc]init];
        tipLable.attributedText = [self setAttributeText];
        tipLable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:tipLable];
        CGFloat textWidth = [@"我们已发送验证码短信到这个号码" boundingRectWithSize:CGSizeMake(300, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : tipLable.font} context:nil].size.width;
        
        [tipLable mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.mas_equalTo(@40);
            make.left.mas_equalTo(@0);
            make.right.mas_equalTo(@0);
        }];
        
        NSString *phone = [AccountInfo standardAccountInfo].username;
        
        UILabel *phoneLable = [[UILabel alloc]init];
        phoneLable.text = phone;
        phoneLable.font = [UIFont systemFontOfSize:14];
        phoneLable.textColor = TextColorGray;
        phoneLable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:phoneLable];
        [phoneLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(tipLable.mas_bottom).with.offset(5);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];

        
        [view addSubview:self.verCodeView];
        [self.verCodeView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.center.equalTo(view);
             make.width.mas_equalTo(@(textWidth));
             make.height.mas_equalTo(@40);
         }];

       
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = UIColorFromRGB(0x576fe3, 1);
        [button setTitle:@"确认验证码" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColorFromRGB(0x576fe3, 1).CGColor;
        button.tag = 1;
        button.frame = CGRectMake( 15, ScreenHeight - 64 - 100 , ScreenWidth - 30, 45);
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_verCodeView.mas_bottom).with.offset(20);
             make.width.mas_equalTo(@(textWidth));
             make.height.mas_equalTo(@40);
             make.centerX.equalTo(view.mas_centerX);
         }];

        
        view.frame = CGRectMake(0, 0, textWidth + 100, 240);
        view.center = self.center;
        view.alpha = 0;
        view.transform = CGAffineTransformMakeScale( OriginalScale,  OriginalScale);
        _contentView = view;
    }
    
    return _contentView;
}

- (UIView *)verCodeView
{
    if (_verCodeView == nil)
    {
        UIView *verCodeView = [[UIView alloc]init];
        verCodeView.backgroundColor = RGBA(242, 242, 242, 1);
        verCodeView.layer.cornerRadius = 5;
        verCodeView.layer.borderWidth = 1;
        verCodeView.layer.borderColor = RGBA(149, 149, 149, 1).CGColor;
        verCodeView.clipsToBounds = YES;

        

        [verCodeView addSubview:self.verCodeTf];
        [_verCodeTf mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@5);
             make.bottom.mas_equalTo(@0);
         }];
        
        [verCodeView addSubview:self.timeLable];
        [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.equalTo(_verCodeTf.mas_right).with.offset(0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.width.mas_equalTo(@40);
         }];
        
        _verCodeView = verCodeView;

    }
    
    return _verCodeView;
}

- (UITextField *)verCodeTf
{
    if (_verCodeTf == nil)
    {
        UITextField *verCodeTf = [[UITextField alloc]init];
        verCodeTf.tag = 6;
        verCodeTf.borderStyle = UITextBorderStyleNone;
        verCodeTf.placeholder = @"输入验证码";
        verCodeTf.textColor = TextColorBlack;
        verCodeTf.font = [UIFont systemFontOfSize:14];
        verCodeTf.keyboardType = UIKeyboardTypeNumberPad;
        _verCodeTf = verCodeTf;
    }
    
    return _verCodeTf;
}

- (UILabel *)timeLable
{
    if (_timeLable == nil)
    {
        UILabel *timeLable = [[UILabel alloc]init];
        timeLable.backgroundColor = RGBA(187, 187, 187, 1);
        timeLable.text = @"52S";
        timeLable.clipsToBounds = YES;
        timeLable.layer.cornerRadius = 5;
        timeLable.font = [UIFont systemFontOfSize:14];
        timeLable.textColor = TextColorGray;
        timeLable.textAlignment = NSTextAlignmentCenter;

        _timeLable = timeLable;
    }
    
    return _timeLable;
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
    [_verCodeTf resignFirstResponder];
    
    self.rechargeMethodVerifyDismiss();
    
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
    [_verCodeTf resignFirstResponder];

    if (_verCodeTf.text.length <= 0)
    {
        [ErrorTipView errorTip:@"验证码不能为空" SuperView:self];
    }
    else
    {
        self.rechargeMethodVerifyCode(_verCodeTf.text);
        [self dismissPickerView];
    }
}

- (void)endTfEditing
{
    [self.verCodeTf resignFirstResponder];
}


@end
