//
//  WithdrawBankCardInfoView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/15.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "WithdrawBankCardInfoView.h"

#import "WithdrawViewController.h"
#import "RechargeResultVC.h"

@interface WithdrawBankCardInfoView()
<UITextFieldDelegate>
{
    __weak IBOutlet UILabel *_priceTipLable;
    __weak IBOutlet UILabel *_bankCardLable;
    __weak IBOutlet UILabel *_topTipLable;
    __weak IBOutlet UITextField *_priceTf;
    __weak IBOutlet UILabel *_phoneLable;
    __weak IBOutlet UITextField *_verCodeTf;

    
    
    NSInteger _interval;
    
}

@property (nonatomic ,strong) NSTimer *timer;

@end


@implementation WithdrawBankCardInfoView

- (NSMutableAttributedString *)setAttributeTextWithMoneyStr:(NSString *)moneyString
{
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"提取金额（可提现"];
    [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string1.length)];
    [string1 addAttribute:NSForegroundColorAttributeName value:TextColorBlack range:NSMakeRange(0, string1.length)];
    
    
    
    
    NSMutableAttributedString *money=[[NSMutableAttributedString alloc] initWithString:moneyString attributes:nil];
    [money addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, money.length)];
    [money addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, money.length)];
    
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"元 "];
    [string2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string2.length)];
    [string2 addAttribute:NSForegroundColorAttributeName value:TextColorBlack range:NSMakeRange(0, string2.length)];
    
    
    
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"全部提现"];
    [string3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string3.length)];
    [string3 addAttribute:NSForegroundColorAttributeName value:TextColorBlue range:NSMakeRange(0, string3.length)];
    
    
    
    NSMutableAttributedString *string4 = [[NSMutableAttributedString alloc] initWithString:@"）"];
    [string4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string4.length)];
    [string4 addAttribute:NSForegroundColorAttributeName value:TextColorBlack range:NSMakeRange(0, string4.length)];
    
    
    [string3 appendAttributedString:string4];
    [string2 appendAttributedString:string3];
    [money appendAttributedString:string2];
    [string1 appendAttributedString:money];
    return string1;
}

- (void)setAccountMoney:(NSString *)accountMoney
{
    _accountMoney = accountMoney;
    
    _topTipLable.attributedText = [self setAttributeTextWithMoneyStr:accountMoney];
    
}

- (void)setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    
    //中国农业银行（0611）
    
    NSString *cardNum = [NSString stringWithFormat:@"%@",_infoDict[@"card_no"]];
    
    NSString *bank = [NSString stringWithFormat:@"%@",_infoDict[@"bankName"]];

    NSString *cardNumLast = [cardNum substringFromIndex:(cardNum.length - 4)];
    NSString *bankString = [NSString stringWithFormat:@"%@(%@)",bank,cardNumLast];
    
    _bankCardLable.text = bankString;
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _priceTf.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    _topTipLable.userInteractionEnabled = YES;
    [_topTipLable addGestureRecognizer:tapGesture];
    
    NSString *phoneStr = [AccountInfo standardAccountInfo].username;
    _phoneLable.text = phoneStr;
    
}

- (void)tapGestureClick
{
    [self endTextFiledEdit];
    UITextField *priceTf = [self viewWithTag:1];
    priceTf.text = _accountMoney;
    
    _priceTipLable.hidden = YES;

}

