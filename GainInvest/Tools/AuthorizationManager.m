//
//  AuthorizationManager.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/10.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "AuthorizationManager.h"

#import "LoginViewController.h"

#import "TransactionHttpManager.h"
#import "TradeLoginViewController.h"
#import "RegisterViewController.h"


#import "ActivateTradePwdView.h"
#import "OpenAccountVC.h"
#import "SetTransactionPasswordVC.h"
#import "MyVoucherViewController.h"

#import "MainTabBarController.h"

@implementation AuthorizationManager

/*
 * 判断是否有四级权限，若没有，是否去获取
 */
+ (BOOL)isHaveFourLevelWithViewController:(UIViewController *)viewController IsNeedCancelClick:(BOOL)isNeed
{
    
    if ([AuthorizationManager isLoginState] == NO)
    {
        if (isNeed)
        {
            [AuthorizationManager getAuthorizationWithViewController:viewController];
        }
        return NO;
    }
    else if ([AuthorizationManager isBindingMobile] == NO)
    {
        [AuthorizationManager getBindingMobileWithViewController:viewController IsNeedCancelClick:isNeed];
        return NO;
    }
    else if ([AuthorizationManager isRemoteLoginWithViewController:viewController])
    {
        return NO;
    }
    else if ([AuthorizationManager isOpenAccountInStockExchange] == NO)
    {
        [AuthorizationManager openAccountInStockExchangeWithViewController:viewController IsNeedCancelClick:isNeed];
        return NO;
    }
    else if ([AuthorizationManager isEffectiveToken] == NO)
    {
        [AuthorizationManager getEffectiveTokenWithViewController:viewController IsNeedCancelClick:isNeed];
        return NO;
    }
    else
    {
        return YES;
    }
}

/*
 * 判断是否授权
 */
+ (BOOL)isLoginState
{
    // 第三方登录为假登录，等级较弱，优先判断是否为第三方登录
    
    if ([ThirdLoginModel isExitThirdAccountInfo])
    {
        return YES;//第三方登录
    }
    
    
    AccountInfo *user = [AccountInfo standardAccountInfo];
    
    NSString *token = user.uToken;
    NSString *userID = user.internalBaseClassIdentifier;
    
    if (token == nil || [token isEqualToString:@""])
    {
        return NO;
    }
    if (userID == nil || [userID isEqualToString:@""])
    {
        return NO;
    }
    
    return YES;
}

/*
 * 若是没有授权，则跳转至授权登录界面
 */
+ (void)getAuthorizationWithViewController:(UIViewController *)viewController
{
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    loginNav.navigationBar.tintColor = [UIColor whiteColor];
    loginNav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    UIImage *blackImage = [AuthorizationManager loadTabBarAndNavBarBackgroundImage];
    [loginNav.navigationBar setBackgroundImage:blackImage forBarMetrics:UIBarMetricsDefault];
        
    [viewController presentViewController:loginNav animated:YES completion:nil];
}

/*
 * 提示注册，则跳转至注册界面
 */
+ (void)getRegisterWithViewController:(UIViewController *)viewController
{
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    loginNav.navigationBar.tintColor = [UIColor whiteColor];
    loginNav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    UIImage *blackImage = [AuthorizationManager loadTabBarAndNavBarBackgroundImage];
    [loginNav.navigationBar setBackgroundImage:blackImage forBarMetrics:UIBarMetricsDefault];
    
    RegisterViewController *registerVC = [[RegisterViewController alloc]initWithIsRegister:YES];
    [loginNav pushViewController:registerVC animated:NO];
    
    [viewController presentViewController:loginNav animated:YES completion:nil];
}

/*
 * 盈投资 判断是否绑定手机号
 */
+ (BOOL)isBindingMobile
{
    if ([AuthorizationManager isLoginState] == NO)
    {
        return NO;
    }
    
    AccountInfo *user = [AccountInfo standardAccountInfo];

    NSString *mobile = user.username;

    if (mobile == nil || [mobile isEqualToString:@""])
    {
        return NO;
    }
    
    return YES;
    
}
    
/*
 * 若是没有绑定，则去绑定
 */
+ (void)getBindingMobileWithViewController:(UIViewController *)viewController IsNeedCancelClick:(BOOL)isNeed
{
    if ([self isLoginState] == NO)
    {
        [self getAuthorizationWithViewController:viewController];
        return;
    }
    [self removeShowedActivateTradePwdView];
    
    ActivateTradePwdView *tipView = [[ActivateTradePwdView alloc]initWithState:ActivateTradePwdStateBindMobile];
    [tipView show];
    
    tipView.activateTradePwdViewCancelButtonClick = ^()
    {
        if (isNeed)
        {
            [MainTabBarController setSelectedIndex:1];
        }
    };
    
    tipView.activateTradePwdViewConfirmButtonClick = ^()
    {
        
        OpenAccountVC *setVc = [[OpenAccountVC alloc]initWithNibName:@"OpenAccountVC" bundle:nil];
        setVc.isPush = NO;
        setVc.navigationItem.title = @"恒大交易所";
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:setVc];
        [viewController presentViewController:nav animated:YES completion:nil];
        
    };
}

/*
 * 盈投资 判断是否异地登录，异地登录，必出弹出框提示
 */
