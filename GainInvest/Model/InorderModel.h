//
//  InorderModel.h
//
//  Created by   on 17/3/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InorderModel : NSObject <NSCoding, NSCopying>
///YES 买跌 ， NO 买涨
@property (nonatomic, assign) bool isBuyDrop;
//订单类型
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *plAmount;
//买入
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *buyPrice;
//平仓
@property (nonatomic, strong) NSString *sellPrice;
@property (nonatomic, strong) NSString *sellTime;

@property (nonatomic, strong) NSString *price;//白银价格
@property (nonatomic, strong) NSString *count;//买入几手

@property (nonatomic, strong) NSString *plPercent;
@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, strong) NSString *memberHeadimg;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end




@interface InorderModel (DataSource)

+ (NSMutableArray<InorderModel *> *)inorderModelArray;

@end
