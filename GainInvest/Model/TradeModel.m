//
//  TradeModel.m
//
//  Created by   on 17/3/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "TradeModel.h"


NSString *const kTradeModelBuyDirection = @"buyDirection";
NSString *const kTradeModelSellTime = @"sellTime";
NSString *const kTradeModelMoney = @"money";
NSString *const kTradeModelWeight = @"weight";
NSString *const kTradeModelSpec = @"spec";
NSString *const kTradeModelPayType = @"payType";
NSString *const kTradeModelBuyMoney = @"buyMoney";
NSString *const kTradeModelCount = @"count";
NSString *const kTradeModelSellPrice = @"sellPrice";
NSString *const kTradeModelReType = @"reType";
NSString *const kTradeModelOrderType = @"orderType";
NSString *const kTradeModelProductId = @"productId";
NSString *const kTradeModelBalance = @"balance";
NSString *const kTradeModelBuyPrice = @"buyPrice";
NSString *const kTradeModelCouponFlag = @"couponFlag";
NSString *const kTradeModelAddTime = @"addTime";
NSString *const kTradeModelProDesc = @"proDesc";
NSString *const kTradeModelPlAmount = @"plAmount";
NSString *const kTradeModelFee = @"fee";
NSString *const kTradeModelRemark = @"remark";
NSString *const kTradeModelOrderId = @"orderId";


@interface TradeModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TradeModel

