//
//  ConsultKindTitleModel.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/14.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

NSString *const ConsultKindTitleModelKindId = @"article_type_id";
NSString *const ConsultKindTitleModelKindName = @"analyst_image";
NSString *const ConsultKindTitleModelTypeId = @"label";
NSString *const ConsultKindTitleModelTypeName = @"byname";


#import "ConsultKindTitleModel.h"
#import "FilePathManager.h"

@implementation ConsultKindTitleModel

- (void)setTypeName:(NSString *)typeName
{
    _typeName = typeName;
    
    // 1 主题 2品种 3分析师*
    if ([typeName isEqualToString:@"analysts"])
    {
        self.typeId = @"3";
    }
    else if ([typeName isEqualToString:@"themes"])
    {
        self.typeId = @"1";
    }
    else if ([typeName isEqualToString:@"types"])
    {
        self.typeId = @"2";
    }
    
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.kindId = [aDecoder decodeObjectForKey:ConsultKindTitleModelKindId];
    self.kindName = [aDecoder decodeObjectForKey:ConsultKindTitleModelKindName];
    self.typeId = [aDecoder decodeObjectForKey:ConsultKindTitleModelTypeId];
    self.typeName = [aDecoder decodeObjectForKey:ConsultKindTitleModelTypeName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_kindId forKey:ConsultKindTitleModelKindId];
    [aCoder encodeObject:_kindName forKey:ConsultKindTitleModelKindName];
    [aCoder encodeObject:_typeId forKey:ConsultKindTitleModelTypeId];
    [aCoder encodeObject:_typeName forKey:ConsultKindTitleModelTypeName];
}


- (id)copyWithZone:(NSZone *)zone
{
    ConsultKindTitleModel *copy = [[ConsultKindTitleModel alloc] init];
    
    if (copy)
    {
        copy.kindId = [self.kindId copyWithZone:zone];
        copy.kindName = [self.kindName copyWithZone:zone];
        copy.typeId = [self.typeId copyWithZone:zone];
        copy.typeName = [self.typeName copyWithZone:zone];
    }
    
    return copy;
}


+ (void)writeConsultKindTitleModelWithArray:(NSMutableArray<ConsultKindTitleModel *> *)muArray
{
    NSString *defaultKindPath = [FilePathManager getConsultDefaultKindFilePath];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archive encodeObject:muArray];
    [archive finishEncoding];
    [data writeToFile:defaultKindPath atomically:YES];
}

+ (NSMutableArray<ConsultKindTitleModel *> *)setDefaultConsultKindTitleList{
    NSMutableArray<ConsultKindTitleModel *> *muArray = [NSMutableArray array];
    
    NSArray *kindNameArray = @[@"白银",@"黄金",@"美元指数",
                               @"直盘外汇",@"非农数据",@"热门策略",
                               @"布林格",@"巴克莱银行",@"学交易",@"原油"];
    
    NSArray *kindIdArray = @[@"3",@"1",@"16",
                             @"44",@"40",@"50",
                             @"1",@"3",@"55",@"17"];
    
    NSArray *typeNameArray = @[@"types",@"types",@"types",
                               @"themes",@"themes",@"themes",
                               @"analysts",@"analysts",@"analysts",@"types"];
    
    
    [kindNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
         ConsultKindTitleModel *kindModel = [[ConsultKindTitleModel alloc]init];
         kindModel.kindName = obj;
         kindModel.kindId = kindIdArray[idx];
         kindModel.typeName = typeNameArray[idx];
         [muArray addObject:kindModel];
    }];
        
    
    NSString *defaultKindPath = [FilePathManager getConsultDefaultKindFilePath];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archive encodeObject:muArray];
    [archive finishEncoding];
    [data writeToFile:defaultKindPath atomically:YES];
    
    
    return muArray;
}


+ (NSMutableArray<ConsultKindTitleModel *> *)getLocalConsultKindModelData{
    NSMutableArray *muArray = [NSMutableArray array];
    
    NSString *defaultKindPath = [FilePathManager getConsultDefaultKindFilePath];

    NSData *data = [[NSData alloc] initWithContentsOfFile:defaultKindPath];
    
    NSKeyedUnarchiver *unrachiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *array = [unrachiver decodeObject];
    [unrachiver finishDecoding];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [muArray addObject:obj];
    }];
    
    return muArray;
}

@end
