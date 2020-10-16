//
//  OrderInfoModel.m
//  GainInvest
//
//  Created by   on 17/3/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "OrderInfoModel.h"

NSString *const kOrderInfoModelPlRatio = @"plRatio";
NSString *const kOrderInfoModelBuyDirection = @"buyDirection";
NSString *const kOrderInfoModelWeight = @"weight";
NSString *const kOrderInfoModelSpec = @"spec";
NSString *const kOrderInfoModelCouponId = @"couponId";
NSString *const kOrderInfoModelBuyMoney = @"buyMoney";
NSString *const kOrderInfoModelDeficitPrice = @"deficitPrice";
NSString *const kOrderInfoModelBottomLimit = @"bottomLimit";
NSString *const kOrderInfoModelCount = @"count";
NSString *const kOrderInfoModelSellPrice = @"sellPrice";
NSString *const kOrderInfoModelOrderType = @"orderType";
NSString *const kOrderInfoModelFlag = @"flag";
NSString *const kOrderInfoModelProductId = @"productId";
NSString *const kOrderInfoModelBuyPrice = @"buyPrice";
NSString *const kOrderInfoModelBottomPrice = @"bottomPrice";
NSString *const kOrderInfoModelCouponFlag = @"couponFlag";
NSString *const kOrderInfoModelCouponName = @"couponName";
NSString *const kOrderInfoModelAddTime = @"addTime";
NSString *const kOrderInfoModelTopPrice = @"topPrice";
NSString *const kOrderInfoModelProDesc = @"proDesc";
NSString *const kOrderInfoModelWid = @"wid";
NSString *const kOrderInfoModelContract = @"contract";
NSString *const kOrderInfoModelTopLimit = @"topLimit";
NSString *const kOrderInfoModelFee = @"fee";
NSString *const kOrderInfoModelPlAmount = @"plAmount";
NSString *const kOrderInfoModelPrice = @"price";
NSString *const kOrderInfoModelProductName = @"productName";
NSString *const kOrderInfoModelOrderId = @"orderId";


@interface OrderInfoModel ()

