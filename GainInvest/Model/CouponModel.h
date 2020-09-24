//
//  CouponModel.h
//
//  Created by   on 17/3/11
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CouponModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger mobile;
@property (nonatomic, assign) NSInteger channel;
@property (nonatomic, assign) NSInteger couponId;
@property (nonatomic, assign) NSInteger internalBaseClassIdentifier;
@property (nonatomic, assign) BOOL flag;//是否有效
@property (nonatomic, assign) BOOL isUse;//是否使用

@property (nonatomic, assign) double rechargeMoney;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *couponName;
@property (nonatomic, strong) NSString *wid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

/* 是否无效期超过1周，YES为超过1周*/
- (BOOL)isNoAvailAWeek;

@end
