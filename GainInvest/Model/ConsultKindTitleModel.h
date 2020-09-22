//
//  ConsultKindTitleModel.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/14.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsultKindTitleModel : NSObject<NSCoding, NSCopying>

// 1 主题 themes 2品种 types 3分析师 analysts
@property (nonatomic, strong) NSString *typeID;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *kindName;
@property (nonatomic, strong) NSString *kindID;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;


+ (void)writeConsultKindTitleModelWithArray:(NSMutableArray<ConsultKindTitleModel *> *)muArray;
+ (NSMutableArray<ConsultKindTitleModel *> *)getLocalConsultKindModelData;
@end
