//
//  PositionsModel.m
//
//  Created by   on 17/3/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "PositionsModel.h"


NSString *const kPositionsModelPlRatio = @"plRatio";
NSString *const kPositionsModelBuyDirection = @"buyDirection";
NSString *const kPositionsModelWeight = @"weight";
NSString *const kPositionsModelSpec = @"spec";
NSString *const kPositionsModelCouponId = @"couponId";
NSString *const kPositionsModelBuyMoney = @"buyMoney";
NSString *const kPositionsModelDeficitPrice = @"deficitPrice";
NSString *const kPositionsModelBottomLimit = @"bottomLimit";
NSString *const kPositionsModelCount = @"count";
NSString *const kPositionsModelSellPrice = @"sellPrice";
NSString *const kPositionsModelOrderType = @"orderType";
NSString *const kPositionsModelFlag = @"flag";
NSString *const kPositionsModelOrderNum = @"orderNum";
NSString *const kPositionsModelProductId = @"productId";
NSString *const kPositionsModelBuyPrice = @"buyPrice";
NSString *const kPositionsModelBottomPrice = @"bottomPrice";
NSString *const kPositionsModelCouponFlag = @"couponFlag";
NSString *const kPositionsModelCouponName = @"couponName";
NSString *const kPositionsModelAddTime = @"addTime";
NSString *const kPositionsModelTopPrice = @"topPrice";
NSString *const kPositionsModelProDesc = @"proDesc";
NSString *const kPositionsModelWid = @"wid";
NSString *const kPositionsModelContract = @"contract";
NSString *const kPositionsModelTopLimit = @"topLimit";
NSString *const kPositionsModelFee = @"fee";
NSString *const kPositionsModelPlAmount = @"plAmount";
NSString *const kPositionsModelPrice = @"price";
NSString *const kPositionsModelProductName = @"productName";
NSString *const kPositionsModelOrderId = @"orderId";


@interface PositionsModel ()

@property (nonatomic, assign) double topPrice;
@property (nonatomic, assign) double bottomPrice;

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PositionsModel

