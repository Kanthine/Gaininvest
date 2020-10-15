//
//  DemoData.h
//  GainInvest
//
//  Created by 苏沫离 on 2020/9/22.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConsultKindTitleModel.h"
#import "ConsultListModel.h"
#import "InorderModel.h"
#import "CouponModel.h"
#import "OrderInfoModel.h"
#import "MessageModel.h"
#import "ProductInfoModel.h"
#import "StockCurrentData.h"

NS_ASSUME_NONNULL_BEGIN

@interface DemoData : NSObject

///昵称
#define k_DemoData_nickName_count DemoData.nickNameArray.count
+ (NSArray<NSString *> *)nickNameArray;

///头像
#define k_DemoData_HeadPath_count DemoData.headPathArray.count
+ (NSArray<NSString *> *)headPathArray;

@end







/// 业务假数据
@interface DemoData (Service)

+ (NSMutableArray<ConsultKindTitleModel *> *)consultKindTitleArray;
+ (NSMutableArray<ConsultListModel *> *)ConsultListArrayWithKindTitle:(ConsultKindTitleModel *)titleModel;

+ (NSMutableArray<InorderModel *> *)inorderModelArray;

/** 查询用户可用的赢家券信息数量
 */
+ (NSInteger)queryCouponCount;

/** 查询用户所有的赢家券信息
 * coupon_type : 券类型 1：未使用 2：已使用 3：已过期
 */
+ (NSMutableArray<CouponModel *> *)couponArrayWithType:(NSString *)type;

/** 获取用户的持仓信息列表
 */
+ (NSMutableArray<OrderInfoModel *> *)accessOpenPosition;


/** 查询交易流水
 * type : top:查询止盈平仓流水，bot：查询止损平仓流水，de：查询爆仓平仓流水，cd：查询系统自动平仓流水，pn：查询建仓流水，cg：查询平仓流水，all：查询建仓和平仓流水",
 * st ：查询开始时间 格式: yyyy-MM-dd
 * et ：查询结束时间 格式: yyyy-MM-dd
 */
+ (NSMutableArray<OrderInfoModel *> *)accessTradeListWithParameterDict:(NSDictionary *)parameterDict;

/** 查询收支明细
 * type : top：查询止盈平仓流水，bot：查询止损平仓流水，de：查询爆仓平仓流水，cd：查询系统自动平仓流水，pn：查询建仓流水，cg：查询平仓流水，re:查询充值流水，wt：查询提现流水，"fd":" 查询提现失败流水" ，all：查询交易、充值和提现流水
 * st ：查询开始时间 格式: yyyy-MM-dd
 * et ：查询结束时间 格式: yyyy-MM-dd
 */
+ (NSMutableArray<OrderInfoModel *> *)accessIncomeDetaileListWithParameterDict:(NSDictionary *)parameterDict;

///银行列表
+ (NSMutableArray<NSDictionary *> *)bankList;


@end


NS_ASSUME_NONNULL_END
