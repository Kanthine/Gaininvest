//
//  ConsultKindTitleModel.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/14.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import "ConsultKindTitleModel.h"
#import "FilePathManager.h"

NSString *const kConsultKindTitleModelTypeID = @"typeID";
NSString *const kConsultKindTitleModelTypeName = @"typeName";
NSString *const kConsultKindTitleModelKindName = @"kindName";
NSString *const kConsultKindTitleModelKindID = @"kindID";


@interface ConsultKindTitleModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ConsultKindTitleModel

@synthesize typeID = _typeID;
@synthesize typeName = _typeName;
@synthesize kindName = _kindName;
@synthesize kindID = _kindID;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.typeID = [self objectOrNilForKey:kConsultKindTitleModelTypeID fromDictionary:dict];
            self.typeName = [self objectOrNilForKey:kConsultKindTitleModelTypeName fromDictionary:dict];
            self.kindName = [self objectOrNilForKey:kConsultKindTitleModelKindName fromDictionary:dict];
            self.kindID = [self objectOrNilForKey:kConsultKindTitleModelKindID fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.typeID forKey:kConsultKindTitleModelTypeID];
    [mutableDict setValue:self.typeName forKey:kConsultKindTitleModelTypeName];
    [mutableDict setValue:self.kindName forKey:kConsultKindTitleModelKindName];
    [mutableDict setValue:self.kindID forKey:kConsultKindTitleModelKindID];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.typeID = [aDecoder decodeObjectForKey:kConsultKindTitleModelTypeID];
    self.typeName = [aDecoder decodeObjectForKey:kConsultKindTitleModelTypeName];
    self.kindName = [aDecoder decodeObjectForKey:kConsultKindTitleModelKindName];
    self.kindID = [aDecoder decodeObjectForKey:kConsultKindTitleModelKindID];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_typeID forKey:kConsultKindTitleModelTypeID];
    [aCoder encodeObject:_typeName forKey:kConsultKindTitleModelTypeName];
    [aCoder encodeObject:_kindName forKey:kConsultKindTitleModelKindName];
    [aCoder encodeObject:_kindID forKey:kConsultKindTitleModelKindID];
}

- (id)copyWithZone:(NSZone *)zone
{
    ConsultKindTitleModel *copy = [[ConsultKindTitleModel alloc] init];
    
    if (copy) {

        copy.typeID = [self.typeID copyWithZone:zone];
        copy.typeName = [self.typeName copyWithZone:zone];
        copy.kindName = [self.kindName copyWithZone:zone];
        copy.kindID = [self.kindID copyWithZone:zone];
    }
    
    return copy;
}

+ (void)writeConsultKindTitleModelWithArray:(NSMutableArray<ConsultKindTitleModel *> *)muArray{
    NSString *defaultKindPath = [FilePathManager getConsultDefaultKindFilePath];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archive encodeObject:muArray];
    [archive finishEncoding];
    [data writeToFile:defaultKindPath atomically:YES];
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


