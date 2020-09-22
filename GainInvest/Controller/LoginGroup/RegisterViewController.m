//
//  RegisterViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/8.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "RegisterViewController.h"
#import "ValidateClass.h"

#import "LoginHttpManager.h"
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

@property (nonatomic ,strong) LoginHttpManager *httpManager;

@end

@implementation RegisterViewController

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
            
            //获取验证码
            
            
            NSDictionary *parameterDict = @{@"mobile_phone":_phoneTf.text};
            if (_isRegister)
            {
                parameterDict = @{@"mobile_phone":_phoneTf.text,@"ischeck":@"2"};
            }
                        
            [self.httpManager getVerificationCodeWithParameterDict:parameterDict CompletionBlock:^(NSString *verificationCodeString, NSError *error)
            {
                
                if (error)
                {
                    [self stopTimer];
                    [ErrorTipView errorTip:error.domain SuperView:self.view];
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

}

- (IBAction)qqLoginButtonClick:(UIButton *)sender
{
 
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

- (IBAction)confirmRegisterButtonClick:(UIButton *)sender
{
    // 点击注册
    [self textFiledResignFirstResponder];
    
    if ([self isLeagle] == NO)
    {
        return;
    }
    
    
    if (_isRegister)
    {
        
        //注册
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Set the label text.
        hud.label.text = @"注册中...";
        NSDictionary *parameterDict = @{@"mobile_phone":_phoneTf.text,@"salt":_codeTf.text,@"password":_passwordTf.text,@"froms":@"iOS"};
        [self.httpManager regiserAccountWithParameter:parameterDict CompletionBlock:^(NSDictionary *resultDict,NSError *error)
         {
             [hud hideAnimated:YES];

             if (error)
             {
                 [ErrorTipView errorTip:error.domain SuperView:self.view];
             }
             else
             {
                 
                 // 注册成功 去登陆
                 
                 [self registerSuccessLoginWithPhone:parameterDict[@"mobile_phone"] Password:parameterDict[@"password"]];
                 
                 
//                 [ErrorTipView errorTip:@"注册成功" SuperView:self.view];
                 
             }
         }];

    }
    else
    {
        
        NSDictionary *parameterDict = @{@"user_name":_phoneTf.text,@"salt":_codeTf.text,@"password":_passwordTf.text};
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Set the label text.
        hud.label.text = @"修改中...";
        
        //重置密码
        [self.httpManager resetPasswordWithParameters:parameterDict CompletionBlock:^(NSDictionary *resultDict,NSError *error)
         {
             [hud hideAnimated:YES];

             if (error)
             {
                 [ErrorTipView errorTip:error.domain SuperView:self.view];
             }
             else
             {

                [ErrorTipView errorTip:@"修改密码成功" SuperView:self.view];
                [self leftNavBarButtonClick];
             }
         }];

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

- (void)thirdPartyLoginWithModel:(ThirdLoginModel *)thirdModel
{
    NSDictionary *parameterDict = @{@"openid":thirdModel.uid,@"type":thirdModel.platfrom,@"nickname":thirdModel.nickname,@"head":thirdModel.iconurl,@"token":@"4zpSrxbyMdSRM2fj",@"froms":@"iOS"};
    
    
    [self.httpManager thirdPartyLoginWithParameterDict:parameterDict CompletionBlock:^(AccountInfo *user, NSError *error)
     {
         NSLog(@"code == %ld",(long)error.code);
         
         NSLog(@"errString == %@",error.domain);
         if (error)
         {
             if (error.code == 1)
             {
                 AccountInfo *account = [AccountInfo modelObjectWithThirdModel:thirdModel];
                 [account storeAccountInfo];
                 
                 
                 //提示 送代金券
                 [self dismissViewControllerAnimated:YES completion:nil];
                 [RegisterViewController registerSuccessSendCouponTip];
                 
                 NSLog(@"存储数据成功");
             }
             else
             {
                 [ErrorTipView errorTip:error.domain SuperView:self.view];
             }
             
         }
         else
         {
             
             
             if ([user storeAccountInfo])
             {
                 //登录成功后IM登录
                 [AuthorizationManager getIM_Authorization];
                 //存储数据
                 [ErrorTipView errorTip:@"登录成功" SuperView:nil];
                 //登录成功，进入主界面
                 [self dismissViewControllerAnimated:YES completion:nil];
                 
                 NSLog(@"存储数据成功");
                 
             }
             else
             {
                 NSLog(@"存储数据失败");
             }
             
         }
         
     }];
    
}

#pragma mark - 注册成功去登陆

- (void)registerSuccessLoginWithPhone:(NSString *)phone Password:(NSString *)password
{
    
    [self.httpManager loginWithAccount:phone Password:password CompletionBlock:^(AccountInfo *user, NSError *error)
     {
         
         if (error)
         {
             [ErrorTipView errorTip:error.domain SuperView:self.view];
         }
         else
         {
             [user storeAccountInfo];//存储数据
             
             [self.navigationController dismissViewControllerAnimated:YES completion:nil];
             [RegisterViewController registerSuccessSendCouponTip];

         }
     }];
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