+ (BOOL)isRemoteLoginWithViewController:(UIViewController *)viewController
{
    BOOL isRemoteLogin = [UserLocalData isRemoteLogin];
    
    if (isRemoteLogin)
    {
        __block BOOL isTiped = NO;
        [[UIApplication sharedApplication].keyWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if ([obj isKindOfClass:[ActivateTradePwdView class]])
            {
                isTiped = YES;
            }
        }];
        
        if (isTiped)
        {
            return YES;
        }
        
        
        ActivateTradePwdView *tipView = [[ActivateTradePwdView alloc]initWithState:ActivateTradePwdStateRemoteLogin];
        [tipView show];
        
        tipView.activateTradePwdViewCancelButtonClick = ^()
        {
            
            
            [[AccountInfo standardAccountInfo] logoutAccount];
        };
        
        tipView.activateTradePwdViewConfirmButtonClick = ^()
        {
            //重新登录
            [[AccountInfo standardAccountInfo] logoutAccount];
            [AuthorizationManager getAuthorizationWithViewController:viewController];
        };
        
        
        return YES;
    }
    
    
    return NO;
}



/*
 * 盈投资 判断是否在交易所开户
 */
+ (BOOL)isOpenAccountInStockExchange
{
    if ([self isBindingMobile] == NO)
    {
        return NO;
    }

    AccountInfo *user = [AccountInfo standardAccountInfo];
    
    NSString *isOpenAccount = user.isOpenAccount;

    if ([isOpenAccount isEqualToString:@"1"])
    {
        return YES;
    }
    else
    {
         return NO;
    }
}

/** 若是没有开户，则去交易所
 */
+ (void)openAccountInStockExchangeWithViewController:(UIViewController *)viewController IsNeedCancelClick:(BOOL)isNeed{
    if ([self isBindingMobile] == NO){
        return ;
    }
    [self removeShowedActivateTradePwdView];
    
    ActivateTradePwdView *tipView = [[ActivateTradePwdView alloc]initWithState:ActivateTradePwdStateOpenAccount];
    [tipView show];
    
    tipView.activateTradePwdViewCancelButtonClick = ^(){
        if (isNeed){
            [MainTabBarController setSelectedIndex:1];
        }
    };
    
    tipView.activateTradePwdViewConfirmButtonClick = ^(){
        SetTransactionPasswordVC *setVc = [[SetTransactionPasswordVC alloc]initWithType:TransactionPasswordKindOpenAccount];
        setVc.isPushVC = NO;
        setVc.navigationItem.title = @"设置交易密码";
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:setVc];
        [viewController presentViewController:nav animated:YES completion:nil];
    };
}

/*
 * 盈投资 判断令牌是否有效
 */
+ (BOOL)isEffectiveToken
{
    if ([self isOpenAccountInStockExchange] == NO)
    {
        return NO;
    }

    return [UserLocalData isTradeEffectiveToken];
}


/*
 * 若是令牌无效，则重新生效
 */
+ (void)getEffectiveTokenWithViewController:(UIViewController *)viewController IsNeedCancelClick:(BOOL)isNeed
{
    if ([self isOpenAccountInStockExchange] == NO)
    {
        [self getBindingMobileWithViewController:viewController IsNeedCancelClick:isNeed];
        return;
    }
    [self removeShowedActivateTradePwdView];
    
    ActivateTradePwdView *tipView = [[ActivateTradePwdView alloc]initWithState:ActivateTradePwdStateActivateTrade];
    [tipView show];
    
    tipView.activateTradePwdViewCancelButtonClick = ^()
    {
        if (isNeed)
        {
            [MainTabBarController setSelectedIndex:1];
        }
    };
    
    tipView.activateTradePwdViewConfirmButtonClick = ^()
    {
        
        AccountInfo *account = [AccountInfo standardAccountInfo];
        NSDictionary *dict = @{@"user_name":account.username};
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];

        [[[TransactionHttpManager alloc]init] tradeLoginWithParameterDict:dict CompletionBlock:^(NSString *urlString, NSError *error)
         {
             [hud hideAnimated:YES];

             if (error)
             {
                 
             }
             else
             {
                 
                 
                 TradeLoginViewController *setVc = [[TradeLoginViewController alloc]initWithURL:urlString];
                 setVc.navigationItem.title = @"设置交易密码";
                 UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:setVc];
                 [viewController presentViewController:nav animated:YES completion:nil];
             }
         }];
    };

}

//判断界面是否显示次提示框，防止重复显示
+ (void)removeShowedActivateTradePwdView
{
    [[UIApplication sharedApplication].keyWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj isKindOfClass:[ActivateTradePwdView class]])
         {
             [obj removeFromSuperview];
             *stop = YES ;
         }
     }];
}


+ (UIImage *)loadTabBarAndNavBarBackgroundImage
{    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [NavBarBackColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/*
 * IM 是否登录
 */
+ (BOOL)isIM_Authorization
{
    if([AuthorizationManager isLoginState] == NO)
    {
        return NO;
    }
    
    return [UserLocalData isIM_Authorization];
}

/*
 * IM 若是没有登录，则登录
 */
+ (void)getIM_Authorization
{
    if ([self isLoginState] == NO)
    {
        return;
    }
    
    AccountInfo *account = [AccountInfo standardAccountInfo];    
}

/*
 * IM 若是登录，则退出
 */
+ (void)cancelIM_Authorization
{

}


@end
