//
//  PositionsModel.h
//
//  Created by   on 17/3/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//持仓数据
@class CommodityInfoModel;
@interface PositionsModel : NSObject <NSCoding, NSCopying>

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
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, assign) float fee;

///商品信息
@property (nonatomic, strong) CommodityInfoModel *productInfo;

//商品描述：白银、黄金、钻石
@property (nonatomic, strong) NSString *proDesc;

///买了几手
@property (nonatomic, assign) NSInteger count;

//买入
@property (nonatomic, assign) double buyMoney;
@property (nonatomic, assign) double buyPrice;
@property (nonatomic, strong) NSString *addTime;

//平仓
@property (nonatomic, assign) double sellPrice;
@property (nonatomic, strong) NSString *sellTime;

//浮动盈亏
@property (nonatomic, assign) float plAmount;

//建仓\平仓
@property (nonatomic, strong) NSString *remark;


@property (nonatomic, assign) double deficitPrice;


@property (nonatomic, assign) double plRatio;
@property (nonatomic, assign) double orderType;
@property (nonatomic, assign) double flag;
@property (nonatomic, strong) NSString *wid;
@property (nonatomic, assign) double balance;



+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
