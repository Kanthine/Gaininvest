//
//  TradeModel.h
//
//  Created by   on 17/3/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TradeModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double buyDirection;
@property (nonatomic, strong) NSString *sellTime;
@property (nonatomic, assign) double money;
@property (nonatomic, assign) double weight;
@property (nonatomic, strong) NSString *spec;
@property (nonatomic, assign) double payType;
@property (nonatomic, assign) double buyMoney;
@property (nonatomic, assign) double count;
@property (nonatomic, assign) double sellPrice;
@property (nonatomic, assign) double reType;
@property (nonatomic, assign) double orderType;
@property (nonatomic, assign) double productId;
@property (nonatomic, assign) double balance;
@property (nonatomic, assign) double buyPrice;
@property (nonatomic, assign) double couponFlag;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *proDesc;
@property (nonatomic, assign) double plAmount;
@property (nonatomic, assign) double fee;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, assign) double orderId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
