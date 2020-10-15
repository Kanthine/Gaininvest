//
//  StockCurrentData.m
//
//  Created by   on 17/2/10
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "StockCurrentData.h"


NSString *const kStockCurrentDataLow = @"low";
NSString *const kStockCurrentDataCreateDate = @"createDate";
NSString *const kStockCurrentDataHigh = @"high";
NSString *const kStockCurrentDataPreClose = @"preClose";
NSString *const kStockCurrentDataQuote = @"quote";
NSString *const kStockCurrentDataOpen = @"open";


@interface StockCurrentData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation StockCurrentData

@synthesize low = _low;
@synthesize createDate = _createDate;
@synthesize high = _high;
@synthesize preClose = _preClose;
@synthesize quote = _quote;
@synthesize open = _open;


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
            self.low = [self objectOrNilForKey:kStockCurrentDataLow fromDictionary:dict];
            self.createDate = [self objectOrNilForKey:kStockCurrentDataCreateDate fromDictionary:dict];
            self.high = [self objectOrNilForKey:kStockCurrentDataHigh fromDictionary:dict];
            self.preClose = [self objectOrNilForKey:kStockCurrentDataPreClose fromDictionary:dict];
            self.quote = [self objectOrNilForKey:kStockCurrentDataQuote fromDictionary:dict];
            self.open = [self objectOrNilForKey:kStockCurrentDataOpen fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.low forKey:kStockCurrentDataLow];
    [mutableDict setValue:self.createDate forKey:kStockCurrentDataCreateDate];
    [mutableDict setValue:self.high forKey:kStockCurrentDataHigh];
    [mutableDict setValue:self.preClose forKey:kStockCurrentDataPreClose];
    [mutableDict setValue:self.quote forKey:kStockCurrentDataQuote];
    [mutableDict setValue:self.open forKey:kStockCurrentDataOpen];

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

    self.low = [aDecoder decodeObjectForKey:kStockCurrentDataLow];
    self.createDate = [aDecoder decodeObjectForKey:kStockCurrentDataCreateDate];
    self.high = [aDecoder decodeObjectForKey:kStockCurrentDataHigh];
    self.preClose = [aDecoder decodeObjectForKey:kStockCurrentDataPreClose];
    self.quote = [aDecoder decodeObjectForKey:kStockCurrentDataQuote];
    self.open = [aDecoder decodeObjectForKey:kStockCurrentDataOpen];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_low forKey:kStockCurrentDataLow];
    [aCoder encodeObject:_createDate forKey:kStockCurrentDataCreateDate];
    [aCoder encodeObject:_high forKey:kStockCurrentDataHigh];
    [aCoder encodeObject:_preClose forKey:kStockCurrentDataPreClose];
    [aCoder encodeObject:_quote forKey:kStockCurrentDataQuote];
    [aCoder encodeObject:_open forKey:kStockCurrentDataOpen];
}

- (id)copyWithZone:(NSZone *)zone
{
    StockCurrentData *copy = [[StockCurrentData alloc] init];
    
    if (copy) {

        copy.low = [self.low copyWithZone:zone];
        copy.createDate = [self.createDate copyWithZone:zone];
        copy.high = [self.high copyWithZone:zone];
        copy.preClose = [self.preClose copyWithZone:zone];
        copy.quote = [self.quote copyWithZone:zone];
        copy.open = [self.open copyWithZone:zone];
    }
    
    return copy;
}


@end





@implementation StockCurrentData (Serve)

+ (instancetype)currentStock{
    static StockCurrentData *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (data == nil) {
            data = [[StockCurrentData alloc] init];
            data.low = @"500";
            data.createDate = @"9月23号";
            data.high = @"760";
            data.preClose = @"520";
            data.quote = @"700";
            data.open = @"550";
        }
    });
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"MM月dd号"];

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    data.createDate = [formatter stringFromDate:NSDate.date];
    
    return data;
}

///时分图假数据
+ (NSMutableArray<NSString *> *)timeLineChartDatasWithType:(NSString *)type{
  NSMutableArray<NSString *> *resultArray = [NSMutableArray array];
   float baseData = 512.56;
   for (int i = 0; i < 1000; i++) {
      float value = baseData + (arc4random() % 20000) / 99.9;
      [resultArray addObject:[NSString stringWithFormat:@"%f",value]];
   }
  return resultArray;
}

///时分图假数据
+ (NSMutableArray<NSString *> *)timeDatesWithType:(NSString *)type{
  NSMutableArray<NSString *> *resultArray = [NSMutableArray array];
  int baseData = arc4random()  % 10;
  for (int i = 0; i < 1000; i++) {
      int value = baseData + i;
      [resultArray addObject:[NSString stringWithFormat:@"%d",value]];
  }
  return resultArray;
}

- (NSTimer *)timer{
    if (_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(realTimeUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}


- (void)realTimeUpdate{
//    [self accessToMarketQuotation];
//    [self accessK_TimeLineChart];
//    [self accessProductList];
//    [self accessBuyUpOrDown];
}


@end
