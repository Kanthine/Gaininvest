//
//  OrderInfoModel.h
//  GainInvest
//
//  Created by   on 17/3/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//持仓数据
@class ProductInfoModel;
@interface OrderInfoModel : NSObject <NSCoding, NSCopying>

///YES 买跌 ， NO 买涨
@property (nonatomic, assign) BOOL isBuyDrop;

//是否使用优惠券
@property (nonatomic, assign) BOOL isUseCoupon;
@property (nonatomic, assign) NSInteger couponId;
@property (nonatomic, strong) NSString *couponName;

//止盈比例
@property (nonatomic, assign) float topLimit;
//止损比例
@property (nonatomic, assign) float bottomLimit;

///订单
@property (nonatomic, assign) NSInteger orderId;
///买了几手
@property (nonatomic, assign) NSInteger count;

///商品信息
@property (nonatomic, strong) ProductInfoModel *productInfo;

//买入
@property (nonatomic, assign) double buyPrice;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, assign) float fee;///手续费

//平仓
@property (nonatomic, assign) double sellPrice;
@property (nonatomic, strong) NSString *sellTime;

//浮动盈亏
@property (nonatomic, assign) float plAmount;

//建仓\平仓
@property (nonatomic, strong) NSString *remark;

//市盈率
@property (nonatomic, assign) double plRatio;
@property (nonatomic, strong) NSString *orderType;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end


@interface OrderInfoModel (Order)

- (NSString *)plAmountText;

///创建一个订单
+ (void)creatOrder:(OrderInfoModel *)order handler:(void(^)(BOOL isSuccess))block;

//平仓
- (void)closePosition;

@end


typedef NS_ENUM(NSUInteger ,OrderType) {
    OrderTypeAll = 0,
    OrderTypePosition,
    OrderTypeClosePosition,
};

@interface OrderInfoModel (FMDB)

+ (void)insertModel:(OrderInfoModel *)model;

+ (void)updateModel:(OrderInfoModel *)model;

///获取所有订单数据
+ (void)getModelsWithType:(OrderType)type handler:(void(^)(NSMutableArray<OrderInfoModel *> *modelsArray))block;

+ (void)getModelByOrderID:(NSInteger)orderId handler:(void(^)(OrderInfoModel *model))block;

@end

NS_ASSUME_NONNULL_END
