//
//  WithdrawPerfectInfoView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/29.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "WithdrawPerfectInfoView.h"

#import "WithdrawViewController.h"
#import "ChooseBankKindVC.h"
#import "ChooseProvinceCityVC.h"

#import "ValidateClass.h"
#import "RechargeResultVC.h"
#import "RechargeTipView.h"


@interface WithdrawPerfectInfoView()
<UITextFieldDelegate,ChooseBankKindVCDelegate,ChooseProvinceCityVCDelegate>

{
    __weak IBOutlet UILabel *_topTipLable;

    
    __weak IBOutlet UITextField *_priceTf;
    __weak IBOutlet UILabel *_priceTipLable;
    
    
    
    __weak IBOutlet UITextField *_bankCardTf;
    __weak IBOutlet UITextField *_bankNameTf;
    
    
    __weak IBOutlet UIButton *_chooseBankButton;
    __weak IBOutlet UIButton *_chooseAreaButton;
    __weak IBOutlet UITextField *_subBankTf;
    
    
    
    __weak IBOutlet UILabel *_phoneLable;
    __weak IBOutlet UITextField *_verCodeTf;
    
    
    NSDictionary *_bankDict;
    
    
    NSString *_rankString;
    
    NSInteger _interval;
    
    NSArray<AreaModel *> *_areaModelArray;
}

@property (nonatomic ,strong) NSTimer *timer;

@end



@implementation WithdrawPerfectInfoView

- (void)dealloc
{
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
        
    _priceTf.delegate = self;
    _bankCardTf.delegate = self;

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
    _topTipLable.userInteractionEnabled = YES;
    [_topTipLable addGestureRecognizer:tapGesture];
    
    _phoneLable.text = [AccountInfo standardAccountInfo].username;

}

- (NSMutableAttributedString *)setAttributeTextWithMoneyStr:(NSString *)moneyString
{
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"提取金额"];
    [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string1.length)];
    [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string1.length)];
    
    
    NSString *moneyStr = [NSString stringWithFormat:@"（可提现金额%@元 ",moneyString];
    
    NSMutableAttributedString *money=[[NSMutableAttributedString alloc] initWithString:moneyStr attributes:nil];
    [money addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, money.length)];
    [money addAttribute:NSForegroundColorAttributeName value:TextColorGray range:NSMakeRange(0, money.length)];
    

    
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"全部提现"];
    [string3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string3.length)];
    [string3 addAttribute:NSForegroundColorAttributeName value:TextColorBlue range:NSMakeRange(0, string3.length)];
    
    
    
    NSMutableAttributedString *string4 = [[NSMutableAttributedString alloc] initWithString:@"）"];
    [string4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string4.length)];
    [string4 addAttribute:NSForegroundColorAttributeName value:TextColorGray range:NSMakeRange(0, string4.length)];
    
    
    [string3 appendAttributedString:string4];
    [money appendAttributedString:string3];
    [string1 appendAttributedString:money];
    return string1;
}

- (void)setAccountMoney:(NSString *)accountMoney
{
    _accountMoney = accountMoney;
    
    _topTipLable.attributedText = [self setAttributeTextWithMoneyStr:accountMoney];
}

- (void)tapGestureClick
{    
    [self endTextFiledEdit];
    UITextField *priceTf = [self viewWithTag:1];
    priceTf.text = _accountMoney;
    
    _priceTipLable.hidden = YES;
}


#pragma mark - Button Click

/* 选择银行 */
- (IBAction)chooseRankKindButtonClick:(UIButton *)sender
{
    [self endTextFiledEdit];
    
    ChooseBankKindVC *rankKindVC = [[ChooseBankKindVC alloc]init];
    rankKindVC.rankString = sender.titleLabel.text;
    rankKindVC.delegate = self;
    rankKindVC.hidesBottomBarWhenPushed = YES;
    [self.currentViewController.navigationController pushViewController:rankKindVC animated:YES];
}

