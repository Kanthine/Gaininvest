//
//  OpenAccountVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/23.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "OpenAccountVC.h"

#import "ValidateClass.h"
#import "SetTransactionPasswordVC.h"

@interface OpenAccountVC ()

{
    NSString *_verificationCodeString;
    
    NSInteger _interval;
    
    __weak IBOutlet UIButton *_codeButton;
    __weak IBOutlet UILabel *_tipLable;
    __weak IBOutlet UITextField *_phoneTf;
    __weak IBOutlet UITextField *_verCodeTf;
    
}
@property (nonatomic ,strong) NSTimer *timer;


@end

@implementation OpenAccountVC

- (void)dealloc
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tipLable.layer.borderWidth = 1;
    _tipLable.layer.borderColor = [UIColor redColor].CGColor;
    
    
    if (ScreenHeight < 600)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;

}

- (void)leftNavBarButtonClick
{
    if (self.isPush)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
         [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyBoardChange:(NSNotification *)notification
{
    NSDictionary *userInfoDict = notification.userInfo;
    
    
    NSLog(@"userInfoDict ===== %@",userInfoDict);
    
    CGFloat time = [[userInfoDict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    NSValue *endValue = [userInfoDict objectForKey:@"UIKeyboardFrameEndUserInfoKey"] ;
    CGRect endRect = [endValue CGRectValue];
    CGFloat yCoordinate = endRect.origin.y;
    
    
    UIView *verSuperView = _verCodeTf.superview;
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:time];
    

    if (yCoordinate > CGRectGetMaxY(verSuperView.frame))
    {
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    else
    {
        self.view.transform = CGAffineTransformMakeTranslation(0,yCoordinate - CGRectGetMaxY(verSuperView.frame) - 100);
    }
    
    
    [UIView commitAnimations];
}

- (IBAction)getVerCodeButtonClick:(UIButton *)sender
{
    //点击获取验证码
    [_phoneTf resignFirstResponder];
    [_verCodeTf resignFirstResponder];
    
    
    
    if ([ValidateClass isMobile:_phoneTf.text]){
        if (sender.enabled)
        {
            // -- > 发送短信请求
            [self timer];
            [sender setTitleColor:RGBA(149, 149, 149, 1) forState:UIControlStateNormal];
            //获取验证码
            _verificationCodeString = @"123456";
            //不能连续点击
            sender.enabled = NO;
        }
    }else{
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
    
    
    //验证码
    if ( !(_verificationCodeString &&[_verCodeTf.text isEqualToString:_verificationCodeString] ))
    {
        if (_verCodeTf.text.length == 0)
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

- (IBAction)confirmButtonClick:(UIButton *)sender{
    if ([self isLeagle] == NO){
        return;
    }
    
    AccountInfo.standardAccountInfo.phone = _phoneTf.text;
    [AccountInfo.standardAccountInfo storeAccountInfo];
    
    [self bindSuccessNextStepWithOpenAccountWithUrl:@""];
}

- (void)bindSuccessNextStepWithOpenAccountWithUrl:(NSString *)urlString
{
    SetTransactionPasswordVC *setVc = [[SetTransactionPasswordVC alloc]initWithURL:urlString Type:TransactionPasswordKindOpenAccount];
    setVc.isPushVC = self.isPush;
    setVc.navigationItem.title = @"设置交易密码";
    [self.navigationController pushViewController:setVc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_phoneTf resignFirstResponder];
    [_verCodeTf resignFirstResponder];
}


@end
