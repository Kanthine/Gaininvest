//
//  RegisterViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/8.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "RegisterViewController.h"
#import "ValidateClass.h"

#import "SetTransactionPasswordVC.h"
#import "MyVoucherViewController.h"
#import "MainTabBarController.h"

@interface RegisterViewController ()

{
    BOOL _isRegister;
    NSInteger _interval;
    NSString *_verificationCodeString;
    
    __weak IBOutlet UIButton *_codeButton;
    __weak IBOutlet UITextField *_phoneTf;
    __weak IBOutlet UITextField *_passwordTf;
    __weak IBOutlet UITextField *_codeTf;
    __weak IBOutlet UIButton *_confirmButton;
}

@property (nonatomic ,strong) NSTimer *timer;

@end

@implementation RegisterViewController

- (instancetype)initWithIsRegister:(BOOL)isRegister
{
    self = [super initWithNibName:@"RegisterViewController" bundle:nil];
    
    if (self)
    {
        _isRegister = isRegister;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavBar];
    
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.clipsToBounds = YES;
    if (_isRegister)
    {
        [_confirmButton setTitle:@"注册并登陆" forState:UIControlStateNormal];
    }
    else
    {
        [_confirmButton setTitle:@"验证并重置密码" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)customNavBar
{
    
    if (_isRegister)
    {
        self.navigationItem.title = @"注册";
    }
    else
    {
        self.navigationItem.title = @"忘记密码";
    }
    
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    [self textFiledResignFirstResponder];

    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)passwordSectoryButtonClick:(UIButton *)sender
{
    
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        _passwordTf.secureTextEntry = NO;
    }
    else
    {
        _passwordTf.secureTextEntry = YES;
    }
}

- (IBAction)getCodeButtonClick:(UIButton *)sender
{
    //点击获取验证码
    [self textFiledResignFirstResponder];

    if ([ValidateClass isMobile:_phoneTf.text])
    {
        if (sender.enabled)
        {
            // -- > 发送短信请求
            [self timer];
            [sender setTitleColor:RGBA(149, 149, 149, 1) forState:UIControlStateNormal];
            _verificationCodeString = @"123456";
            //不能连续点击
            sender.enabled = NO;
        }
    }
    else
    {
        //手机号有问题，提示
        if (_phoneTf.text.length == 0)
        {
            [ErrorTipView errorTip:@"请您输入手机号" SuperView:self.view];
        }
        else
        {
            [ErrorTipView errorTip:@"手机号格式有误" SuperView:self.view];
        }
    }
}


- (IBAction)weChatLoginButtonClick:(UIButton *)sender
{
    AccountInfo.standardAccountInfo.head = @"";
    AccountInfo.standardAccountInfo.nickname = @"微信登录";
    [AccountInfo.standardAccountInfo storeAccountInfo];
    
    //提示 送代金券
    [RegisterViewController registerSuccessSendCouponTip];
    
    //存储数据
    [ErrorTipView errorTip:@"登录成功" SuperView:nil];
    //登录成功，进入主界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)qqLoginButtonClick:(UIButton *)sender
{
    AccountInfo.standardAccountInfo.head = @"";
    AccountInfo.standardAccountInfo.nickname = @"QQ登录";
    [AccountInfo.standardAccountInfo storeAccountInfo];
    
    //提示 送代金券
    [RegisterViewController registerSuccessSendCouponTip];
    
    //存储数据
    [ErrorTipView errorTip:@"登录成功" SuperView:nil];
    //登录成功，进入主界面
    [self dismissViewControllerAnimated:YES completion:nil];
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
        [self stopTimer];
    }
}

- (void)stopTimer
{
    [_codeButton setTitleColor:RGBA(72, 119, 230, 1) forState:UIControlStateNormal];
    _codeButton.layer.borderColor = RGBA(72, 119, 230, 1).CGColor;
    [_codeButton setTitle:@"再次发送" forState:UIControlStateNormal];
    _interval = 60;
    _codeButton.enabled = YES;
    [_timer invalidate];
    _timer = nil;
}

- (IBAction)confirmRegisterButtonClick:(UIButton *)sender{
    [self textFiledResignFirstResponder];
    
    if ([self isLeagle] == NO){
        return;
    }
    
    if (_isRegister){//注册
        AccountInfo.standardAccountInfo.phone = _phoneTf.text;
        AccountInfo.standardAccountInfo.password = _passwordTf.text;
        [AccountInfo.standardAccountInfo storeAccountInfo];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [RegisterViewController registerSuccessSendCouponTip];
    }else{
        //重置密码
        AccountInfo.standardAccountInfo.phone = _phoneTf.text;
        AccountInfo.standardAccountInfo.password = _passwordTf.text;
        [AccountInfo.standardAccountInfo storeAccountInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)isLeagle
{
    if ([ValidateClass isMobile:_phoneTf.text] == NO)
    {
        if (_phoneTf.text.length == 0)
        {
            [ErrorTipView errorTip:@"请您输入手机号" SuperView:self.view];
        }
        else
        {
            [ErrorTipView errorTip:@"手机号格式有误" SuperView:self.view];
        }

        
        return NO;
    }
    
    //密码验证
    if (_passwordTf.text.length < 1)
    {
        [ErrorTipView errorTip:@"密码不能为空" SuperView:self.view];
        
        return NO;
    }
    
    
    //验证码
    if ( !(_verificationCodeString &&[_codeTf.text isEqualToString:_verificationCodeString] ))
    {
        if (_codeTf.text.length == 0)
        {
            [ErrorTipView errorTip:@"请您输入验证码" SuperView:self.view];
        }
        else
        {
            [ErrorTipView errorTip:@"验证码有误" SuperView:self.view];
        }
        
        return NO;
    }
    
    
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self textFiledResignFirstResponder];
}

- (void)textFiledResignFirstResponder
{
    [_phoneTf resignFirstResponder];
    [_passwordTf resignFirstResponder];
    [_codeTf resignFirstResponder];
}

#pragma mark - 注册成功提示送代金券

+ (void)registerSuccessSendCouponTip
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"惊喜到来" message:@"您已经成为盈投资的新用户，为欢迎新用户我们将赠送您一张8元代金券作为奖励，请您注意查收" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
        
    }];
    
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"去查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
  {
      [self lookMyCouponList];
  }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:loginAction];
    
    UINavigationController *nav = [MainTabBarController shareMainController].selectedViewController;

    [nav.viewControllers.lastObject presentViewController:actionSheet animated:YES completion:nil];
}

+ (void)lookMyCouponList
{
    UINavigationController *nav = [MainTabBarController shareMainController].selectedViewController;
    
    if ([AuthorizationManager isLoginState] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:nav.viewControllers.lastObject];
    }
    else if ([AuthorizationManager isHaveFourLevelWithViewController:nav.viewControllers.lastObject IsNeedCancelClick:NO])
    {
        MyVoucherViewController *voucherVC = [[MyVoucherViewController alloc]init];
        voucherVC.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:voucherVC animated:YES];
    }
}

@end
