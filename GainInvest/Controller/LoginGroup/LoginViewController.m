//
//  LoginViewController.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/8.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "LoginViewController.h"

#import "ValidateClass.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"

#import "MainTabBarController.h"
#import "MyVoucherViewController.h"

@interface LoginViewController ()

{
    __weak IBOutlet UITextField *_phoneTf;
    __weak IBOutlet UITextField *_passwordTf;
    
}

@end

@implementation LoginViewController

- (void)viewDidLoad{
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

- (IBAction)loginButtonClick:(UIButton *)sender{
    [self textFiledResignFirstResponder];
    if ([self isLeaglePasswordLoginMethod] == NO){
        return;
    }
    AccountInfo.standardAccountInfo.phone = _phoneTf.text;
    AccountInfo.standardAccountInfo.password = _passwordTf.text;
    
    AccountInfo.standardAccountInfo.userID = @"356781";
    AccountInfo.standardAccountInfo.uToken = @"asd3r2tk3byk21jvtj42jt42j";

    [AccountInfo.standardAccountInfo storeAccountInfo];
    [ErrorTipView errorTip:@"登录成功" SuperView:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    AccountInfo.standardAccountInfo.head = @"";
    AccountInfo.standardAccountInfo.username = @"微信登录";
    [AccountInfo.standardAccountInfo storeAccountInfo];
    
    //登录成功，进入主界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)qqLoginButtonClick:(UIButton *)sender
{
    AccountInfo.standardAccountInfo.head = @"";
    AccountInfo.standardAccountInfo.username = @"QQ登录";
    [AccountInfo.standardAccountInfo storeAccountInfo];
    //登录成功，进入主界面
    [self dismissViewControllerAnimated:YES completion:nil];
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
