//
//  TradeModel.h
//
//  Created by   on 17/3/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TradeModel : NSObject <NSCoding, NSCopying>

///YES 买跌 ， NO 买涨
@property (nonatomic, assign) BOOL isBuyDrop;
//是否使用优惠券
@property (nonatomic, assign) BOOL isUseCoupon;
@property (nonatomic, assign) double buyPrice;//买入价
@property (nonatomic, strong) NSString *addTime;//买入时间
@property (nonatomic, assign) double sellPrice;//平仓价
@property (nonatomic, strong) NSString *sellTime;//平仓时间
//浮动盈亏
@property (nonatomic, assign) double plAmount;
//手续费
@property (nonatomic, assign) double fee;
//建仓\平仓
@property (nonatomic, strong) NSString *remark;
//订单号
@property (nonatomic, assign) NSInteger orderId;
//买入数量
@property (nonatomic, assign) NSInteger count;
//商品描述：白银、黄金、钻石
@property (nonatomic, strong) NSString *proDesc;

@property (nonatomic, assign) double money;
@property (nonatomic, assign) double weight;
@property (nonatomic, strong) NSString *spec;
@property (nonatomic, assign) double payType;
@property (nonatomic, assign) double buyMoney;
@property (nonatomic, assign) double reType;
@property (nonatomic, assign) double orderType;
@property (nonatomic, assign) double productId;
@property (nonatomic, assign) double balance;



+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
