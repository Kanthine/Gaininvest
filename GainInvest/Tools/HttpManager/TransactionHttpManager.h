//
//  TransactionHttpManager.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionHttpManager : NSObject

/** 获取地域列表
 * cur_page 页数
 * cur_size 数量
 * parent_id 父级id
 */
- (void)getAreaListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray<AreaModel *> *listArray,NSError *error))block;

/** 更新服务器缓存的 银行卡信息
 * mobile_phone 手机号
 * card_name 账户名
 * province 开户省份
 * city 开户城市
 * bank_name 银行名称
 * card_num 银行卡号
 * sub_branch 开户支行
 */
- (void)updateServerBankCardInfoParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block;


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

/*
 * 京东在线签约
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * card_bank ：银行编码
 * card_no ： 银行卡号
 * card_name 持卡人姓名
 * card_idno 持卡人证件号
 * card_phone 持卡人手机号
 * trade_amount 交易金额(分)
 * subBank 银行分行
 * province 开户省份
 * city 开户城市
 */
- (void)jingDongSignatoryOnlineWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSDictionary *resultDict, NSError *error))block;


/*
 * 京东支付
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * trade_amount ：交易金额 （单位：分）
 * ordernum ： 订单号
 * trade_code 交易验证码
 */
- (void)jingDongPayWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSError *error))block;

/*
 * 银联充值
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * trade_amount ：交易金额（单位：分）
 * card_no ： 充值的卡号
 * channel ： 1 银联 4翼支付 12中信微信app支付 34联动支付 40通联支付
 */
- (void)UnionPayRechargeWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSString *tokenString, NSError *error))block;

@end
