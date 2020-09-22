//
//  PositionsModel.h
//
//  Created by   on 17/3/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PositionsModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double plRatio;
@property (nonatomic, assign) double buyDirection;
@property (nonatomic, assign) double weight;
@property (nonatomic, strong) NSString *spec;
@property (nonatomic, assign) double couponId;
@property (nonatomic, assign) double buyMoney;
@property (nonatomic, assign) double deficitPrice;
@property (nonatomic, assign) double bottomLimit;
@property (nonatomic, assign) double count;
@property (nonatomic, assign) double sellPrice;
@property (nonatomic, assign) double orderType;
@property (nonatomic, assign) double flag;
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, assign) double productId;
@property (nonatomic, assign) double buyPrice;
@property (nonatomic, assign) double bottomPrice;
@property (nonatomic, assign) double couponFlag;
@property (nonatomic, strong) NSString *couponName;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, assign) double topPrice;
@property (nonatomic, strong) NSString *proDesc;
@property (nonatomic, strong) NSString *wid;
@property (nonatomic, strong) NSString *contract;
@property (nonatomic, assign) double topLimit;
@property (nonatomic, assign) double fee;
@property (nonatomic, assign) double plAmount;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, assign) double orderId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
