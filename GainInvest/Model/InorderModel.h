//
//  InorderModel.h
//
//  Created by   on 17/3/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface InorderModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *buyDirection;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSString *sellTime;
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *plAmount;
@property (nonatomic, strong) NSString *sellPrice;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *plPercent;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *buyPrice;
@property (nonatomic, strong) NSString *memberHeadimg;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
