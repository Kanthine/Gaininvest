//
//  PositionsModel.h
//
//  Created by   on 17/3/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//持仓数据
@interface PositionsModel : NSObject <NSCoding, NSCopying>

///YES 买跌 ， NO 买涨
@property (nonatomic, assign) BOOL buyDirection;
//是否使用优惠券
@property (nonatomic, assign) BOOL couponFlag;

//盈止损点
@property (nonatomic, assign) double topLimit;
@property (nonatomic, assign) double bottomLimit;

///订单
@property (nonatomic, assign) NSInteger orderId;

@property (nonatomic, assign) double plRatio;
@property (nonatomic, assign) double weight;
@property (nonatomic, strong) NSString *spec;
@property (nonatomic, assign) double couponId;
@property (nonatomic, assign) double buyMoney;
@property (nonatomic, assign) double deficitPrice;
@property (nonatomic, assign) double count;
@property (nonatomic, assign) double sellPrice;
@property (nonatomic, assign) double orderType;
@property (nonatomic, assign) double flag;
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, assign) double productId;
@property (nonatomic, assign) double buyPrice;
@property (nonatomic, assign) double bottomPrice;
@property (nonatomic, strong) NSString *couponName;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, assign) double topPrice;
@property (nonatomic, strong) NSString *proDesc;
@property (nonatomic, strong) NSString *wid;
@property (nonatomic, strong) NSString *contract;
@property (nonatomic, assign) double fee;
@property (nonatomic, assign) double plAmount;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSString *productName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
