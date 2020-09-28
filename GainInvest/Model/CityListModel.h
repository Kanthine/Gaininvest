//
//  CityListModel.h
//  GainInvest
//
//  Created by   on 17/2/27
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface CityListModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *agencyId;
@property (nonatomic, strong) NSString *regionId;
@property (nonatomic, strong) NSString *regionType;
@property (nonatomic, strong) NSString *regionName;
@property (nonatomic, strong) NSArray<CityListModel *> *childArray;

///是否折叠：默认为 YES
@property (nonatomic, assign) BOOL isFold;
///是否选中
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, weak) CityListModel *parentModel;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end


//数据加载
@interface CityListModel (DataLoad)

//加载本地的城市列表
+ (NSArray<NSDictionary *> *)loadLocalCityListData;

//获取城市列表model
+ (NSMutableArray<CityListModel *> *)getCityListModel;
+ (void)asyncGetCityListModel:(void (^)(NSMutableArray<CityListModel *> *modelArray))block;


@end


NS_ASSUME_NONNULL_END
