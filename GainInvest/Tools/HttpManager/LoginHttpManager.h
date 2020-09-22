//
//  LoginHttpManager.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/9.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginHttpManager : NSObject


/*
 * 获取验证码
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 */
- (void)getVerificationCodeWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSString *verificationCodeString,NSError *error))block;

/*
 * 注册
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * salt ：验证码
 * password 密码
 */
- (void)regiserAccountWithParameter:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSDictionary *resultDict,NSError *error))block;

/*
 * 登录
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 * password 密码
 */
- (void)loginWithAccount:(NSString *)numberString Password:(NSString *)pwdString CompletionBlock:(void (^) (AccountInfo *user,NSError *error))block;

    
/*
 * 第三方登录
 * parameterDict 登录时需要参数：
 * openid ： open
 * type ： 微信是1qq是2
 * nickname ： 用户名*
 * head ： 头像
 * token
 */
- (void)thirdPartyLoginWithParameterDict:(NSDictionary *)parametersDict  CompletionBlock:(void (^) (AccountInfo *user,NSError *error))block;

/*
 * 绑定手机号
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * salt ： 验证码
 * weixin_openid ：
 * qq_openid ：
 * nickname ：昵称
 * head ：头像
 * froms ：iOS
 */
- (void)bindMobileWithParameterDict:(NSDictionary *)parametersDict  CompletionBlock:(void (^) ( AccountInfo *account,NSString *urlStr,NSError *error))block;
    
/*
 * 重置密码：
 *
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 * password ：密码
 * salt ： 验证码
 */
- (void)resetPasswordWithParameters:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSDictionary *resultDict,NSError *error))block;

/*
 * 设置交易密码：
 *
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 */
- (void)setTransactionPasswordWithParameters:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSDictionary *resultDict,NSError *error))block;

/*
 * 重置交易密码：
 *
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 */
- (void)resetTransactionPasswordWithParameters:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSDictionary *resultDict,NSError *error))block;


@end
