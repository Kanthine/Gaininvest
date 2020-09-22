//
//  CouponModel.m
//
//  Created by   on 17/3/11
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "CouponModel.h"


NSString *const kCouponModelMobile = @"mobile";
NSString *const kCouponModelChannel = @"channel";
NSString *const kCouponModelRechargeMoney = @"rechargeMoney";
NSString *const kCouponModelId = @"id";
NSString *const kCouponModelEndTime = @"endTime";
NSString *const kCouponModelFlag = @"flag";
NSString *const kCouponModelCouponName = @"couponName";
NSString *const kCouponModelWid = @"wid";
NSString *const kCouponModelIsUse = @"isUse";
NSString *const kCouponModelStartTime = @"startTime";
NSString *const kCouponModelCouponId = @"couponId";


@interface CouponModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CouponModel

@synthesize mobile = _mobile;
@synthesize channel = _channel;
@synthesize rechargeMoney = _rechargeMoney;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize endTime = _endTime;
@synthesize flag = _flag;
@synthesize couponName = _couponName;
@synthesize wid = _wid;
@synthesize isUse = _isUse;
@synthesize startTime = _startTime;
@synthesize couponId = _couponId;


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
            self.mobile = [[self objectOrNilForKey:kCouponModelMobile fromDictionary:dict] doubleValue];
            self.channel = [[self objectOrNilForKey:kCouponModelChannel fromDictionary:dict] doubleValue];
            self.rechargeMoney = [[self objectOrNilForKey:kCouponModelRechargeMoney fromDictionary:dict] doubleValue];
            self.internalBaseClassIdentifier = [[self objectOrNilForKey:kCouponModelId fromDictionary:dict] doubleValue];
            self.endTime = [self objectOrNilForKey:kCouponModelEndTime fromDictionary:dict];
            self.flag = [[self objectOrNilForKey:kCouponModelFlag fromDictionary:dict] doubleValue];
            self.couponName = [self objectOrNilForKey:kCouponModelCouponName fromDictionary:dict];
            self.wid = [self objectOrNilForKey:kCouponModelWid fromDictionary:dict];
            self.isUse = [[self objectOrNilForKey:kCouponModelIsUse fromDictionary:dict] doubleValue];
            self.startTime = [self objectOrNilForKey:kCouponModelStartTime fromDictionary:dict];
            self.couponId = [[self objectOrNilForKey:kCouponModelCouponId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mobile] forKey:kCouponModelMobile];
    [mutableDict setValue:[NSNumber numberWithDouble:self.channel] forKey:kCouponModelChannel];
    [mutableDict setValue:[NSNumber numberWithDouble:self.rechargeMoney] forKey:kCouponModelRechargeMoney];
    [mutableDict setValue:[NSNumber numberWithDouble:self.internalBaseClassIdentifier] forKey:kCouponModelId];
    [mutableDict setValue:self.endTime forKey:kCouponModelEndTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.flag] forKey:kCouponModelFlag];
    [mutableDict setValue:self.couponName forKey:kCouponModelCouponName];
    [mutableDict setValue:self.wid forKey:kCouponModelWid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isUse] forKey:kCouponModelIsUse];
    [mutableDict setValue:self.startTime forKey:kCouponModelStartTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.couponId] forKey:kCouponModelCouponId];

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

    self.mobile = [aDecoder decodeDoubleForKey:kCouponModelMobile];
    self.channel = [aDecoder decodeDoubleForKey:kCouponModelChannel];
    self.rechargeMoney = [aDecoder decodeDoubleForKey:kCouponModelRechargeMoney];
    self.internalBaseClassIdentifier = [aDecoder decodeDoubleForKey:kCouponModelId];
    self.endTime = [aDecoder decodeObjectForKey:kCouponModelEndTime];
    self.flag = [aDecoder decodeDoubleForKey:kCouponModelFlag];
    self.couponName = [aDecoder decodeObjectForKey:kCouponModelCouponName];
    self.wid = [aDecoder decodeObjectForKey:kCouponModelWid];
    self.isUse = [aDecoder decodeDoubleForKey:kCouponModelIsUse];
    self.startTime = [aDecoder decodeObjectForKey:kCouponModelStartTime];
    self.couponId = [aDecoder decodeDoubleForKey:kCouponModelCouponId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_mobile forKey:kCouponModelMobile];
    [aCoder encodeDouble:_channel forKey:kCouponModelChannel];
    [aCoder encodeDouble:_rechargeMoney forKey:kCouponModelRechargeMoney];
    [aCoder encodeDouble:_internalBaseClassIdentifier forKey:kCouponModelId];
    [aCoder encodeObject:_endTime forKey:kCouponModelEndTime];
    [aCoder encodeDouble:_flag forKey:kCouponModelFlag];
    [aCoder encodeObject:_couponName forKey:kCouponModelCouponName];
    [aCoder encodeObject:_wid forKey:kCouponModelWid];
    [aCoder encodeDouble:_isUse forKey:kCouponModelIsUse];
    [aCoder encodeObject:_startTime forKey:kCouponModelStartTime];
    [aCoder encodeDouble:_couponId forKey:kCouponModelCouponId];
}

- (id)copyWithZone:(NSZone *)zone
{
    CouponModel *copy = [[CouponModel alloc] init];
    
    if (copy) {

        copy.mobile = self.mobile;
        copy.channel = self.channel;
        copy.rechargeMoney = self.rechargeMoney;
        copy.internalBaseClassIdentifier = self.internalBaseClassIdentifier;
        copy.endTime = [self.endTime copyWithZone:zone];
        copy.flag = self.flag;
        copy.couponName = [self.couponName copyWithZone:zone];
        copy.wid = [self.wid copyWithZone:zone];
        copy.isUse = self.isUse;
        copy.startTime = [self.startTime copyWithZone:zone];
        copy.couponId = self.couponId;
    }
    
    return copy;
}

- (BOOL)isNoAvailAWeek
{    
    if (self.isUse == YES)
    {
        return YES;
    }
    
    
    if ([self getRemainingTime] > 7 * 24 * 60 * 60)
    {
        return YES;
    }
    
    
    return NO;
}


- (NSTimeInterval )getRemainingTime
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *date = [formatter dateFromString:[self endTime]];
    
    NSTimeInterval timeBetween = [[NSDate date] timeIntervalSinceDate:date];
    
    NSLog(@"距离过期 ====== %f",timeBetween);
    
    return timeBetween;
}



@end