@property (nonatomic, assign) double topPrice;
@property (nonatomic, assign) double bottomPrice;
@property (nonatomic, assign) double buyMoney;
@property (nonatomic, assign) double deficitPrice;
@property (nonatomic, assign) double flag;
@property (nonatomic, assign) double balance;
@property (nonatomic, strong) NSString *wid;

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OrderInfoModel

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
@synthesize buyPrice = _buyPrice;
@synthesize bottomPrice = _bottomPrice;
@synthesize isUseCoupon = _isUseCoupon;
@synthesize couponName = _couponName;
@synthesize addTime = _addTime;
@synthesize topPrice = _topPrice;
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
            self.plRatio = [[self objectOrNilForKey:kOrderInfoModelPlRatio fromDictionary:dict] doubleValue];
            self.isBuyDrop = [[self objectOrNilForKey:kOrderInfoModelBuyDirection fromDictionary:dict] boolValue];
            self.couponId = [[self objectOrNilForKey:kOrderInfoModelCouponId fromDictionary:dict] doubleValue];
            self.buyMoney = [[self objectOrNilForKey:kOrderInfoModelBuyMoney fromDictionary:dict] doubleValue];
            self.deficitPrice = [[self objectOrNilForKey:kOrderInfoModelDeficitPrice fromDictionary:dict] doubleValue];
            self.bottomLimit = [[self objectOrNilForKey:kOrderInfoModelBottomLimit fromDictionary:dict] doubleValue];
            self.count = [[self objectOrNilForKey:kOrderInfoModelCount fromDictionary:dict] doubleValue];
            self.sellPrice = [[self objectOrNilForKey:kOrderInfoModelSellPrice fromDictionary:dict] doubleValue];
            self.orderType = [self objectOrNilForKey:kOrderInfoModelOrderType fromDictionary:dict];
            self.flag = [[self objectOrNilForKey:kOrderInfoModelFlag fromDictionary:dict] doubleValue];
            self.buyPrice = [[self objectOrNilForKey:kOrderInfoModelBuyPrice fromDictionary:dict] doubleValue];
            self.bottomPrice = [[self objectOrNilForKey:kOrderInfoModelBottomPrice fromDictionary:dict] doubleValue];
            self.isUseCoupon = [[self objectOrNilForKey:kOrderInfoModelCouponFlag fromDictionary:dict] boolValue];
            self.couponName = [self objectOrNilForKey:kOrderInfoModelCouponName fromDictionary:dict];
            self.addTime = [self objectOrNilForKey:kOrderInfoModelAddTime fromDictionary:dict];
            self.topPrice = [[self objectOrNilForKey:kOrderInfoModelTopPrice fromDictionary:dict] doubleValue];
            self.wid = [self objectOrNilForKey:kOrderInfoModelWid fromDictionary:dict];
            self.topLimit = [[self objectOrNilForKey:kOrderInfoModelTopLimit fromDictionary:dict] doubleValue];
            self.fee = [[self objectOrNilForKey:kOrderInfoModelFee fromDictionary:dict] doubleValue];
            self.plAmount = [[self objectOrNilForKey:kOrderInfoModelPlAmount fromDictionary:dict] doubleValue];
            self.orderId = [[self objectOrNilForKey:kOrderInfoModelOrderId fromDictionary:dict] doubleValue];
    }
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.plRatio] forKey:kOrderInfoModelPlRatio];
    [mutableDict setValue:@(self.isBuyDrop) forKey:kOrderInfoModelBuyDirection];
    [mutableDict setValue:[NSNumber numberWithDouble:self.couponId] forKey:kOrderInfoModelCouponId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyMoney] forKey:kOrderInfoModelBuyMoney];
    [mutableDict setValue:[NSNumber numberWithDouble:self.deficitPrice] forKey:kOrderInfoModelDeficitPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.bottomLimit] forKey:kOrderInfoModelBottomLimit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.count] forKey:kOrderInfoModelCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sellPrice] forKey:kOrderInfoModelSellPrice];
    [mutableDict setValue:self.orderType forKey:kOrderInfoModelOrderType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.flag] forKey:kOrderInfoModelFlag];
    [mutableDict setValue:[NSNumber numberWithDouble:self.buyPrice] forKey:kOrderInfoModelBuyPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.bottomPrice] forKey:kOrderInfoModelBottomPrice];
    [mutableDict setValue:@(self.isUseCoupon) forKey:kOrderInfoModelCouponFlag];
    [mutableDict setValue:self.couponName forKey:kOrderInfoModelCouponName];
    [mutableDict setValue:self.addTime forKey:kOrderInfoModelAddTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.topPrice] forKey:kOrderInfoModelTopPrice];
    [mutableDict setValue:self.wid forKey:kOrderInfoModelWid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.topLimit] forKey:kOrderInfoModelTopLimit];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fee] forKey:kOrderInfoModelFee];
    [mutableDict setValue:[NSNumber numberWithDouble:self.plAmount] forKey:kOrderInfoModelPlAmount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderId] forKey:kOrderInfoModelOrderId];

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

    self.plRatio = [aDecoder decodeDoubleForKey:kOrderInfoModelPlRatio];
    self.isBuyDrop = [aDecoder decodeBoolForKey:kOrderInfoModelBuyDirection];
    self.couponId = [aDecoder decodeDoubleForKey:kOrderInfoModelCouponId];
    self.buyMoney = [aDecoder decodeDoubleForKey:kOrderInfoModelBuyMoney];
    self.deficitPrice = [aDecoder decodeDoubleForKey:kOrderInfoModelDeficitPrice];
    self.bottomLimit = [aDecoder decodeDoubleForKey:kOrderInfoModelBottomLimit];
    self.count = [aDecoder decodeDoubleForKey:kOrderInfoModelCount];
    self.sellPrice = [aDecoder decodeDoubleForKey:kOrderInfoModelSellPrice];
    self.orderType = [aDecoder decodeObjectForKey:kOrderInfoModelOrderType];
    self.flag = [aDecoder decodeDoubleForKey:kOrderInfoModelFlag];
    self.buyPrice = [aDecoder decodeDoubleForKey:kOrderInfoModelBuyPrice];
    self.bottomPrice = [aDecoder decodeDoubleForKey:kOrderInfoModelBottomPrice];
    self.isUseCoupon = [aDecoder decodeBoolForKey:kOrderInfoModelCouponFlag];
    self.couponName = [aDecoder decodeObjectForKey:kOrderInfoModelCouponName];
    self.addTime = [aDecoder decodeObjectForKey:kOrderInfoModelAddTime];
    self.topPrice = [aDecoder decodeDoubleForKey:kOrderInfoModelTopPrice];
    self.wid = [aDecoder decodeObjectForKey:kOrderInfoModelWid];
    self.topLimit = [aDecoder decodeDoubleForKey:kOrderInfoModelTopLimit];
    self.fee = [aDecoder decodeDoubleForKey:kOrderInfoModelFee];
    self.plAmount = [aDecoder decodeDoubleForKey:kOrderInfoModelPlAmount];
    self.orderId = [aDecoder decodeDoubleForKey:kOrderInfoModelOrderId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_plRatio forKey:kOrderInfoModelPlRatio];
    [aCoder encodeBool:_isBuyDrop forKey:kOrderInfoModelBuyDirection];
    [aCoder encodeDouble:_couponId forKey:kOrderInfoModelCouponId];
    [aCoder encodeDouble:_buyMoney forKey:kOrderInfoModelBuyMoney];
    [aCoder encodeDouble:_deficitPrice forKey:kOrderInfoModelDeficitPrice];
    [aCoder encodeDouble:_bottomLimit forKey:kOrderInfoModelBottomLimit];
    [aCoder encodeDouble:_count forKey:kOrderInfoModelCount];
    [aCoder encodeDouble:_sellPrice forKey:kOrderInfoModelSellPrice];
    [aCoder encodeObject:_orderType forKey:kOrderInfoModelOrderType];
    [aCoder encodeDouble:_flag forKey:kOrderInfoModelFlag];
    [aCoder encodeDouble:_buyPrice forKey:kOrderInfoModelBuyPrice];
    [aCoder encodeDouble:_bottomPrice forKey:kOrderInfoModelBottomPrice];
    [aCoder encodeBool:_isUseCoupon forKey:kOrderInfoModelCouponFlag];
    [aCoder encodeObject:_couponName forKey:kOrderInfoModelCouponName];
    [aCoder encodeObject:_addTime forKey:kOrderInfoModelAddTime];
    [aCoder encodeDouble:_topPrice forKey:kOrderInfoModelTopPrice];
    [aCoder encodeObject:_wid forKey:kOrderInfoModelWid];
    [aCoder encodeDouble:_topLimit forKey:kOrderInfoModelTopLimit];
    [aCoder encodeDouble:_fee forKey:kOrderInfoModelFee];
    [aCoder encodeDouble:_plAmount forKey:kOrderInfoModelPlAmount];
    [aCoder encodeDouble:_orderId forKey:kOrderInfoModelOrderId];
}

