//
//  RequestURL.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/9.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#ifndef RequestURL_h
#define RequestURL_h


//http://www.wintz.cn/sure_api/shop 接口文档


#define TimeOutInterval 19.0f  //网络请求时间

#define DOMAINBASE @"http://www.wintz.cn"
//#define DOMAINBASE @"http://ying.dt87.cn"
#define PublicInterface @"/api/sureapi/sure_common"
#define PrivateInterface @"/api/sureapi/sure_security"


#pragma mark - Public 

#define IsJudgeOpenAccount @"check_phone_trade"//获取是否开户
#define GetVerificationCode @"get_code"//获取验证码
#define GetTradeVerificationCode @"get_code_trade"//获取交易验证码
#define RegisterUser @"register"//注册
#define LoginUser @"login"//登录
#define ThirdLogin @"third_login"//第三方登录
#define BindMobile @"bind_mobile_phone"//绑定手机号
#define TradeLogin @"login_trade"//交易登录
#define ResetPassword @"change_password"//重置密码
#define ResetTransactionPassword @"change_password_trade"//重置交易密码
#define SetTransactionPassword @"register_trade"//设置交易密码


#define ConsultList @"getby_typeid_lists"//咨询列表
#define ConsultKind @"get_all_types"//咨询分类
#define HomeBanner @"index_banner"//咨询分类

#define BankList @"bank_list"//银行列表
#define AreaList @"get_area_list"//银行列表


#define AccessToMarketQuotation @"get_quote" //获取行情报价
#define AccessK_TimeLineChart @"get_k_line" //k-线图

#define AccessKProductList @"get_product_list"//获取产品列表
#define AccessBuyUpOrDown @"count_updown"//用户涨跌比例
#define InorderList @"show_order" //晒单列表


#pragma mark - Private


#define UpdateUserInfo @"update_user_info"//修改个人信息
#define BalanceOfAccount @"get_user_balance_tread"//获取用户余额
#define FeedBackProblem  @"feedback_add"//问题反馈
#define Withdraw  @"union_pay_withdraw"//提现
#define WithdrawBankCardUpdate  @"update_member_card_out"//提现卡信息修改
#define WithdrawBankCardInfo  @"member_card_out_view"//提现卡信息
#define UpdateServerBankCard  @"update_card_binded"//更改服务器信息
#define ShareGetVoucher  @"share"//分享领代金券
#define CouponList @"get_user_coupon_list"//代金券列表
#define CouponNumber @"get_user_deff_coupon_list"//获取不同(可用)券的数量 

#define JingDongSignatoryOnline  @"jd_pay_sign"//京东在线签约
#define JingDongPay  @"jd_pay"//京东支付
#define UnionPayRecharge  @"union_pay_recharge"//银联充值


#define OpenPosition @"create_order"//建仓
#define OpenPositionList @"get_user_position_list"//获取用户的持仓信息列表
#define UpdatePositionGainOrLoss @"update_order"//修改止盈止损
#define ClosePosition @"close_order"//手动平仓
#define TradeList @"query_order_list"//查询交易流水
#define IncomeDetaileList @"query_money_list" //查询交易明细

#define InorderToShare @"update_show" //晒单



#endif /* RequestURL_h */
