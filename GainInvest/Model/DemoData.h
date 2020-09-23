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
NS_ASSUME_NONNULL_BEGIN

@interface DemoData : NSObject

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


@end



NS_ASSUME_NONNULL_END