- (id)copyWithZone:(NSZone *)zone{
    OrderInfoModel *copy = [[OrderInfoModel alloc] init];
    
    if (copy) {

        copy.plRatio = self.plRatio;
        copy.isBuyDrop = self.isBuyDrop;
        copy.couponId = self.couponId;
        copy.buyMoney = self.buyMoney;
        copy.deficitPrice = self.deficitPrice;
        copy.bottomLimit = self.bottomLimit;
        copy.count = self.count;
        copy.sellPrice = self.sellPrice;
        copy.orderType = [self.orderType copyWithZone:zone];
        copy.flag = self.flag;
        copy.buyPrice = self.buyPrice;
        copy.bottomPrice = self.bottomPrice;
        copy.isUseCoupon = self.isUseCoupon;
        copy.couponName = [self.couponName copyWithZone:zone];
        copy.addTime = [self.addTime copyWithZone:zone];
        copy.topPrice = self.topPrice;
        copy.wid = [self.wid copyWithZone:zone];
        copy.topLimit = self.topLimit;
        copy.fee = self.fee;
        copy.plAmount = self.plAmount;
        copy.orderId = self.orderId;
    }
    return copy;
}

- (NSInteger)orderId{
    if (_orderId < 10) {
        _orderId = NSDate.date.timeIntervalSince1970;
    }
    return _orderId;
}

