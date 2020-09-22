//
//  LoginViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/8.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "LoginViewController.h"


#import "ValidateClass.h"
#import "LoginHttpManager.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"

#import "MainTabBarController.h"
#import "MyVoucherViewController.h"

@interface LoginViewController ()

{
    
    __weak IBOutlet UITextField *_phoneTf;
    __weak IBOutlet UITextField *_passwordTf;
    
}

@property (nonatomic ,strong) LoginHttpManager *httpManager;

@end

@implementation LoginViewController

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
    
}

- (void)customNavBar
{
    self.navigationItem.title = @"登录";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;

}

- (void)leftNavBarButtonClick
{
    [self textFiledResignFirstResponder];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)passwordSecureButtonClick:(UIButton *)sender
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

- (IBAction)loginButtonClick:(UIButton *)sender
{
    [self textFiledResignFirstResponder];

    if ([self isLeaglePasswordLoginMethod] == NO)
    {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the label text.
    hud.label.text = @"登录...";
    
    [self.httpManager loginWithAccount:_phoneTf.text Password:_passwordTf.text CompletionBlock:^(AccountInfo *user, NSError *error)
     {
         [hud hideAnimated:YES];
         
         if (error)
         {
             [ErrorTipView errorTip:error.domain SuperView:self.view];
         }
         else
         {
             [user storeAccountInfo];//存储数据
             [ErrorTipView errorTip:@"登录成功" SuperView:nil];

             [self.navigationController dismissViewControllerAnimated:YES completion:nil];
         }        
     }];

}

- (IBAction)forgetButtonClick:(UIButton *)sender
{
    [self textFiledResignFirstResponder];

    // 忘记密码
    RegisterViewController *registerVC = [[RegisterViewController alloc]initWithIsRegister:NO];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)registerButtonClick:(UIButton *)sender
{
    [self textFiledResignFirstResponder];

    
    RegisterViewController *registerVC = [[RegisterViewController alloc]initWithIsRegister:YES];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)weChatLoginButtonClick:(UIButton *)sender
{

}

- (IBAction)qqLoginButtonClick:(UIButton *)sender
{

}

- (BOOL)isLeaglePasswordLoginMethod
{
    if ([ValidateClass isMobile:_phoneTf.text] == NO)
    {
        if (_phoneTf.text.length == 0)
        {
            [ErrorTipView errorTip:@"请输入手机号" SuperView:self.view];
        }
        else
        {
            [ErrorTipView errorTip:@"手机号格式有误" SuperView:self.view];
        }
        
        return NO;
    }
    
    if (_passwordTf.text.length < 1)
    {
        [ErrorTipView errorTip:@"密码不得为空" SuperView:self.view];
        
        return NO;
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self textFiledResignFirstResponder];
}

- (void)textFiledResignFirstResponder
{
    [_passwordTf endEditing:YES];
    [_phoneTf endEditing:YES];

}


@end
