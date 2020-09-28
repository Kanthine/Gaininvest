//
//  TransactionHttpManager.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionHttpManager : NSObject


/** 提现接口
 * mobile_phone 手机号
 * tx_money 提现金额
 * province 开户省份
 * city 开户城市
 * bank 银行类型
 * subBank 开户支行
 * cardNo 银行卡号
 * account 开户名
 * code: 卡号+手机验证码
 * bankCode 银行简码
 * card_idno: 银行简码
 * card_phone ：持卡人手机号
 *
 * 处理结果
 * 1155  提现处理中
 * 1156  提现失败
 * 1157  提现成功
 */
- (void)withdrawParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block;

/** 用户提现卡信息
 * mobile_phone 手机号
 */
- (void)withdrawBankCardInfoParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSDictionary *parameterDict,NSError *error))block;


/** 获取验证码
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 */
- (void)getVerificationCodeWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSString *, NSError *error))block;

/*
 * 获取交易验证码
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * type ：1 2 3 4
 */
- (void)getTradeVerificationCodeWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSError *error))block;

@end