- (NSString *)addTime{
    if (_addTime == nil) {
        _addTime = getTimeWithDate(NSDate.date);
    }
    return _addTime;
}

- (NSString *)remark{
    if (_remark == nil) {
        _remark = @"建仓";
    }
    return _remark;
}

- (float)fee{
    return _productInfo.fee.floatValue * self.count;
}

- (double)buyPrice{
    if (_buyPrice < 1.0) {
        _buyPrice = self.productInfo.weight.floatValue * self.count;
    }
    return _buyPrice;
}

/** 市盈率水平为：
 * <0 ：指该公司盈利为负（因盈利为负，计算市盈率没有意义，所以一般软件显示为“—”）
 * 0-13 ：即价值被低估
 * 14-20：即正常水平
 * 21-28：即价值被高估
 * 28+ ：反映股市出现投机性泡沫
 */
- (double)plRatio{
    return 0.15;
}

- (float)plAmount{    
    float money = (StockCurrentData.currentStock.quote.floatValue * self.count - self.buyPrice) * self.plRatio;
    if ([self.remark isEqualToString:@"建仓"]) {
        money = (StockCurrentData.currentStock.quote.floatValue * self.count - self.buyPrice) * self.plRatio;
    }else{
        money = (self.sellPrice - self.buyPrice) * self.plRatio;
    }
    if (self.isBuyDrop){
        money = - money;
    }
    return money;
}

@end




@implementation OrderInfoModel (Order)

- (NSString *)plAmountText{
    if (self.plAmount > 0){//浮动盈亏
        return [NSString stringWithFormat:@"+%.2f",self.plAmount];
    }else{
        return [NSString stringWithFormat:@"-%.2f",self.plAmount];
    }
}

///创建一个订单
+ (void)creatOrder:(OrderInfoModel *)order handler:(void(^)(BOOL isSuccess))block{
    [OrderInfoModel insertModel:order];
    
    
    block(YES);
    
}

//平仓
- (void)closePosition{
    _sellTime = getTimeWithDate(NSDate.date);
    _sellPrice = StockCurrentData.currentStock.quote.floatValue * self.count;
    _remark = @"平仓";
    [OrderInfoModel updateModel:self];
}

@end



#import "ProductInfoModel.h"
@implementation OrderInfoModel (FMDB)

// 创建表
+ (void)creatTableWithDatabase:(FMDatabase *)database{
    if (![database tableExists:@"OrderTable"]){
        [database executeUpdate:@"CREATE TABLE OrderTable (id INTEGER PRIMARY KEY,orderId INTEGER UNIQUE NOT NULL,count INTEGER, isBuyDrop boolean, isUseCoupon boolean, couponId INTEGER, couponName TEXT,topLimit double,bottomLimit double,productInfo TEXT, buyPrice double, fee double, addTime TEXT,sellPrice double,sellTime TEXT,plAmount double,remark TEXT,plRatio double,orderType TEXT)"];
    }
}

+ (void)insertModel:(OrderInfoModel *)model{
    [FMDBHelper databaseChildThreadInTransaction:^(FMDatabase * _Nonnull database, BOOL * _Nonnull rollback) {
        [OrderInfoModel creatTableWithDatabase:database];
        [database executeUpdate:@"INSERT INTO OrderTable (orderId,count,isBuyDrop,isUseCoupon,couponId, couponName,topLimit,bottomLimit,productInfo,buyPrice,fee,addTime ,sellPrice,sellTime,plAmount,remark,plRatio,orderType) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
         @(model.orderId),@(model.count),@(model.isBuyDrop),@(model.isUseCoupon),
         @(model.couponId),model.couponName,@(model.topLimit),@(model.bottomLimit),
         model.productInfo.commodityId,@(model.buyPrice),@(model.fee),model.addTime,
         @(model.sellPrice),model.sellTime,@(model.plAmount),model.remark,
         @(model.plRatio),model.orderType];
    }];
}

