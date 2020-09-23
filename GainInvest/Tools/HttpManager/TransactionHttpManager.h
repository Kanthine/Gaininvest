//
//  TransactionHttpManager.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/27.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionHttpManager : NSObject

/** 获取用户是否开户
 */
+ (void)isJudgeOpenAccountCompletionBlock:(void (^) (BOOL isOpen))block;


/*
 * 交易登录（令牌失效）
 */
- (void)tradeLoginWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSString *urlString,NSError *error))block;


/** 获取用户余额
 * mobile_phone : 手机号
 */
- (void)accessBalanceOfAccountWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSString *urlString,NSError *error))block;


/** 获取银行列表
 */
- (void)getBankListCompletionBlock:(void (^) (NSMutableArray<NSDictionary *> *listArray,NSError *error))block;

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

/*
 * 获取行情报价
 */
- (void)accessToMarketQuotationCompletionBlock:(void (^)(NSDictionary *resultDict, NSError *error))block;

/*
 * 获取K-线图
 * contract :商品符号  HGAG
 * type : K线数据类型
 *      1：1分时图
 *      2：5分钟K线图;
 *      3：15分钟K线图;
 *      4：30分钟K线图;
 *      5：1小时K线图"
 *
 */
- (void)accessK_TimeLineChartWithParameterDict:(NSDictionary *)parameterDict  CompletionBlock:(void (^)(NSDictionary *resultDict, NSError *error))block;


/*
 * 获取产品列表
 */
- (void)accessProductListCompletionBlock:(void (^)(NSDictionary *resultDict, NSError *error))block;

/*
 * 获取买涨买跌比例
 */
- (void)accessBuyUpOrDownCompletionBlock:(void (^)(NSDictionary *resultDict, NSError *error))block;

/*
 * 建仓
 *
 * mobile_phone：手机号
 * product_id ：产品Id
 * contract ：合同
 * type ：方向 1涨2跌
 * sl ：手数 最大10手
 * is_juan ： 是否使用券 1使用0不使用
 * top_limit ：止盈比例 默认是0
 * bottom_limit ： 止损比例 默认是0
 */
- (void)openPositionWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSDictionary *resultDict, NSError *error))block;

/*
 * 获取用户的持仓信息列表
 *
 * mobile_phone：手机号
 */
- (void)accessOpenPositionListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSMutableArray<PositionsModel *> *listArray, NSError *error))block;


/*
 * 修改持仓的止盈止损点
 *
 * mobile_phone：手机号
 * order_id ：订单号
 * contract ：商品符号
 * top_limit ：止盈比例
 * bottom_limit ：止损比例
 */
- (void)updatePositionGainOrLossWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSMutableArray<PositionsModel *> *listArray, NSError *error))block;

/** 平仓
 *
 * mobile_phone：手机号
 * order_id ：订单号
 * contract ：商品符号
 */
- (void)closePositionWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSMutableArray<PositionsModel *> *listArray, NSError *error))block;


/*
 * 查询交易流水
 * cur_page : 开始条数(默认0)*
 * cur_size : 结束条数(默认20)
 * mobile_phone：手机号
 * type : top:查询止盈平仓流水，bot：查询止损平仓流水，de：查询爆仓平仓流水，cd：查询系统自动平仓流水，pn：查询建仓流水，cg：查询平仓流水，all：查询建仓和平仓流水",  
 * st ：查询开始时间 格式: yyyy-MM-dd
 * et ：查询结束时间 格式: yyyy-MM-dd
 */
- (void)accessTradeListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSMutableArray<TradeModel *> *listArray, NSError *error))block;

/*
 * 查询收支明细
 * cur_page : 开始条数(默认0)*
 * cur_size : 结束条数(默认20)
 * mobile_phone：手机号
 * type : top：查询止盈平仓流水，bot：查询止损平仓流水，de：查询爆仓平仓流水，cd：查询系统自动平仓流水，pn：查询建仓流水，cg：查询平仓流水，re:查询充值流水，wt：查询提现流水，"fd":" 查询提现失败流水" ，all：查询交易、充值和提现流水
 * st ：查询开始时间 格式: yyyy-MM-dd
 * et ：查询结束时间 格式: yyyy-MM-dd
 */
- (void)accessIncomeDetaileListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSMutableArray<TradeModel *> *listArray, NSError *error))block;

/*
 * 查询用户可用的赢家券信息数量
 * mobile_phone：手机号
 */
- (void)queryCouponCountCompletionBlock:(void (^)(NSUInteger count))block;

/*
 * 查询用户所有的赢家券信息
 * cur_page : 开始条数(默认0)*
 * cur_size : 结束条数(默认20)
 * coupon_type : 券类型 1：未使用 2：已使用 3：已过期
 * mobile_phone：手机号
 */
- (void)accessCouponListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSMutableArray<CouponModel *> *listArray, NSError *error))block;

@end