/* 获取验证码 */
- (IBAction)getCodeButtonClick:(UIButton *)sender
{
    //点击获取验证码
    [self endTextFiledEdit];
    
    if (sender.enabled)
    {
        // -- > 发送短信请求
        [self timer];
        [sender setTitleColor:RGBA(149, 149, 149, 1) forState:UIControlStateNormal];
        
        //获取验证码
        NSString *phoneStr = [AccountInfo standardAccountInfo].username;
        NSDictionary *parameterDict = @{@"mobile_phone":phoneStr,@"type":@"4"};
        [self.currentViewController.httpManager getTradeVerificationCodeWithParameterDict:parameterDict CompletionBlock:^(NSError *error)
         {
             if (error)
             {
                 [ErrorTipView errorTip:error.domain SuperView:self];
                 [self stopVerCodeTimer];
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
    UIButton *codeButton = [self viewWithTag:9];
    
    
    _interval --;
    NSString *title = [NSString stringWithFormat:@"重新发送(%02ld)",_interval];
    codeButton.titleLabel.text = title;
    [codeButton setTitle:title forState:UIControlStateDisabled];
    
    if (_interval == 0)
    {
        [self stopVerCodeTimer];
    }
}

- (void)stopVerCodeTimer
{
    UIButton *codeButton = [self viewWithTag:9];
    
    [codeButton setTitleColor:RGBA(72, 119, 230, 1) forState:UIControlStateNormal];
    codeButton.layer.borderColor = RGBA(72, 119, 230, 1).CGColor;
    [codeButton setTitle:@"再次发送" forState:UIControlStateNormal];
    _interval = 60;
    codeButton.enabled = YES;
    [self.timer invalidate];
    self.timer = nil;
    
}

/* 提交 */
- (IBAction)submitApplyButtonClick:(UIButton *)sender
{
    [self endTextFiledEdit];
    
    if ([self checkingInformationIsCorrect] == NO)
    {
        return;
    }
    
    
    NSDictionary *parameterDict = [self setWithdrawParameterDict];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = @"提交订单...";
    [self.currentViewController.httpManager withdrawParameterDict:parameterDict CompletionBlock:^(NSError *error)
     {
         [hud hideAnimated:YES];
         if (error.code > 0 )
         {
             //超出大额提现范围,进入人工审核中 1153
             //提现处理中 1155
             //提现成功 1157
             [self withdrawSuccess];
         }
         else
         {
             [ErrorTipView errorTip:error.domain SuperView:self.currentViewController.view];
         }
     }];
}

- (void)withdrawSuccess
{
    RechargeResultVC *rechargeVC = [[RechargeResultVC alloc]init];
    rechargeVC.navigationItem.title = @"提现结果";
    rechargeVC.hidesBottomBarWhenPushed = YES;
    [self.currentViewController.navigationController pushViewController:rechargeVC animated:YES];
}

- (BOOL)checkingInformationIsCorrect
{
    if (_priceTf.text.length < 1)
    {
        [ErrorTipView errorTip:@"请输入提现金额" SuperView:self];
        return NO;
    }
    float money = [_priceTf.text floatValue];
    float sum = [self.accountMoney floatValue];
    
    if (money > sum)
    {
        [ErrorTipView errorTip:@"提现金额大于您的总金额" SuperView:self];
        return NO;
    }
    
    if (_verCodeTf.text.length < 1)
    {
        [ErrorTipView errorTip:@"请输入验证码" SuperView:self];
        return NO;
    }
    
    return YES;
}

- (NSDictionary *)setWithdrawParameterDict
{

    float money = [_priceTf.text floatValue];
    
    NSString *moneyString = [NSString stringWithFormat:@"%.0f",money * 100];
    NSString *cardNum = [NSString stringWithFormat:@"%@",_infoDict[@"card_no"]];
    NSString *card_name = [NSString stringWithFormat:@"%@",_infoDict[@"card_name"]];
    
    NSString *city = [NSString stringWithFormat:@"%@",_infoDict[@"city"]];
    NSString *bankCode = [NSString stringWithFormat:@"%@",_infoDict[@"card_bank"]];
    NSString *subBank = [NSString stringWithFormat:@"%@",_infoDict[@"subBank"]];
    
    NSString *bank = [NSString stringWithFormat:@"%@",_infoDict[@"bankName"]];
    NSString *province = [NSString stringWithFormat:@"%@",_infoDict[@"province"]];
    NSString *verCode = [cardNum stringByAppendingString:_verCodeTf.text];
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *parameterDict = @{@"mobile_phone":account.username,
                                    @"tx_money":moneyString,
                                    @"province":province,
                                    
                                    @"city":city,
                                    @"bank":bank,
                                    @"subBank":subBank,
                                    
                                    @"cardNo":cardNum,//银行卡号
                                    @"account":card_name,
                                    @"code":verCode,
                                    
                                    @"bankCode":bankCode,
                                    @"card_idno":@"",//持卡人证件号
                                    @"card_phone":@""};//*持卡人手机号

    return parameterDict;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1)
    {
        _priceTipLable.hidden = YES;
    }

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"textField ---------- %@",textField);
    if (textField.tag == 1)
    {
        if (textField.text.length > 0)
        {
            _priceTipLable.hidden = YES;
        }
        else
        {
            _priceTipLable.hidden = NO;
        }
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)endTextFiledEdit
{
    [_priceTf resignFirstResponder];
    [_verCodeTf resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endTextFiledEdit];
}

@end
