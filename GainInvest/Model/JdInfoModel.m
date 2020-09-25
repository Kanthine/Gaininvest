//
//  JdInfoModel.m
//
//  Created by 沫离 苏 on 2020/9/25
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "JdInfoModel.h"


NSString *const kJdInfoModelProvince = @"province";
NSString *const kJdInfoModelCity = @"city";
NSString *const kJdInfoModelCardBank = @"card_bank";
NSString *const kJdInfoModelCardIdno = @"card_idno";
NSString *const kJdInfoModelCardName = @"card_name";
NSString *const kJdInfoModelTradeAmount = @"trade_amount";
NSString *const kJdInfoModelSubBank = @"subBank";
NSString *const kJdInfoModelCardPhone = @"card_phone";
NSString *const kJdInfoModelCardNo = @"card_no";
NSString *const kJdInfoModelMobilePhone = @"mobile_phone";


@interface JdInfoModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation JdInfoModel

@synthesize province = _province;
@synthesize city = _city;
@synthesize cardBank = _cardBank;
@synthesize cardIdno = _cardIdno;
@synthesize cardName = _cardName;
@synthesize tradeAmount = _tradeAmount;
@synthesize subBank = _subBank;
@synthesize cardPhone = _cardPhone;
@synthesize cardNo = _cardNo;
@synthesize mobilePhone = _mobilePhone;


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
            self.province = [self objectOrNilForKey:kJdInfoModelProvince fromDictionary:dict];
            self.city = [self objectOrNilForKey:kJdInfoModelCity fromDictionary:dict];
            self.cardBank = [self objectOrNilForKey:kJdInfoModelCardBank fromDictionary:dict];
            self.cardIdno = [self objectOrNilForKey:kJdInfoModelCardIdno fromDictionary:dict];
            self.cardName = [self objectOrNilForKey:kJdInfoModelCardName fromDictionary:dict];
            self.tradeAmount = [self objectOrNilForKey:kJdInfoModelTradeAmount fromDictionary:dict];
            self.subBank = [self objectOrNilForKey:kJdInfoModelSubBank fromDictionary:dict];
            self.cardPhone = [self objectOrNilForKey:kJdInfoModelCardPhone fromDictionary:dict];
            self.cardNo = [self objectOrNilForKey:kJdInfoModelCardNo fromDictionary:dict];
            self.mobilePhone = [self objectOrNilForKey:kJdInfoModelMobilePhone fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.province forKey:kJdInfoModelProvince];
    [mutableDict setValue:self.city forKey:kJdInfoModelCity];
    [mutableDict setValue:self.cardBank forKey:kJdInfoModelCardBank];
    [mutableDict setValue:self.cardIdno forKey:kJdInfoModelCardIdno];
    [mutableDict setValue:self.cardName forKey:kJdInfoModelCardName];
    [mutableDict setValue:self.tradeAmount forKey:kJdInfoModelTradeAmount];
    [mutableDict setValue:self.subBank forKey:kJdInfoModelSubBank];
    [mutableDict setValue:self.cardPhone forKey:kJdInfoModelCardPhone];
    [mutableDict setValue:self.cardNo forKey:kJdInfoModelCardNo];
    [mutableDict setValue:self.mobilePhone forKey:kJdInfoModelMobilePhone];

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

    self.province = [aDecoder decodeObjectForKey:kJdInfoModelProvince];
    self.city = [aDecoder decodeObjectForKey:kJdInfoModelCity];
    self.cardBank = [aDecoder decodeObjectForKey:kJdInfoModelCardBank];
    self.cardIdno = [aDecoder decodeObjectForKey:kJdInfoModelCardIdno];
    self.cardName = [aDecoder decodeObjectForKey:kJdInfoModelCardName];
    self.tradeAmount = [aDecoder decodeObjectForKey:kJdInfoModelTradeAmount];
    self.subBank = [aDecoder decodeObjectForKey:kJdInfoModelSubBank];
    self.cardPhone = [aDecoder decodeObjectForKey:kJdInfoModelCardPhone];
    self.cardNo = [aDecoder decodeObjectForKey:kJdInfoModelCardNo];
    self.mobilePhone = [aDecoder decodeObjectForKey:kJdInfoModelMobilePhone];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_province forKey:kJdInfoModelProvince];
    [aCoder encodeObject:_city forKey:kJdInfoModelCity];
    [aCoder encodeObject:_cardBank forKey:kJdInfoModelCardBank];
    [aCoder encodeObject:_cardIdno forKey:kJdInfoModelCardIdno];
    [aCoder encodeObject:_cardName forKey:kJdInfoModelCardName];
    [aCoder encodeObject:_tradeAmount forKey:kJdInfoModelTradeAmount];
    [aCoder encodeObject:_subBank forKey:kJdInfoModelSubBank];
    [aCoder encodeObject:_cardPhone forKey:kJdInfoModelCardPhone];
    [aCoder encodeObject:_cardNo forKey:kJdInfoModelCardNo];
    [aCoder encodeObject:_mobilePhone forKey:kJdInfoModelMobilePhone];
}

- (id)copyWithZone:(NSZone *)zone
{
    JdInfoModel *copy = [[JdInfoModel alloc] init];
    
    if (copy) {

        copy.province = [self.province copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.cardBank = [self.cardBank copyWithZone:zone];
        copy.cardIdno = [self.cardIdno copyWithZone:zone];
        copy.cardName = [self.cardName copyWithZone:zone];
        copy.tradeAmount = [self.tradeAmount copyWithZone:zone];
        copy.subBank = [self.subBank copyWithZone:zone];
        copy.cardPhone = [self.cardPhone copyWithZone:zone];
        copy.cardNo = [self.cardNo copyWithZone:zone];
        copy.mobilePhone = [self.mobilePhone copyWithZone:zone];
    }
    
    return copy;
}


@end
