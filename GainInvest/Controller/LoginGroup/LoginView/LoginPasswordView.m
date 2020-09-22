//
//  LoginPasswordView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/8.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "LoginPasswordView.h"

#import "ValidateClass.h"

#import <Masonry.h>

@interface LoginPasswordView ()

@property (nonatomic ,strong) UIView *phoneView;
@property (nonatomic ,strong) UIView *passwordView;

@property (nonatomic ,strong) UIButton *showPwdButton;

@end


@implementation LoginPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.phoneView];
        [self addSubview:self.passwordView];
        
        __weak __typeof__(self) weakSelf = self;
        
        [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
        
        
        [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.phoneView.mas_bottom).with.offset(1);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.height.equalTo(weakSelf.phoneView.mas_height);
         }];
        
        
    }
    
    return self;
}

- (UIView *)phoneView
{
    if (_phoneView == nil)
    {
        _phoneView = [[UIView alloc]init];
        _phoneView.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_Phone"]];
        [_phoneView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(_phoneView);
             make.left.mas_equalTo(@18);
             make.width.mas_equalTo(@16);
             make.height.mas_equalTo(imageView.mas_width).multipliedBy(158/110.0);// 高/宽 == 0.6
         }];
        
        
        [_phoneView addSubview:self.phoneTf];
        
        [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.equalTo(imageView.mas_right).with.offset(8);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
         }];
        
    }
    
    return _phoneView;
}

- (UIView *)passwordView
{
    if (_passwordView == nil)
    {
        _passwordView = [[UIView alloc]init];
        _passwordView.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_Password"]];
        [_passwordView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(_passwordView);
             make.left.mas_equalTo(@18);
             make.width.mas_equalTo(@16);
             make.height.mas_equalTo(imageView.mas_width).multipliedBy(158/110.0);// 高/宽 == 0.6
         }];
        
        
        
        [_passwordView addSubview:self.showPwdButton];
        [self.showPwdButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.width.mas_equalTo(@60);
         }];
        
        
        [_passwordView addSubview:self.passwordTf];
        
        [self.passwordTf mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.equalTo(imageView.mas_right).with.offset(8);
             make.right.mas_equalTo(@-65);
             make.bottom.mas_equalTo(@0);
         }];
        
        
    }
    
    return _passwordView;
}

- (UITextField *)phoneTf
{
    if (_phoneTf == nil)
    {
        _phoneTf = [[UITextField alloc]init];
        _phoneTf.borderStyle = UITextBorderStyleNone;
        _phoneTf.placeholder = @"请输入手机号";
        _phoneTf.font = [UIFont systemFontOfSize:14];
        _phoneTf.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return _phoneTf;
}

- (UITextField *)passwordTf
{
    if (_passwordTf == nil)
    {
        _passwordTf = [[UITextField alloc]init];
        _passwordTf.borderStyle = UITextBorderStyleNone;
        _passwordTf.placeholder = @"请输入密码";
        _passwordTf.font = [UIFont systemFontOfSize:14];
        
        _passwordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTf.secureTextEntry = YES;
    }
    
    return _passwordTf;
    
}

- (UIButton *)showPwdButton
{
    if (_showPwdButton == nil)
    {
        _showPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showPwdButton.adjustsImageWhenHighlighted = NO;
        _showPwdButton.adjustsImageWhenDisabled = NO;
        _showPwdButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        [_showPwdButton setImage:[UIImage imageNamed:@"login_ShowPwd"] forState:UIControlStateSelected];
        [_showPwdButton setImage:[UIImage imageNamed:@"login_ShowPwdNo"] forState:UIControlStateNormal];
        [_showPwdButton addTarget:self action:@selector(showPwdButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _showPwdButton;
}

- (void)showPwdButtonClick
{
    _passwordTf.secureTextEntry = !_passwordTf.secureTextEntry;
    
    if (_passwordTf.isSecureTextEntry)
    {
        _showPwdButton.selected = NO;
    }
    else
    {
        _showPwdButton.selected = YES;
    }
}

@end
