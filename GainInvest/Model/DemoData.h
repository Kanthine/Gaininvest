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
#import "PositionsModel.h"

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

/** 时分图假数据
 * type : K线数据类型
 *      1：1分时图
 *      2：5分钟K线图;
 *      3：15分钟K线图;
 *      4：30分钟K线图;
 *      5：1小时K线图"
 */
+ (NSMutableArray<NSString *> *)timeLineChartDatasWithType:(NSString *)type;
+ (NSMutableArray<NSString *> *)timeDatesWithType:(NSString *)type;




/** 查询用户可用的赢家券信息数量
 */
+ (NSInteger)queryCouponCount;

/** 查询用户所有的赢家券信息
 * coupon_type : 券类型 1：未使用 2：已使用 3：已过期
 */
+ (NSMutableArray<CouponModel *> *)couponArrayWithType:(NSString *)type;

/** 获取用户的持仓信息列表
 */
+ (NSMutableArray<PositionsModel *> *)accessOpenPosition;

@end


NS_ASSUME_NONNULL_END
