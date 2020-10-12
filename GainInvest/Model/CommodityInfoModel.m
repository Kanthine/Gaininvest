//
//  CommodityInfoModel.m
//
//  Created by   on 17/2/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "CommodityInfoModel.h"


NSString *const kCommodityInfoModelWeight = @"weight";
NSString *const kCommodityInfoModelUnit = @"unit";
NSString *const kCommodityInfoModelCommodityId = @"commodityId";
NSString *const kCommodityInfoModelPrice = @"price";
NSString *const kCommodityInfoModelContract = @"contract";
NSString *const kCommodityInfoModelFee = @"fee";
NSString *const kCommodityInfoModelSpec = @"spec";
NSString *const kCommodityInfoModelName = @"name";


@interface CommodityInfoModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CommodityInfoModel

@synthesize weight = _weight;
@synthesize unit = _unit;
@synthesize commodityId = _commodityId;
@synthesize price = _price;
@synthesize contract = _contract;
@synthesize fee = _fee;
@synthesize spec = _spec;
@synthesize name = _name;


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
            self.weight = [self objectOrNilForKey:kCommodityInfoModelWeight fromDictionary:dict];
            self.unit = [self objectOrNilForKey:kCommodityInfoModelUnit fromDictionary:dict];
            self.commodityId = [self objectOrNilForKey:kCommodityInfoModelCommodityId fromDictionary:dict];
            self.price = [self objectOrNilForKey:kCommodityInfoModelPrice fromDictionary:dict];
            self.contract = [self objectOrNilForKey:kCommodityInfoModelContract fromDictionary:dict];
            self.fee = [self objectOrNilForKey:kCommodityInfoModelFee fromDictionary:dict];
            self.spec = [self objectOrNilForKey:kCommodityInfoModelSpec fromDictionary:dict];
            self.name = [self objectOrNilForKey:kCommodityInfoModelName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.weight forKey:kCommodityInfoModelWeight];
    [mutableDict setValue:self.unit forKey:kCommodityInfoModelUnit];
    [mutableDict setValue:self.commodityId forKey:kCommodityInfoModelCommodityId];
    [mutableDict setValue:self.price forKey:kCommodityInfoModelPrice];
    [mutableDict setValue:self.contract forKey:kCommodityInfoModelContract];
    [mutableDict setValue:self.fee forKey:kCommodityInfoModelFee];
    [mutableDict setValue:self.spec forKey:kCommodityInfoModelSpec];
    [mutableDict setValue:self.name forKey:kCommodityInfoModelName];

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

    self.weight = [aDecoder decodeObjectForKey:kCommodityInfoModelWeight];
    self.unit = [aDecoder decodeObjectForKey:kCommodityInfoModelUnit];
    self.commodityId = [aDecoder decodeObjectForKey:kCommodityInfoModelCommodityId];
    self.price = [aDecoder decodeObjectForKey:kCommodityInfoModelPrice];
    self.contract = [aDecoder decodeObjectForKey:kCommodityInfoModelContract];
    self.fee = [aDecoder decodeObjectForKey:kCommodityInfoModelFee];
    self.spec = [aDecoder decodeObjectForKey:kCommodityInfoModelSpec];
    self.name = [aDecoder decodeObjectForKey:kCommodityInfoModelName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_weight forKey:kCommodityInfoModelWeight];
    [aCoder encodeObject:_unit forKey:kCommodityInfoModelUnit];
    [aCoder encodeObject:_commodityId forKey:kCommodityInfoModelCommodityId];
    [aCoder encodeObject:_price forKey:kCommodityInfoModelPrice];
    [aCoder encodeObject:_contract forKey:kCommodityInfoModelContract];
    [aCoder encodeObject:_fee forKey:kCommodityInfoModelFee];
    [aCoder encodeObject:_spec forKey:kCommodityInfoModelSpec];
    [aCoder encodeObject:_name forKey:kCommodityInfoModelName];
}

- (id)copyWithZone:(NSZone *)zone
{
    CommodityInfoModel *copy = [[CommodityInfoModel alloc] init];
    
    if (copy) {

        copy.weight = [self.weight copyWithZone:zone];
        copy.unit = [self.unit copyWithZone:zone];
        copy.commodityId = [self.commodityId copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.contract = [self.contract copyWithZone:zone];
        copy.fee = [self.fee copyWithZone:zone];
        copy.spec = [self.spec copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
