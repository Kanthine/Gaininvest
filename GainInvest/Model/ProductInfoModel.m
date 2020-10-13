//
//  ProductInfoModel.m
//  GainInvest
//
//  Created by   on 17/2/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "ProductInfoModel.h"


NSString *const kProductInfoModelWeight = @"weight";
NSString *const kProductInfoModelUnit = @"unit";
NSString *const kProductInfoModelCommodityId = @"commodityId";
NSString *const kProductInfoModelPrice = @"price";
NSString *const kProductInfoModelContract = @"contract";
NSString *const kProductInfoModelFee = @"fee";
NSString *const kProductInfoModelSpec = @"spec";
NSString *const kProductInfoModelName = @"name";


@interface ProductInfoModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ProductInfoModel

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
            self.weight = [self objectOrNilForKey:kProductInfoModelWeight fromDictionary:dict];
            self.unit = [self objectOrNilForKey:kProductInfoModelUnit fromDictionary:dict];
            self.commodityId = [self objectOrNilForKey:kProductInfoModelCommodityId fromDictionary:dict];
            self.price = [self objectOrNilForKey:kProductInfoModelPrice fromDictionary:dict];
            self.contract = [self objectOrNilForKey:kProductInfoModelContract fromDictionary:dict];
            self.fee = [self objectOrNilForKey:kProductInfoModelFee fromDictionary:dict];
            self.spec = [self objectOrNilForKey:kProductInfoModelSpec fromDictionary:dict];
            self.name = [self objectOrNilForKey:kProductInfoModelName fromDictionary:dict];

    }
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.weight forKey:kProductInfoModelWeight];
    [mutableDict setValue:self.unit forKey:kProductInfoModelUnit];
    [mutableDict setValue:self.commodityId forKey:kProductInfoModelCommodityId];
    [mutableDict setValue:self.price forKey:kProductInfoModelPrice];
    [mutableDict setValue:self.contract forKey:kProductInfoModelContract];
    [mutableDict setValue:self.fee forKey:kProductInfoModelFee];
    [mutableDict setValue:self.spec forKey:kProductInfoModelSpec];
    [mutableDict setValue:self.name forKey:kProductInfoModelName];

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

    self.weight = [aDecoder decodeObjectForKey:kProductInfoModelWeight];
    self.unit = [aDecoder decodeObjectForKey:kProductInfoModelUnit];
    self.commodityId = [aDecoder decodeObjectForKey:kProductInfoModelCommodityId];
    self.price = [aDecoder decodeObjectForKey:kProductInfoModelPrice];
    self.contract = [aDecoder decodeObjectForKey:kProductInfoModelContract];
    self.fee = [aDecoder decodeObjectForKey:kProductInfoModelFee];
    self.spec = [aDecoder decodeObjectForKey:kProductInfoModelSpec];
    self.name = [aDecoder decodeObjectForKey:kProductInfoModelName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_weight forKey:kProductInfoModelWeight];
    [aCoder encodeObject:_unit forKey:kProductInfoModelUnit];
    [aCoder encodeObject:_commodityId forKey:kProductInfoModelCommodityId];
    [aCoder encodeObject:_price forKey:kProductInfoModelPrice];
    [aCoder encodeObject:_contract forKey:kProductInfoModelContract];
    [aCoder encodeObject:_fee forKey:kProductInfoModelFee];
    [aCoder encodeObject:_spec forKey:kProductInfoModelSpec];
    [aCoder encodeObject:_name forKey:kProductInfoModelName];
}

- (id)copyWithZone:(NSZone *)zone
{
    ProductInfoModel *copy = [[ProductInfoModel alloc] init];
    
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






@implementation ProductInfoModel (DataSource)

+ (NSMutableArray<ProductInfoModel *> *)shareProducts{
    static NSMutableArray<ProductInfoModel *> *array;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (array == nil) {
            NSString *filePath = [NSBundle.mainBundle pathForResource:@"ProductInfo" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSArray<NSDictionary *> *dictArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            array = [NSMutableArray arrayWithCapacity:dictArray.count];
            for (NSDictionary *dict in dictArray) {
                ProductInfoModel *model = [ProductInfoModel modelObjectWithDictionary:dict];
                [array addObject:model];
            }
        }
    });
    return array;
}

+ (ProductInfoModel *)productWithID:(NSString *)commodityId{
    ProductInfoModel *result;
    for (ProductInfoModel *model in ProductInfoModel.shareProducts) {
        if ([model.commodityId isEqualToString:commodityId]) {
            result = model;
            break;
        }
    }
    return result;
}


@end