@synthesize plRatio = _plRatio;
@synthesize isBuyDrop = _isBuyDrop;
@synthesize couponId = _couponId;
@synthesize buyMoney = _buyMoney;
@synthesize deficitPrice = _deficitPrice;
@synthesize bottomLimit = _bottomLimit;
@synthesize count = _count;
@synthesize sellPrice = _sellPrice;
@synthesize orderType = _orderType;
@synthesize flag = _flag;
@synthesize orderNum = _orderNum;
@synthesize buyPrice = _buyPrice;
@synthesize bottomPrice = _bottomPrice;
@synthesize isUseCoupon = _isUseCoupon;
@synthesize couponName = _couponName;
@synthesize addTime = _addTime;
@synthesize topPrice = _topPrice;
@synthesize proDesc = _proDesc;
@synthesize wid = _wid;
@synthesize topLimit = _topLimit;
@synthesize fee = _fee;
@synthesize plAmount = _plAmount;
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
            self.plRatio = [[self objectOrNilForKey:kPositionsModelPlRatio fromDictionary:dict] doubleValue];
            self.isBuyDrop = [[self objectOrNilForKey:kPositionsModelBuyDirection fromDictionary:dict] boolValue];
            self.couponId = [[self objectOrNilForKey:kPositionsModelCouponId fromDictionary:dict] doubleValue];
            self.buyMoney = [[self objectOrNilForKey:kPositionsModelBuyMoney fromDictionary:dict] doubleValue];
            self.deficitPrice = [[self objectOrNilForKey:kPositionsModelDeficitPrice fromDictionary:dict] doubleValue];
            self.bottomLimit = [[self objectOrNilForKey:kPositionsModelBottomLimit fromDictionary:dict] doubleValue];
            self.count = [[self objectOrNilForKey:kPositionsModelCount fromDictionary:dict] doubleValue];
            self.sellPrice = [[self objectOrNilForKey:kPositionsModelSellPrice fromDictionary:dict] doubleValue];
            self.orderType = [[self objectOrNilForKey:kPositionsModelOrderType fromDictionary:dict] doubleValue];
            self.flag = [[self objectOrNilForKey:kPositionsModelFlag fromDictionary:dict] doubleValue];
            self.orderNum = [self objectOrNilForKey:kPositionsModelOrderNum fromDictionary:dict];
            self.buyPrice = [[self objectOrNilForKey:kPositionsModelBuyPrice fromDictionary:dict] doubleValue];
            self.bottomPrice = [[self objectOrNilForKey:kPositionsModelBottomPrice fromDictionary:dict] doubleValue];
            self.isUseCoupon = [[self objectOrNilForKey:kPositionsModelCouponFlag fromDictionary:dict] boolValue];
            self.couponName = [self objectOrNilForKey:kPositionsModelCouponName fromDictionary:dict];
            self.addTime = [self objectOrNilForKey:kPositionsModelAddTime fromDictionary:dict];
            self.topPrice = [[self objectOrNilForKey:kPositionsModelTopPrice fromDictionary:dict] doubleValue];
            self.proDesc = [self objectOrNilForKey:kPositionsModelProDesc fromDictionary:dict];
            self.wid = [self objectOrNilForKey:kPositionsModelWid fromDictionary:dict];
            self.topLimit = [[self objectOrNilForKey:kPositionsModelTopLimit fromDictionary:dict] doubleValue];
            self.fee = [[self objectOrNilForKey:kPositionsModelFee fromDictionary:dict] doubleValue];
            self.plAmount = [[self objectOrNilForKey:kPositionsModelPlAmount fromDictionary:dict] doubleValue];
            self.orderId = [[self objectOrNilForKey:kPositionsModelOrderId fromDictionary:dict] doubleValue];
    }
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.plRatio] forKey:kPositionsModelPlRatio];
    [mutableDict setValue:@(self.isBuyDrop) forKey:kPositionsModelBuyDirection];
    [mutableDict setValue:[NSNumber numberWithDouble:self.couponId] forKey:kPositionsModelCouponId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyMoney] forKey:kPositionsModelBuyMoney];
    [mutableDict setValue:[NSNumber numberWithDouble:self.deficitPrice] forKey:kPositionsModelDeficitPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.bottomLimit] forKey:kPositionsModelBottomLimit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.count] forKey:kPositionsModelCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sellPrice] forKey:kPositionsModelSellPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderType] forKey:kPositionsModelOrderType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.flag] forKey:kPositionsModelFlag];
    [mutableDict setValue:self.orderNum forKey:kPositionsModelOrderNum];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyPrice] forKey:kPositionsModelBuyPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.bottomPrice] forKey:kPositionsModelBottomPrice];
    [mutableDict setValue:@(self.isUseCoupon) forKey:kPositionsModelCouponFlag];
    [mutableDict setValue:self.couponName forKey:kPositionsModelCouponName];
    [mutableDict setValue:self.addTime forKey:kPositionsModelAddTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.topPrice] forKey:kPositionsModelTopPrice];
    [mutableDict setValue:self.proDesc forKey:kPositionsModelProDesc];
    [mutableDict setValue:self.wid forKey:kPositionsModelWid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.topLimit] forKey:kPositionsModelTopLimit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fee] forKey:kPositionsModelFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.plAmount] forKey:kPositionsModelPlAmount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderId] forKey:kPositionsModelOrderId];

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

    self.plRatio = [aDecoder decodeDoubleForKey:kPositionsModelPlRatio];
    self.isBuyDrop = [aDecoder decodeBoolForKey:kPositionsModelBuyDirection];
    self.couponId = [aDecoder decodeDoubleForKey:kPositionsModelCouponId];
    self.buyMoney = [aDecoder decodeDoubleForKey:kPositionsModelBuyMoney];
    self.deficitPrice = [aDecoder decodeDoubleForKey:kPositionsModelDeficitPrice];
    self.bottomLimit = [aDecoder decodeDoubleForKey:kPositionsModelBottomLimit];
    self.count = [aDecoder decodeDoubleForKey:kPositionsModelCount];
    self.sellPrice = [aDecoder decodeDoubleForKey:kPositionsModelSellPrice];
    self.orderType = [aDecoder decodeDoubleForKey:kPositionsModelOrderType];
    self.flag = [aDecoder decodeDoubleForKey:kPositionsModelFlag];
    self.orderNum = [aDecoder decodeObjectForKey:kPositionsModelOrderNum];
    self.buyPrice = [aDecoder decodeDoubleForKey:kPositionsModelBuyPrice];
    self.bottomPrice = [aDecoder decodeDoubleForKey:kPositionsModelBottomPrice];
    self.isUseCoupon = [aDecoder decodeBoolForKey:kPositionsModelCouponFlag];
    self.couponName = [aDecoder decodeObjectForKey:kPositionsModelCouponName];
    self.addTime = [aDecoder decodeObjectForKey:kPositionsModelAddTime];
    self.topPrice = [aDecoder decodeDoubleForKey:kPositionsModelTopPrice];
    self.proDesc = [aDecoder decodeObjectForKey:kPositionsModelProDesc];
    self.wid = [aDecoder decodeObjectForKey:kPositionsModelWid];
    self.topLimit = [aDecoder decodeDoubleForKey:kPositionsModelTopLimit];
    self.fee = [aDecoder decodeDoubleForKey:kPositionsModelFee];
    self.plAmount = [aDecoder decodeDoubleForKey:kPositionsModelPlAmount];
    self.orderId = [aDecoder decodeDoubleForKey:kPositionsModelOrderId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_plRatio forKey:kPositionsModelPlRatio];
    [aCoder encodeBool:_isBuyDrop forKey:kPositionsModelBuyDirection];
    [aCoder encodeDouble:_couponId forKey:kPositionsModelCouponId];
    [aCoder encodeDouble:_buyMoney forKey:kPositionsModelBuyMoney];
    [aCoder encodeDouble:_deficitPrice forKey:kPositionsModelDeficitPrice];
    [aCoder encodeDouble:_bottomLimit forKey:kPositionsModelBottomLimit];
    [aCoder encodeDouble:_count forKey:kPositionsModelCount];
    [aCoder encodeDouble:_sellPrice forKey:kPositionsModelSellPrice];
    [aCoder encodeDouble:_orderType forKey:kPositionsModelOrderType];
    [aCoder encodeDouble:_flag forKey:kPositionsModelFlag];
    [aCoder encodeObject:_orderNum forKey:kPositionsModelOrderNum];
    [aCoder encodeDouble:_buyPrice forKey:kPositionsModelBuyPrice];
    [aCoder encodeDouble:_bottomPrice forKey:kPositionsModelBottomPrice];
    [aCoder encodeBool:_isUseCoupon forKey:kPositionsModelCouponFlag];
    [aCoder encodeObject:_couponName forKey:kPositionsModelCouponName];
    [aCoder encodeObject:_addTime forKey:kPositionsModelAddTime];
    [aCoder encodeDouble:_topPrice forKey:kPositionsModelTopPrice];
    [aCoder encodeObject:_proDesc forKey:kPositionsModelProDesc];
    [aCoder encodeObject:_wid forKey:kPositionsModelWid];
    [aCoder encodeDouble:_topLimit forKey:kPositionsModelTopLimit];
    [aCoder encodeDouble:_fee forKey:kPositionsModelFee];
    [aCoder encodeDouble:_plAmount forKey:kPositionsModelPlAmount];
    [aCoder encodeDouble:_orderId forKey:kPositionsModelOrderId];
}