/* 选择地区 */
- (IBAction)chooseProvinceCityButtonClick:(UIButton *)sender
{
    [self endTextFiledEdit];
    
    AreaModel *areaModel = nil;
    if (_areaModelArray && _areaModelArray.count > 0 )
    {
        areaModel = _areaModelArray.firstObject;
    }
    
    
    ChooseProvinceCityVC *provinceCityVC = [[ChooseProvinceCityVC alloc]initWithSuperModel:areaModel AreaRank:1];
    provinceCityVC.delegate = self;
    provinceCityVC.hidesBottomBarWhenPushed = YES;
    [self.currentViewController.navigationController pushViewController:provinceCityVC animated:YES];
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
                 [ErrorTipView errorTip:error.domain SuperView:self.currentViewController.view];
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
    
    
    
    NSLog(@"parameterDict ======== %@",parameterDict);

    
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
        [ErrorTipView errorTip:@"请输入提现金额" SuperView:self.currentViewController.view];
        return NO;
    }
    
    float money = [_priceTf.text floatValue];
    float sum = [self.accountMoney floatValue];
    
    if (money > sum)
    {
        [ErrorTipView errorTip:@"提现金额大于您的总金额" SuperView:self.currentViewController.view];
        return NO;
    }
    
    NSString *bankCardString = _bankCardTf.text;
    bankCardString = [bankCardString stringByReplacingOccurrencesOfString:@"" withString:@" "];
    if ([ValidateClass isBankCard:bankCardString] == NO)
    {
        [ErrorTipView errorTip:@"银行卡号有误" SuperView:self.currentViewController.view];
        return NO;
    }
    
    if (_bankNameTf.text.length < 1)
    {
        [ErrorTipView errorTip:@"请输入持卡人姓名" SuperView:self.currentViewController.view];
        return NO;
    }
    
    
    if (! (_bankDict && [_bankDict isKindOfClass:[NSDictionary class]]) )
    {
        [ErrorTipView errorTip:@"请选择银行" SuperView:self.currentViewController.view];
        return NO;
    }
    
    
    if ( ! (_areaModelArray && _areaModelArray.count ) )
    {
        [ErrorTipView errorTip:@"请确认您选择的地区正确" SuperView:self.currentViewController.view];
        return NO;
    }
    
    if (_subBankTf.text.length < 1)
    {
        [ErrorTipView errorTip:@"请输入支行名称" SuperView:self.currentViewController.view];
        return NO;
    }
    
    if (_verCodeTf.text.length < 1)
    {
        [ErrorTipView errorTip:@"请输入验证码" SuperView:self.currentViewController.view];
        return NO;
    }
    
    return YES;
}

- (NSDictionary *)setWithdrawParameterDict
{
    
    float money = [_priceTf.text floatValue];
    
    NSString *moneyString = [NSString stringWithFormat:@"%.0f",money * 100];
    
    NSString *cardNum = _bankCardTf.text;
    cardNum = [cardNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    __block NSString *provinceName = @"";
    __block NSString *cityName = @"";
    
    if (_areaModelArray && _areaModelArray.count)
    {
        [_areaModelArray enumerateObjectsUsingBlock:^(AreaModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (idx == 0)
             {
                 provinceName = obj.name;
             }
             else
             {
                 cityName = obj.name;
             }
         }];
    }
    
    NSString *verCode = [cardNum stringByAppendingString:_verCodeTf.text];
    
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *parameterDict = @{@"mobile_phone":account.phone,
                                    @"tx_money":moneyString,
                                    @"province":provinceName,
                                    
                                    @"city":cityName,
                                    @"bank":_bankDict[@"bankName"],
                                    @"subBank":_subBankTf.text,
                                    
                                    @"cardNo":cardNum,//银行卡号
                                    @"account":_bankNameTf.text,
                                    @"code":verCode,
                                    
                                    @"bankCode":_bankDict[@"card_bank"],
                                    @"card_idno":@"",//持卡人证件号
                                    @"card_phone":@""};//持卡人手机号
    
    return parameterDict;
}

- (IBAction)rechargeTipButtonClick:(UIButton *)sender
{
    [[[RechargeTipView alloc]init] show];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    NSLog(@"textField ========= %@",textField);
    //    NSLog(@"textField ========= %@",self.superview);
    
    
    if (textField.tag == 1)
    {
        _priceTipLable.hidden = YES;
    }
    
    
    
    CGFloat keyBoardHeight = ScreenHeight - 64 - CGRectGetMaxY(textField.frame);
    if (keyBoardHeight < 280)
    {
        //        UIScrollView *scrollView = (UIScrollView *)self.superview;
        //        [scrollView setContentOffset:CGPointMake(0, 280 - keyBoardHeight) animated:YES];
    }
    else
    {
        
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.tag != 2)
    {
        return YES;
    }
    
    NSString *text = [textField text];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
    {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *newString = @"";
    while (text.length > 0)
    {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    if (newString.length >= 25)
    {
        return NO;
    }
    
    [textField setText:newString];
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - ChooseBankKindVCDelegate

- (void)tableViewDidSelectRankKind:(NSDictionary *)rankDict
{
    if (rankDict && [rankDict isKindOfClass:[NSDictionary class]])
    {
        _bankDict = rankDict;
        
        
        [_chooseBankButton setTitle:rankDict[@"bankName"] forState:UIControlStateNormal];
        [_chooseBankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
}

#pragma mark - ChooseProvinceCityVCDelegate

- (void)tableViewDidSelectAreaArray:(NSArray<AreaModel *> *)areaArray
{
    _areaModelArray = areaArray;
    
    
    __block NSString *name = @"";
    
    [areaArray enumerateObjectsUsingBlock:^(AreaModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (idx == 0)
         {
             name = obj.name;
         }
         else
         {
             name = [NSString stringWithFormat:@"%@ %@",name,obj.name];
         }
     }];
    
    [_chooseAreaButton setTitle:name forState:UIControlStateNormal];
    [_chooseAreaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endTextFiledEdit];
}

- (void)endTextFiledEdit
{
    [_priceTf resignFirstResponder];
    [_bankCardTf resignFirstResponder];
    [_bankNameTf resignFirstResponder];
    [_subBankTf resignFirstResponder];
    [_verCodeTf resignFirstResponder];
}

@end
