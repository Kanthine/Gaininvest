//
//  LoginPhoneView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/8.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "LoginPhoneView.h"

#import "ValidateClass.h"

#import <Masonry.h>

@interface LoginPhoneView ()

{
    NSInteger _interval;
}
@property (nonatomic ,strong) UIView *phoneView;
@property (nonatomic ,strong) UIView *codeView;

@property (nonatomic ,strong) UIButton *codeButton;

@property (nonatomic ,strong) NSTimer *timer;

@end


@implementation LoginPhoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.phoneView];
        [self addSubview:self.codeView];
        
        __weak __typeof__(self) weakSelf = self;

        [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
        }];
        
        
        [self.codeView mas_makeConstraints:^(MASConstraintMaker *make)
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

- (UIView *)codeView
{
    if (_codeView == nil)
    {
        _codeView = [[UIView alloc]init];
        _codeView.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_Code"]];
        [_codeView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(_codeView);
             make.left.mas_equalTo(@18);
             make.width.mas_equalTo(@16);
             make.height.mas_equalTo(imageView.mas_width).multipliedBy(159/132.0);// 高/宽 == 0.6
         }];
        
        
        
        [_codeView addSubview:self.codeButton];
        [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@7);
             make.right.mas_equalTo(@-10);
             make.bottom.mas_equalTo(@-7);
             make.width.mas_equalTo(@100);
         }];

        
        [_codeView addSubview:self.codeTf];
        
        [self.codeTf mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.equalTo(imageView.mas_right).with.offset(8);
             make.right.mas_equalTo(@-115);
             make.bottom.mas_equalTo(@0);
         }];
        

    }
    
    return _codeView;
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

- (UITextField *)codeTf
{
    if (_codeTf == nil)
    {
        _codeTf = [[UITextField alloc]init];
        _codeTf.borderStyle = UITextBorderStyleNone;
        _codeTf.placeholder = @"请输入验证码";
        _codeTf.font = [UIFont systemFontOfSize:14];
        
        _codeTf.clearButtonMode = UITextFieldViewModeWhileEditing;

    }
    
    return _codeTf;

}

- (UIButton *)codeButton
{
    if (_codeButton == nil)
    {
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_codeButton setTitleColor:RGBA(72, 119, 230, 1) forState:UIControlStateNormal];
        [_codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _codeButton.layer.borderWidth = 1;
        _codeButton.layer.borderColor = RGBA(72, 119, 230, 1).CGColor;
        _codeButton.layer.cornerRadius = 5;
        _codeButton.clipsToBounds = YES;
        
        [_codeButton addTarget:self action:@selector(getVerificationCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _codeButton;
}

- (void)getVerificationCodeButtonClick
{
    if ([ValidateClass isMobile:_phoneTf.text])
    {
        if (_codeButton.enabled)
        {
            // -- > 发送短信请求
            [self timer];
            _codeButton.layer.borderColor = RGBA(149, 149, 149, 1).CGColor;
            [_codeButton setTitleColor:RGBA(149, 149, 149, 1) forState:UIControlStateNormal];
            
            self.loginPhoneGetVerificationCodeClick(YES);
            
            //不能连续点击
            _codeButton.enabled = NO;
        }
    }
    else
    {
        self.loginPhoneGetVerificationCodeClick(NO);
    }
    
    

}

- (NSTimer *)timer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendMessage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        _interval = 60;
    }
    return _timer;
}

- (void)sendMessage
{
    _interval --;
    NSString *title = [NSString stringWithFormat:@"重新发送(%02ld)",_interval];
    _codeButton.titleLabel.text = title;
    [_codeButton setTitle:title forState:UIControlStateDisabled];
    
    if (_interval == 0)
    {
        [_codeButton setTitleColor:RGBA(72, 119, 230, 1) forState:UIControlStateNormal];
        _codeButton.layer.borderColor = RGBA(72, 119, 230, 1).CGColor;
        [_codeButton setTitle:@"再次发送" forState:UIControlStateDisabled];
        _interval = 60;
        _codeButton.enabled = YES;
        [self.timer invalidate];
    }
}


@end
