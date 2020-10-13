//
//  ProductInfoModel.h
//  GainInvest
//
//  Created by   on 17/2/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductInfoModel : NSObject <NSCoding, NSCopying>

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




@interface ProductInfoModel (DataSource)
/** 获取贵金属信息
 */
+ (NSMutableArray<ProductInfoModel *> *)shareProducts;


+ (ProductInfoModel *)productWithID:(NSString *)commodityId;

@end


NS_ASSUME_NONNULL_END
