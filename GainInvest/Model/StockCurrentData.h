//
//  StockCurrentData.h
//
//  Created by   on 17/2/10
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface StockCurrentData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *high;///最高价
@property (nonatomic, strong) NSString *low;///最低价
@property (nonatomic, strong) NSString *preClose;///昨日收盘价
@property (nonatomic, strong) NSString *open;///今日开盘价
@property (nonatomic, strong) NSString *quote;///当前价


@property (nonatomic ,strong) NSMutableArray<NSString *> *dataArray;
@property (nonatomic ,strong) NSMutableArray<NSString *> *dateArray;
@property (nonatomic ,strong) NSTimer *timer;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end


@interface StockCurrentData (Serve)



+ (instancetype)currentStock;

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