+ (void)updateModel:(OrderInfoModel *)model{
    [FMDBHelper databaseChildThreadInTransaction:^(FMDatabase * _Nonnull database, BOOL * _Nonnull rollback) {
        [database executeUpdate:@"UPDATE OrderTable SET count = ?,isBuyDrop = ?,isUseCoupon = ?,couponId = ?,couponName = ?,topLimit = ?,bottomLimit = ?,productInfo = ?,buyPrice = ?,fee = ?,addTime = ?,sellPrice = ?,sellTime = ?,plAmount = ?,remark = ?,plRatio = ?,orderType = ? WHERE orderId = ?",
         @(model.count),@(model.isBuyDrop),@(model.isUseCoupon),@(model.couponId),
         model.couponName,@(model.topLimit),@(model.bottomLimit),model.productInfo.commodityId,
         @(model.buyPrice),@(model.fee),model.addTime,@(model.sellPrice),
         model.sellTime,@(model.plAmount),model.remark,@(model.plRatio),
         model.orderType,
         @(model.orderId)];
    }];
}

+ (OrderInfoModel *)modelFromeResult:(FMResultSet *)resultSet{
    OrderInfoModel *model = [[OrderInfoModel alloc] init];
    model.orderId = [resultSet intForColumn:@"orderId"];
    model.count = [resultSet intForColumn:@"count"];
    model.isBuyDrop = [resultSet boolForColumn:@"isBuyDrop"];
    model.isUseCoupon = [resultSet boolForColumn:@"isUseCoupon"];
    model.couponId = [resultSet intForColumn:@"couponId"];
    model.couponName = [resultSet stringForColumn:@"couponName"];
    model.topLimit = [resultSet doubleForColumn:@"topLimit"];
    model.bottomLimit = [resultSet doubleForColumn:@"bottomLimit"];
    NSString *commodityId = [resultSet stringForColumn:@"productInfo"];
    model.productInfo = [ProductInfoModel productWithID:commodityId];
    model.buyPrice = [resultSet doubleForColumn:@"buyPrice"];
    model.fee = [resultSet doubleForColumn:@"fee"];
    model.addTime = [resultSet stringForColumn:@"addTime"];
    model.sellPrice = [resultSet doubleForColumn:@"sellPrice"];
    model.sellTime = [resultSet stringForColumn:@"sellTime"];
    model.plAmount = [resultSet doubleForColumn:@"plAmount"];
    model.remark = [resultSet stringForColumn:@"remark"];
    model.plRatio = [resultSet doubleForColumn:@"plRatio"];
    model.orderType = [resultSet stringForColumn:@"orderType"];
    return model;
}

///获取所有持仓数据
+ (void)getModelsWithType:(OrderType)type handler:(void(^)(NSMutableArray<OrderInfoModel *> *modelsArray))block{
    [FMDBHelper databaseChildThreadInTransaction:^(FMDatabase * _Nonnull database, BOOL * _Nonnull rollback) {
        // 查询会返回一个结果集
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM OrderTable"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        while ([resultSet next]){
            OrderInfoModel *model = [OrderInfoModel modelFromeResult:resultSet];
            
            if (type == OrderTypeAll) {
                [array addObject:model];
            }else if (type == OrderTypePosition){
                if (model.sellPrice > 0 &&
                    model.sellTime.length > 1) {
                }else{
                    [array addObject:model];
                }
            }else if (type == OrderTypeClosePosition){
                if (model.sellPrice > 0 &&
                    model.sellTime.length > 1) {
                    [array addObject:model];
                }
            }
        }
        [resultSet close];
        dispatch_async(dispatch_get_main_queue(), ^{
             block(array);
         });
    }];
}

+ (void)getModelByOrderID:(NSInteger)orderId handler:(void(^)(OrderInfoModel *model))block{
    
    [FMDBHelper databaseChildThreadInTransaction:^(FMDatabase * _Nonnull database, BOOL * _Nonnull rollback) {
        // 查询会返回一个结果集
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM OrderTable WHERE orderId = ?",orderId];
        
        OrderInfoModel *model;
        while ([resultSet next]){
            model = [OrderInfoModel modelFromeResult:resultSet];
        }
        [resultSet close];
        
        dispatch_async(dispatch_get_main_queue(), ^{
             block(model);
         });
    }];
}

@end
