//
//  SetTransactionPasswordVC.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/23.
//  Copyright © 2017年 苏沫离. All rights reserved.
//


#import "SetTransactionPasswordVC.h"
#import "YLPasswordInputView.h"
#import "MainTabBarController.h"
#import "MyVoucherViewController.h"

@interface SetTransactionPasswordVC ()
<YLPasswordInputViewDelegate>

{
    TransactionPasswordKind _passwordKind;
}


@property (nonatomic, strong) YLPasswordInputView *passwordView;

@end

@implementation SetTransactionPasswordVC

- (instancetype)initWithType:(TransactionPasswordKind)passwordKind{
    self = [super init];
    if (self){
        _passwordKind = passwordKind;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.leftBarButtonItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    
    [self.view addSubview:self.passwordView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.passwordView becomeFirstResponder];
}

#pragma mark - response click

- (void)leftNavBarButtonClick{
    if (self.isPushVC){
        __block BOOL isHave = NO;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
             if ([obj isKindOfClass:NSClassFromString(@"AccountManagerVC")]){
                 [self.navigationController popToViewController:obj animated:YES];
                 isHave = YES;
                 * stop = YES;
             }
        }];
        
        if (isHave == NO){
            [self.navigationController popViewControllerAnimated:YES];
        }        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBarButtonItemClick{
    if (self.passwordView.text.length < 6) {
        return;
    }
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    if (_passwordKind == TransactionPasswordKindOpenAccount){
        // 开户成功
        account.isOpenAccount = YES;
        account.tradePWD = self.passwordView.text;
        [account storeAccountInfo];
        [UserLocalData setTradeToken:account.tradePWD];
        [self leftNavBarButtonClick];
        
        [SetTransactionPasswordVC registerSuccessSendCouponTip];
    }else if (_passwordKind == TransactionPasswordKindUpdate){
        ///修改交易密码
        
    }else if (_passwordKind == TransactionPasswordKindActivate){
        ///激活交易密码
        if ([self.passwordView.text isEqualToString:account.tradePWD]) {
            [UserLocalData setTradeToken:account.tradePWD];
            [account storeAccountInfo];
            [self leftNavBarButtonClick];
        }else{
            
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - 开户成功提示送代金券

+ (void)registerSuccessSendCouponTip{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"惊喜到来" message:@"您已经成功在交易所开户，我们又赠送您一张8元代金券作为奖励，请您注意查收" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
    
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"去查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self lookMyCouponList];
    }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:loginAction];
    
    UINavigationController *nav = [MainTabBarController shareMainController].selectedViewController;
    
    [nav.viewControllers.lastObject presentViewController:actionSheet animated:YES completion:nil];
}

+ (void)lookMyCouponList{
    UINavigationController *nav = [MainTabBarController shareMainController].selectedViewController;
    
    if ([AuthorizationManager isLoginState] == NO){
        [AuthorizationManager getAuthorizationWithViewController:nav.viewControllers.lastObject];
    }else if ([AuthorizationManager isHaveFourLevelWithViewController:nav.viewControllers.lastObject IsNeedCancelClick:NO]){
        MyVoucherViewController *voucherVC = [[MyVoucherViewController alloc]init];
        voucherVC.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:voucherVC animated:YES];
    }
}

#pragma mark - YLPasswordInputViewDelegate

/**输入改变*/
- (void)passwordInputViewDidChange:(YLPasswordInputView *)passwordInputView{
    
}

/**点击删除*/
- (void)passwordInputViewDidDeleteBackward:(YLPasswordInputView *)passwordInputView{
    
}

/**输入完成*/
- (void)passwordInputViewCompleteInput:(YLPasswordInputView *)passwordInputView{
    
}

/**开始输入*/
- (void)passwordInputViewBeginInput:(YLPasswordInputView *)passwordInputView{
    
}

/**结束输入*/
- (void)passwordInputViewEndInput:(YLPasswordInputView *)passwordInputView{
    
}


#pragma mark - setter and getters

- (YLPasswordInputView *)passwordView{
    if (_passwordView == nil) {
        _passwordView = [[YLPasswordInputView alloc] initWithFrame:CGRectMake((CGRectGetWidth(UIScreen.mainScreen.bounds) - 42 * 6) / 2.0, 120, 42 * 6.0, 42)];
        _passwordView.delegate = self;
    }
    return _passwordView;
}

@end

