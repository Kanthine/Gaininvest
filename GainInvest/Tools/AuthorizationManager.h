//
//  AuthorizationManager.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/10.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 用户的权限问题，大致分为四级权限 ：
 权限一 ：只是简单登录，
 权限二 ：是否绑定手机号（针对第三方登录），一些接口入参手机号为必填项
 权限三 ：是否在交易所开户，没有开户，则交易所的所有数据无法拿到
 权限四 ：此开户用户的token值是否有效，若过了有效期，则交易所的所有数据无法拿到
 
 异地登录问题：本地账户失效：在获得权限二的情况下 优先判断是否异地登录
 
 */
@interface AuthorizationManager : NSObject

// CompletionBlock:(void (^) ())block;

/*
 * 判断是否有四级权限，若没有，是否去获取
 */
+ (BOOL)isHaveFourLevelWithViewController:(UIViewController *)viewController IsNeedCancelClick:(BOOL)isNeed;

/*
 * 盈投资 判断是否登录
 */
+ (BOOL)isLoginState;

/*
 * 若是没有登录，则跳转至授权登录界面
 */
+ (void)getAuthorizationWithViewController:(UIViewController *)viewController;

/*
 * 提示注册，则跳转至注册界面
 */
+ (void)getRegisterWithViewController:(UIViewController *)viewController;

/*
* 盈投资 判断是否绑定手机号
*/
+ (BOOL)isBindingMobile;
    
/*
* 若是没有绑定，则去绑定
*/
+ (void)getBindingMobileWithViewController:(UIViewController *)viewController IsNeedCancelClick:(BOOL)isNeed;

/*
 * 盈投资 判断是否异地登录，异地登录，必出弹出框提示
 */
+ (BOOL)isRemoteLoginWithViewController:(UIViewController *)viewController;


/*
 * 盈投资 判断是否在交易所开户
 */
+ (BOOL)isOpenAccountInStockExchange;

/*
 * 若是没有开户，则去交易所
 */
+ (void)openAccountInStockExchangeWithViewController:(UIViewController *)viewController IsNeedCancelClick:(BOOL)isNeed;

    
/*
 * 盈投资 判断令牌是否有效
 */
+ (BOOL)isEffectiveToken;

/*
 * 若是令牌无效，则重新生效
 */
+ (void)getEffectiveTokenWithViewController:(UIViewController *)viewController IsNeedCancelClick:(BOOL)isNeed;



@end
