//
//  ResetLoginPasswordVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/10.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "ResetLoginPasswordVC.h"

#import "LoginHttpManager.h"

@interface ResetLoginPasswordVC ()

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

@property (nonatomic ,strong) LoginHttpManager *httpManager;

@end

@implementation ResetLoginPasswordVC

- (void)dealloc
{
    _httpManager = nil;
}

- (LoginHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[LoginHttpManager alloc]init];
    }
    
    return _httpManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavBar];

    AccountInfo *account = [AccountInfo standardAccountInfo];
    _phoneTf.text = account.username;
    
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"重置登录密码";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
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

    if (sender.enabled)
    {
        // -- > 发送短信请求
        [self timer];
        [sender setTitleColor:RGBA(149, 149, 149, 1) forState:UIControlStateNormal];
        
        //获取验证码
        
        
        NSDictionary *parameterDict = @{@"mobile_phone":_phoneTf.text};
        
        [self.httpManager getVerificationCodeWithParameterDict:parameterDict CompletionBlock:^(NSString *verificationCodeString, NSError *error)
         {
             
             if (error)
             {
                 [ErrorTipView errorTip:@"获取验证码失败" SuperView:self.view];
             }
             else
             {
                 _verificationCodeString = verificationCodeString;
             }
         }];
        
        //不能连续点击
        sender.enabled = NO;
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
        [_codeButton setTitle:@"再次发送" forState:UIControlStateNormal];
        _interval = 60;
        _codeButton.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (IBAction)confirmRegisterButtonClick:(UIButton *)sender
{
    // 确认修改密码
    [self textFiledResignFirstResponder];
    
    if ([self isLeagle] == NO)
    {
        return;
    }
    
    NSDictionary *parameterDict = @{@"user_name":_phoneTf.text,@"salt":_codeTf.text,@"password":_passwordTf.text};
    
    
    [self.httpManager resetPasswordWithParameters:parameterDict CompletionBlock:^(NSDictionary *resultDict,NSError *error)
     {
         if (error)
         {
             [ErrorTipView errorTip:error.domain SuperView:self.view];
         }
         else
         {
             [ErrorTipView errorTip:@"修改密码成功" SuperView:self.view];
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
    
}

- (BOOL)isLeagle
{    
    //密码验证
    if (_passwordTf.text.length < 1)
    {
        [ErrorTipView errorTip:@"密码不能为空" SuperView:self.view];
        
        return NO;
    }
    
    
    //验证码
    if ( !(_verificationCodeString &&[_codeTf.text isEqualToString:_verificationCodeString] ))
    {
        if (_phoneTf.text.length == 0)
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



@end
