//
//  RechargePerfectInfomation.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/29.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "RechargePerfectInfomation.h"

#import "ValidateClass.h"

#import "ChooseBankKindVC.h"
#import "ChooseProvinceCityVC.h"

#import "RechargeInfomationVC.h"
#import "RechargeResultVC.h"

@interface RechargePerfectInfomation()

<UITextFieldDelegate,ChooseBankKindVCDelegate,ChooseProvinceCityVCDelegate>

{
    
    __weak IBOutlet UITextField *_bankCardTf;
    __weak IBOutlet UITextField *_bankNameTf;
    __weak IBOutlet UITextField *_idCardTf;
    
    
    
    __weak IBOutlet UIButton *_chooseBankButton;
    __weak IBOutlet UIButton *_chooseAreaButton;
    __weak IBOutlet UITextField *_subBankTf;
    
    
    __weak IBOutlet UITextField *_bankPhoneTf;
    __weak IBOutlet UITextField *_verCodeTf;
    
    
    NSDictionary *_bankDict;
    
    
    NSString *_rankString;
    
    NSInteger _interval;
    NSDictionary *_orderDict;
    NSArray<AreaModel *> *_areaModelArray;
}

@property (nonatomic ,strong) NSTimer *timer;

@end

@implementation RechargePerfectInfomation

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

    _bankCardTf.delegate = self;
}

- (void)keyBoardChange:(NSNotification *)notification
{
    NSDictionary *userInfoDict = notification.userInfo;
    
    NSValue *endValue = [userInfoDict objectForKey:@"UIKeyboardFrameEndUserInfoKey"] ;
    CGRect endRect = [endValue CGRectValue];
    CGFloat yCoordinate = endRect.origin.y;
    
//    
//    UIScrollView *scrollView = (UIScrollView *)self.superview;
//    if (yCoordinate > ScreenHeight - 64)
//    {
//        // 键盘弹出
//        scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetHeight(self.frame) + 200);
//        
//        NSLog(@"键盘弹出");
//        
//    }
//    else
//    {
//        //键盘消失
//        scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetHeight(self.frame));
//        
//        NSLog(@"键盘消失");
//    }

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

/*
 填写完毕信息 ，通过京东签约接口，获取验证码
 填写验证码   ，调用京东支付接口
 */
- (IBAction)getCodeButtonClick:(UIButton *)sender
{
    //点击获取验证码
    [self endTextFiledEdit];
    
    if ([self checkingInformationIsCorrect] == NO)
    {
        return;
    }
    
    
    if (sender.enabled)
    {
        // -- > 发送短信请求
        [self timer];
        [sender setTitleColor:RGBA(149, 149, 149, 1) forState:UIControlStateNormal];
        
        
        NSDictionary *parameterDict = [self setWithdrawParameterDict];
        
            
        NSLog(@"parameterDict ======= %@",parameterDict);
        
        
        [self.currentViewController.httpManager jingDongSignatoryOnlineWithParameterDict:parameterDict CompletionBlock:^(NSDictionary *resultDict,NSError *error)
         {
             if (error)
             {
                 [ErrorTipView errorTip:error.domain SuperView:self.currentViewController.view];
                 [self stopVerCodeTimer];

             }
             else if (resultDict)
             {
                 _orderDict = resultDict;
                 
                 [self updateServerBankCardInfoWithInfo:parameterDict];
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
    
    if (_verCodeTf.text.length <= 0)
    {
        [ErrorTipView errorTip:@"验证码不能为空" SuperView:self.currentViewController.view];
        return;
    }
    
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSString *money = [NSString stringWithFormat:@"%ld",self.currentMoney * 100];
    NSString *orderId = [NSString stringWithFormat:@"%@",_orderDict[@"data.trade.id"]];
    NSDictionary *parameterDict = @{@"mobile_phone":account.username,
                                    @"trade_amount":money,
                                    @"ordernum":orderId,
                                    @"trade_code":_verCodeTf.text};
    
    
    NSLog(@"parameterDict ======= %@",parameterDict);
    
    [self.currentViewController.httpManager jingDongPayWithParameterDict:parameterDict CompletionBlock:^(NSError *error)
     {
         if (error)
         {
             [ErrorTipView errorTip:error.domain SuperView:self.currentViewController.view];
         }
         else
         {
             if ([account.isHaveJdInfo isEqualToString:@"1"] == NO)
             {
                 account.isHaveJdInfo = @"1";
                 [account storeAccountInfo];
             }
             
             
             [self rechargeSuccess];
         }
     }];

    
    
}

- (void)rechargeSuccess
{
    RechargeResultVC *rechargeVC = [[RechargeResultVC alloc]init];
    rechargeVC.navigationItem.title = @"充值结果";
    rechargeVC.hidesBottomBarWhenPushed = YES;
    [self.currentViewController.navigationController pushViewController:rechargeVC animated:YES];
    
}

- (BOOL)checkingInformationIsCorrect
{
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
    
    
    
    if (_idCardTf.text.length < 1)
    {
        [ErrorTipView errorTip:@"请输入身份证号" SuperView:self.currentViewController.view];
        return NO;
    }
    else if ([ValidateClass isIdentityCard:_idCardTf.text] == NO)
    {
        [ErrorTipView errorTip:@"身份证号输入有误" SuperView:self.currentViewController.view];
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

    
    if (_bankPhoneTf.text.length < 1)
    {
        [ErrorTipView errorTip:@"请输入银行预留手机号" SuperView:self.currentViewController.view];
        return NO;
    }
    else if ([ValidateClass isMobile:_bankPhoneTf.text] == NO)
    {
        [ErrorTipView errorTip:@"银行预留手机号输入有误" SuperView:self.currentViewController.view];
        return NO;
    }
    
    return YES;
}

- (NSDictionary *)setWithdrawParameterDict
{
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
    
    NSString *moneyString = [NSString stringWithFormat:@"%ld",self.currentMoney * 100];
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *parameterDict = @{@"mobile_phone":account.username,
                                    @"card_bank":_bankDict[@"card_bank"],
                                    @"card_no":cardNum,//银行卡号
                                    @"card_name":_bankNameTf.text,
                                    @"card_idno":_idCardTf.text,//持卡人证件号
                                    @"card_phone":_bankPhoneTf.text,
                                    @"trade_amount":moneyString,
                                    @"subBank":_subBankTf.text,
                                    @"province":provinceName,
                                    @"city":cityName};//*持卡人手机号
    
    return parameterDict;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
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
    [_bankCardTf resignFirstResponder];
    [_bankNameTf resignFirstResponder];
    [_bankPhoneTf resignFirstResponder];
    [_idCardTf resignFirstResponder];
    [_subBankTf resignFirstResponder];
    [_verCodeTf resignFirstResponder];
    
}


/* 第一次充值成功后在后台更新银行卡信息 */
- (void)updateServerBankCardInfoWithInfo:(NSDictionary *)infoDict
{
    NSDictionary *dict = @{@"mobile_phone":infoDict[@"card_phone"],
                           @"card_name":infoDict[@"card_name"],
                           @"province":infoDict[@"province"],
                           @"city":infoDict[@"city"],
                           @"bank_name":infoDict[@"card_bank"],
                           @"card_num":infoDict[@"card_no"],
                           @"sub_branch":infoDict[@"subBank"]};
    
    [self.currentViewController.httpManager updateServerBankCardInfoParameterDict:dict CompletionBlock:^(NSError *error)
     {
         
         
         
         
         
         
     }];
}

@end
