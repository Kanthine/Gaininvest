//
//  InorderModel.m
//
//  Created by   on 17/3/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "InorderModel.h"


NSString *const kInorderModelBuyDirection = @"buyDirection";
NSString *const kInorderModelOrderType = @"order_type";
NSString *const kInorderModelSellTime = @"sellTime";
NSString *const kInorderModelHeadImg = @"head_img";
NSString *const kInorderModelMobile = @"mobile";
NSString *const kInorderModelCount = @"count";
NSString *const kInorderModelPlAmount = @"plAmount";
NSString *const kInorderModelSellPrice = @"sellPrice";
NSString *const kInorderModelPrice = @"price";
NSString *const kInorderModelPlPercent = @"plPercent";
NSString *const kInorderModelOrderId = @"orderId";
NSString *const kInorderModelAddTime = @"addTime";
NSString *const kInorderModelBuyPrice = @"buyPrice";
NSString *const kInorderModelMemberHeadimg = @"member_headimg";


@interface InorderModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation InorderModel

@synthesize buyDirection = _buyDirection;
@synthesize orderType = _orderType;
@synthesize sellTime = _sellTime;
@synthesize headImg = _headImg;
@synthesize mobile = _mobile;
@synthesize count = _count;
@synthesize plAmount = _plAmount;
@synthesize sellPrice = _sellPrice;
@synthesize price = _price;
@synthesize plPercent = _plPercent;
@synthesize orderId = _orderId;
@synthesize addTime = _addTime;
@synthesize buyPrice = _buyPrice;
@synthesize memberHeadimg = _memberHeadimg;


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
            self.buyDirection = [self objectOrNilForKey:kInorderModelBuyDirection fromDictionary:dict];
            self.orderType = [self objectOrNilForKey:kInorderModelOrderType fromDictionary:dict];
            self.sellTime = [self objectOrNilForKey:kInorderModelSellTime fromDictionary:dict];
            self.headImg = [self objectOrNilForKey:kInorderModelHeadImg fromDictionary:dict];
            self.mobile = [self objectOrNilForKey:kInorderModelMobile fromDictionary:dict];
            self.count = [self objectOrNilForKey:kInorderModelCount fromDictionary:dict];
            self.plAmount = [self objectOrNilForKey:kInorderModelPlAmount fromDictionary:dict];
            self.sellPrice = [self objectOrNilForKey:kInorderModelSellPrice fromDictionary:dict];
            self.price = [self objectOrNilForKey:kInorderModelPrice fromDictionary:dict];
            self.plPercent = [self objectOrNilForKey:kInorderModelPlPercent fromDictionary:dict];
            self.orderId = [self objectOrNilForKey:kInorderModelOrderId fromDictionary:dict];
            self.addTime = [self objectOrNilForKey:kInorderModelAddTime fromDictionary:dict];
            self.buyPrice = [self objectOrNilForKey:kInorderModelBuyPrice fromDictionary:dict];
            self.memberHeadimg = [self objectOrNilForKey:kInorderModelMemberHeadimg fromDictionary:dict];
        
        
        
        if (self.headImg == nil || self.headImg.length < 1)
        {
            self.headImg = self.memberHeadimg;
        }

        
        
        self.mobile = [self.mobile stringByReplacingOccurrencesOfString:[self.mobile substringWithRange:NSMakeRange(3,4)]withString:@"****"];//从第三位开始截取四个字符

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.buyDirection forKey:kInorderModelBuyDirection];
    [mutableDict setValue:self.orderType forKey:kInorderModelOrderType];
    [mutableDict setValue:self.sellTime forKey:kInorderModelSellTime];
    [mutableDict setValue:self.headImg forKey:kInorderModelHeadImg];
    [mutableDict setValue:self.mobile forKey:kInorderModelMobile];
    [mutableDict setValue:self.count forKey:kInorderModelCount];
    [mutableDict setValue:self.plAmount forKey:kInorderModelPlAmount];
    [mutableDict setValue:self.sellPrice forKey:kInorderModelSellPrice];
    [mutableDict setValue:self.price forKey:kInorderModelPrice];
    [mutableDict setValue:self.plPercent forKey:kInorderModelPlPercent];
    [mutableDict setValue:self.orderId forKey:kInorderModelOrderId];
    [mutableDict setValue:self.addTime forKey:kInorderModelAddTime];
    [mutableDict setValue:self.buyPrice forKey:kInorderModelBuyPrice];
    [mutableDict setValue:self.memberHeadimg forKey:kInorderModelMemberHeadimg];

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

    self.buyDirection = [aDecoder decodeObjectForKey:kInorderModelBuyDirection];
    self.orderType = [aDecoder decodeObjectForKey:kInorderModelOrderType];
    self.sellTime = [aDecoder decodeObjectForKey:kInorderModelSellTime];
    self.headImg = [aDecoder decodeObjectForKey:kInorderModelHeadImg];
    self.mobile = [aDecoder decodeObjectForKey:kInorderModelMobile];
    self.count = [aDecoder decodeObjectForKey:kInorderModelCount];
    self.plAmount = [aDecoder decodeObjectForKey:kInorderModelPlAmount];
    self.sellPrice = [aDecoder decodeObjectForKey:kInorderModelSellPrice];
    self.price = [aDecoder decodeObjectForKey:kInorderModelPrice];
    self.plPercent = [aDecoder decodeObjectForKey:kInorderModelPlPercent];
    self.orderId = [aDecoder decodeObjectForKey:kInorderModelOrderId];
    self.addTime = [aDecoder decodeObjectForKey:kInorderModelAddTime];
    self.buyPrice = [aDecoder decodeObjectForKey:kInorderModelBuyPrice];
    self.memberHeadimg = [aDecoder decodeObjectForKey:kInorderModelMemberHeadimg];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_buyDirection forKey:kInorderModelBuyDirection];
    [aCoder encodeObject:_orderType forKey:kInorderModelOrderType];
    [aCoder encodeObject:_sellTime forKey:kInorderModelSellTime];
    [aCoder encodeObject:_headImg forKey:kInorderModelHeadImg];
    [aCoder encodeObject:_mobile forKey:kInorderModelMobile];
    [aCoder encodeObject:_count forKey:kInorderModelCount];
    [aCoder encodeObject:_plAmount forKey:kInorderModelPlAmount];
    [aCoder encodeObject:_sellPrice forKey:kInorderModelSellPrice];
    [aCoder encodeObject:_price forKey:kInorderModelPrice];
    [aCoder encodeObject:_plPercent forKey:kInorderModelPlPercent];
    [aCoder encodeObject:_orderId forKey:kInorderModelOrderId];
    [aCoder encodeObject:_addTime forKey:kInorderModelAddTime];
    [aCoder encodeObject:_buyPrice forKey:kInorderModelBuyPrice];
    [aCoder encodeObject:_memberHeadimg forKey:kInorderModelMemberHeadimg];
}

- (id)copyWithZone:(NSZone *)zone
{
    InorderModel *copy = [[InorderModel alloc] init];
    
    if (copy) {

        copy.buyDirection = [self.buyDirection copyWithZone:zone];
        copy.orderType = [self.orderType copyWithZone:zone];
        copy.sellTime = [self.sellTime copyWithZone:zone];
        copy.headImg = [self.headImg copyWithZone:zone];
        copy.mobile = [self.mobile copyWithZone:zone];
        copy.count = [self.count copyWithZone:zone];
        copy.plAmount = [self.plAmount copyWithZone:zone];
        copy.sellPrice = [self.sellPrice copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.plPercent = [self.plPercent copyWithZone:zone];
        copy.orderId = [self.orderId copyWithZone:zone];
        copy.addTime = [self.addTime copyWithZone:zone];
        copy.buyPrice = [self.buyPrice copyWithZone:zone];
        copy.memberHeadimg = [self.memberHeadimg copyWithZone:zone];
    }
    
    return copy;
}


@end