- (id)copyWithZone:(NSZone *)zone{
    PositionsModel *copy = [[PositionsModel alloc] init];
    
    if (copy) {

        copy.plRatio = self.plRatio;
        copy.isBuyDrop = self.isBuyDrop;
        copy.couponId = self.couponId;
        copy.buyMoney = self.buyMoney;
        copy.deficitPrice = self.deficitPrice;
        copy.bottomLimit = self.bottomLimit;
        copy.count = self.count;
        copy.sellPrice = self.sellPrice;
        copy.orderType = self.orderType;
        copy.flag = self.flag;
        copy.orderNum = [self.orderNum copyWithZone:zone];
        copy.buyPrice = self.buyPrice;
        copy.bottomPrice = self.bottomPrice;
        copy.isUseCoupon = self.isUseCoupon;
        copy.couponName = [self.couponName copyWithZone:zone];
        copy.addTime = [self.addTime copyWithZone:zone];
        copy.topPrice = self.topPrice;
        copy.proDesc = [self.proDesc copyWithZone:zone];
        copy.wid = [self.wid copyWithZone:zone];
        copy.topLimit = self.topLimit;
        copy.fee = self.fee;
        copy.plAmount = self.plAmount;
        copy.orderId = self.orderId;
    }
    
    return copy;
}


@end
