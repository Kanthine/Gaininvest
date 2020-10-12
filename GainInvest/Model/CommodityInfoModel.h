//
//  CommodityInfoModel.h
//
//  Created by   on 17/2/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommodityInfoModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *spec;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *fee;
@property (nonatomic, strong) NSString *commodityId;//商品 Id
@property (nonatomic, strong) NSString *contract;//商品符号


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
