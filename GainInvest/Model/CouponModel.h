//
//  CouponModel.h
//
//  Created by   on 17/3/11
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CouponModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double mobile;
@property (nonatomic, assign) double channel;
@property (nonatomic, assign) double rechargeMoney;
@property (nonatomic, assign) double internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, assign) double flag;//是否有效
@property (nonatomic, strong) NSString *couponName;
@property (nonatomic, strong) NSString *wid;
@property (nonatomic, assign) double isUse;//是否使用
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, assign) double couponId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

/* 是否无效期超过1周，YES为超过1周*/
- (BOOL)isNoAvailAWeek;


@end