@synthesize isBuyDrop = _isBuyDrop;
@synthesize sellTime = _sellTime;
@synthesize money = _money;
@synthesize weight = _weight;
@synthesize spec = _spec;
@synthesize payType = _payType;
@synthesize buyMoney = _buyMoney;
@synthesize count = _count;
@synthesize sellPrice = _sellPrice;
@synthesize reType = _reType;
@synthesize orderType = _orderType;
@synthesize productId = _productId;
@synthesize balance = _balance;
@synthesize buyPrice = _buyPrice;
@synthesize isUseCoupon = _isUseCoupon;
@synthesize addTime = _addTime;
@synthesize proDesc = _proDesc;
@synthesize plAmount = _plAmount;
@synthesize fee = _fee;
@synthesize remark = _remark;
@synthesize orderId = _orderId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.isBuyDrop = [[self objectOrNilForKey:kTradeModelBuyDirection fromDictionary:dict] boolValue];
            self.sellTime = [self objectOrNilForKey:kTradeModelSellTime fromDictionary:dict];
            self.money = [[self objectOrNilForKey:kTradeModelMoney fromDictionary:dict] doubleValue];
            self.weight = [[self objectOrNilForKey:kTradeModelWeight fromDictionary:dict] doubleValue];
            self.spec = [self objectOrNilForKey:kTradeModelSpec fromDictionary:dict];
            self.payType = [[self objectOrNilForKey:kTradeModelPayType fromDictionary:dict] doubleValue];
            self.buyMoney = [[self objectOrNilForKey:kTradeModelBuyMoney fromDictionary:dict] doubleValue];
            self.count = [[self objectOrNilForKey:kTradeModelCount fromDictionary:dict] doubleValue];
            self.sellPrice = [[self objectOrNilForKey:kTradeModelSellPrice fromDictionary:dict] doubleValue];
            self.reType = [[self objectOrNilForKey:kTradeModelReType fromDictionary:dict] doubleValue];
            self.orderType = [[self objectOrNilForKey:kTradeModelOrderType fromDictionary:dict] doubleValue];
            self.productId = [[self objectOrNilForKey:kTradeModelProductId fromDictionary:dict] doubleValue];
            self.balance = [[self objectOrNilForKey:kTradeModelBalance fromDictionary:dict] doubleValue];
            self.buyPrice = [[self objectOrNilForKey:kTradeModelBuyPrice fromDictionary:dict] doubleValue];
            self.isUseCoupon = [[self objectOrNilForKey:kTradeModelCouponFlag fromDictionary:dict] boolValue];
            self.addTime = [self objectOrNilForKey:kTradeModelAddTime fromDictionary:dict];
            self.proDesc = [self objectOrNilForKey:kTradeModelProDesc fromDictionary:dict];
            self.plAmount = [[self objectOrNilForKey:kTradeModelPlAmount fromDictionary:dict] doubleValue];
            self.fee = [[self objectOrNilForKey:kTradeModelFee fromDictionary:dict] doubleValue];
            self.remark = [self objectOrNilForKey:kTradeModelRemark fromDictionary:dict];
            self.orderId = [[self objectOrNilForKey:kTradeModelOrderId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:@(self.isBuyDrop) forKey:kTradeModelBuyDirection];
    [mutableDict setValue:self.sellTime forKey:kTradeModelSellTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.money] forKey:kTradeModelMoney];
    [mutableDict setValue:[NSNumber numberWithDouble:self.weight] forKey:kTradeModelWeight];
    [mutableDict setValue:self.spec forKey:kTradeModelSpec];
    [mutableDict setValue:[NSNumber numberWithDouble:self.payType] forKey:kTradeModelPayType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyMoney] forKey:kTradeModelBuyMoney];
    [mutableDict setValue:[NSNumber numberWithDouble:self.count] forKey:kTradeModelCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sellPrice] forKey:kTradeModelSellPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.reType] forKey:kTradeModelReType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderType] forKey:kTradeModelOrderType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.productId] forKey:kTradeModelProductId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.balance] forKey:kTradeModelBalance];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyPrice] forKey:kTradeModelBuyPrice];
    [mutableDict setValue:@(self.isUseCoupon) forKey:kTradeModelCouponFlag];
    [mutableDict setValue:self.addTime forKey:kTradeModelAddTime];
    [mutableDict setValue:self.proDesc forKey:kTradeModelProDesc];
    [mutableDict setValue:[NSNumber numberWithDouble:self.plAmount] forKey:kTradeModelPlAmount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fee] forKey:kTradeModelFee];
    [mutableDict setValue:self.remark forKey:kTradeModelRemark];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderId] forKey:kTradeModelOrderId];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.isUseCoupon = [aDecoder decodeBoolForKey:kTradeModelCouponFlag];
    self.isBuyDrop = [aDecoder decodeBoolForKey:kTradeModelBuyDirection];
    self.sellTime = [aDecoder decodeObjectForKey:kTradeModelSellTime];
    self.money = [aDecoder decodeDoubleForKey:kTradeModelMoney];
    self.weight = [aDecoder decodeDoubleForKey:kTradeModelWeight];
    self.spec = [aDecoder decodeObjectForKey:kTradeModelSpec];
    self.payType = [aDecoder decodeDoubleForKey:kTradeModelPayType];
    self.buyMoney = [aDecoder decodeDoubleForKey:kTradeModelBuyMoney];
    self.count = [aDecoder decodeDoubleForKey:kTradeModelCount];
    self.sellPrice = [aDecoder decodeDoubleForKey:kTradeModelSellPrice];
    self.reType = [aDecoder decodeDoubleForKey:kTradeModelReType];
    self.orderType = [aDecoder decodeDoubleForKey:kTradeModelOrderType];
    self.productId = [aDecoder decodeDoubleForKey:kTradeModelProductId];
    self.balance = [aDecoder decodeDoubleForKey:kTradeModelBalance];
    self.buyPrice = [aDecoder decodeDoubleForKey:kTradeModelBuyPrice];
    self.addTime = [aDecoder decodeObjectForKey:kTradeModelAddTime];
    self.proDesc = [aDecoder decodeObjectForKey:kTradeModelProDesc];
    self.plAmount = [aDecoder decodeDoubleForKey:kTradeModelPlAmount];
    self.fee = [aDecoder decodeDoubleForKey:kTradeModelFee];
    self.remark = [aDecoder decodeObjectForKey:kTradeModelRemark];
    self.orderId = [aDecoder decodeDoubleForKey:kTradeModelOrderId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:_isUseCoupon forKey:kTradeModelCouponFlag];
    [aCoder encodeBool:_isBuyDrop forKey:kTradeModelBuyDirection];
    [aCoder encodeObject:_sellTime forKey:kTradeModelSellTime];
    [aCoder encodeDouble:_money forKey:kTradeModelMoney];
    [aCoder encodeDouble:_weight forKey:kTradeModelWeight];
    [aCoder encodeObject:_spec forKey:kTradeModelSpec];
    [aCoder encodeDouble:_payType forKey:kTradeModelPayType];
    [aCoder encodeDouble:_buyMoney forKey:kTradeModelBuyMoney];
    [aCoder encodeDouble:_count forKey:kTradeModelCount];
    [aCoder encodeDouble:_sellPrice forKey:kTradeModelSellPrice];
    [aCoder encodeDouble:_reType forKey:kTradeModelReType];
    [aCoder encodeDouble:_orderType forKey:kTradeModelOrderType];
    [aCoder encodeDouble:_productId forKey:kTradeModelProductId];
    [aCoder encodeDouble:_balance forKey:kTradeModelBalance];
    [aCoder encodeDouble:_buyPrice forKey:kTradeModelBuyPrice];
    [aCoder encodeObject:_addTime forKey:kTradeModelAddTime];
    [aCoder encodeObject:_proDesc forKey:kTradeModelProDesc];
    [aCoder encodeDouble:_plAmount forKey:kTradeModelPlAmount];
    [aCoder encodeDouble:_fee forKey:kTradeModelFee];
    [aCoder encodeObject:_remark forKey:kTradeModelRemark];
    [aCoder encodeDouble:_orderId forKey:kTradeModelOrderId];
}

- (id)copyWithZone:(NSZone *)zone
{
    TradeModel *copy = [[TradeModel alloc] init];
    
    if (copy) {

        copy.isBuyDrop = self.isBuyDrop;
        copy.sellTime = [self.sellTime copyWithZone:zone];
        copy.money = self.money;
        copy.weight = self.weight;
        copy.spec = [self.spec copyWithZone:zone];
        copy.payType = self.payType;
        copy.buyMoney = self.buyMoney;
        copy.count = self.count;
        copy.sellPrice = self.sellPrice;
        copy.reType = self.reType;
        copy.orderType = self.orderType;
        copy.productId = self.productId;
        copy.balance = self.balance;
        copy.buyPrice = self.buyPrice;
        copy.isUseCoupon = self.isUseCoupon;
        copy.addTime = [self.addTime copyWithZone:zone];
        copy.proDesc = [self.proDesc copyWithZone:zone];
        copy.plAmount = self.plAmount;
        copy.fee = self.fee;
        copy.remark = [self.remark copyWithZone:zone];
        copy.orderId = self.orderId;
    }
    
    return copy;
}


@end
