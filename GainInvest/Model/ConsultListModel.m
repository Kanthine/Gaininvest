//
//  ConsultListModel.m
//
//  Created by   on 17/2/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "ConsultListModel.h"


NSString *const kConsultListModelArticleTypeId = @"article_type_id";
NSString *const kConsultListModelAnalystImage = @"analyst_image";
NSString *const kConsultListModelLabel = @"label";
NSString *const kConsultListModelByname = @"byname";
NSString *const kConsultListModelArticleId = @"article_id";
NSString *const kConsultListModelAnalystName = @"analyst_name";
NSString *const kConsultListModelImageUrl = @"image_url";
NSString *const kConsultListModelOName = @"o_name";
NSString *const kConsultListModelTypeName = @"type_name";
NSString *const kConsultListModelArticleTitle = @"article_title";
NSString *const kConsultListModelSummary = @"summary";
NSString *const kConsultListModelLikeNum = @"like_num";
NSString *const kConsultListModelArticleDate = @"article_date";
NSString *const kConsultListModelVirtualHits = @"virtual_hits";
NSString *const kConsultListModelTName = @"t_name";


@interface ConsultListModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ConsultListModel

@synthesize articleTypeId = _articleTypeId;
@synthesize analystImage = _analystImage;
@synthesize label = _label;
@synthesize byname = _byname;
@synthesize articleId = _articleId;
@synthesize analystName = _analystName;
@synthesize imageUrl = _imageUrl;
@synthesize oName = _oName;
@synthesize typeName = _typeName;
@synthesize articleTitle = _articleTitle;
@synthesize summary = _summary;
@synthesize likeNum = _likeNum;
@synthesize articleDate = _articleDate;
@synthesize virtualHits = _virtualHits;
@synthesize tName = _tName;


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
            self.articleTypeId = [self objectOrNilForKey:kConsultListModelArticleTypeId fromDictionary:dict];
            self.analystImage = [self objectOrNilForKey:kConsultListModelAnalystImage fromDictionary:dict];
            self.label = [self objectOrNilForKey:kConsultListModelLabel fromDictionary:dict];
            self.byname = [self objectOrNilForKey:kConsultListModelByname fromDictionary:dict];
            self.articleId = [self objectOrNilForKey:kConsultListModelArticleId fromDictionary:dict];
            self.analystName = [self objectOrNilForKey:kConsultListModelAnalystName fromDictionary:dict];
            self.imageUrl = [self objectOrNilForKey:kConsultListModelImageUrl fromDictionary:dict];
            self.oName = [self objectOrNilForKey:kConsultListModelOName fromDictionary:dict];
            self.typeName = [self objectOrNilForKey:kConsultListModelTypeName fromDictionary:dict];
            self.articleTitle = [self objectOrNilForKey:kConsultListModelArticleTitle fromDictionary:dict];
            self.summary = [self objectOrNilForKey:kConsultListModelSummary fromDictionary:dict];
            self.likeNum = [self objectOrNilForKey:kConsultListModelLikeNum fromDictionary:dict];
            self.articleDate = [self objectOrNilForKey:kConsultListModelArticleDate fromDictionary:dict];
            self.virtualHits = [self objectOrNilForKey:kConsultListModelVirtualHits fromDictionary:dict];
            self.tName = [self objectOrNilForKey:kConsultListModelTName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.articleTypeId forKey:kConsultListModelArticleTypeId];
    [mutableDict setValue:self.analystImage forKey:kConsultListModelAnalystImage];
    [mutableDict setValue:self.label forKey:kConsultListModelLabel];
    [mutableDict setValue:self.byname forKey:kConsultListModelByname];
    [mutableDict setValue:self.articleId forKey:kConsultListModelArticleId];
    [mutableDict setValue:self.analystName forKey:kConsultListModelAnalystName];
    [mutableDict setValue:self.imageUrl forKey:kConsultListModelImageUrl];
    [mutableDict setValue:self.oName forKey:kConsultListModelOName];
    [mutableDict setValue:self.typeName forKey:kConsultListModelTypeName];
    [mutableDict setValue:self.articleTitle forKey:kConsultListModelArticleTitle];
    [mutableDict setValue:self.summary forKey:kConsultListModelSummary];
    [mutableDict setValue:self.likeNum forKey:kConsultListModelLikeNum];
    [mutableDict setValue:self.articleDate forKey:kConsultListModelArticleDate];
    [mutableDict setValue:self.virtualHits forKey:kConsultListModelVirtualHits];
    [mutableDict setValue:self.tName forKey:kConsultListModelTName];

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

    self.articleTypeId = [aDecoder decodeObjectForKey:kConsultListModelArticleTypeId];
    self.analystImage = [aDecoder decodeObjectForKey:kConsultListModelAnalystImage];
    self.label = [aDecoder decodeObjectForKey:kConsultListModelLabel];
    self.byname = [aDecoder decodeObjectForKey:kConsultListModelByname];
    self.articleId = [aDecoder decodeObjectForKey:kConsultListModelArticleId];
    self.analystName = [aDecoder decodeObjectForKey:kConsultListModelAnalystName];
    self.imageUrl = [aDecoder decodeObjectForKey:kConsultListModelImageUrl];
    self.oName = [aDecoder decodeObjectForKey:kConsultListModelOName];
    self.typeName = [aDecoder decodeObjectForKey:kConsultListModelTypeName];
    self.articleTitle = [aDecoder decodeObjectForKey:kConsultListModelArticleTitle];
    self.summary = [aDecoder decodeObjectForKey:kConsultListModelSummary];
    self.likeNum = [aDecoder decodeObjectForKey:kConsultListModelLikeNum];
    self.articleDate = [aDecoder decodeObjectForKey:kConsultListModelArticleDate];
    self.virtualHits = [aDecoder decodeObjectForKey:kConsultListModelVirtualHits];
    self.tName = [aDecoder decodeObjectForKey:kConsultListModelTName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_articleTypeId forKey:kConsultListModelArticleTypeId];
    [aCoder encodeObject:_analystImage forKey:kConsultListModelAnalystImage];
    [aCoder encodeObject:_label forKey:kConsultListModelLabel];
    [aCoder encodeObject:_byname forKey:kConsultListModelByname];
    [aCoder encodeObject:_articleId forKey:kConsultListModelArticleId];
    [aCoder encodeObject:_analystName forKey:kConsultListModelAnalystName];
    [aCoder encodeObject:_imageUrl forKey:kConsultListModelImageUrl];
    [aCoder encodeObject:_oName forKey:kConsultListModelOName];
    [aCoder encodeObject:_typeName forKey:kConsultListModelTypeName];
    [aCoder encodeObject:_articleTitle forKey:kConsultListModelArticleTitle];
    [aCoder encodeObject:_summary forKey:kConsultListModelSummary];
    [aCoder encodeObject:_likeNum forKey:kConsultListModelLikeNum];
    [aCoder encodeObject:_articleDate forKey:kConsultListModelArticleDate];
    [aCoder encodeObject:_virtualHits forKey:kConsultListModelVirtualHits];
    [aCoder encodeObject:_tName forKey:kConsultListModelTName];
}

- (id)copyWithZone:(NSZone *)zone
{
    ConsultListModel *copy = [[ConsultListModel alloc] init];
    
    if (copy) {

        copy.articleTypeId = [self.articleTypeId copyWithZone:zone];
        copy.analystImage = [self.analystImage copyWithZone:zone];
        copy.label = [self.label copyWithZone:zone];
        copy.byname = [self.byname copyWithZone:zone];
        copy.articleId = [self.articleId copyWithZone:zone];
        copy.analystName = [self.analystName copyWithZone:zone];
        copy.imageUrl = [self.imageUrl copyWithZone:zone];
        copy.oName = [self.oName copyWithZone:zone];
        copy.typeName = [self.typeName copyWithZone:zone];
        copy.articleTitle = [self.articleTitle copyWithZone:zone];
        copy.summary = [self.summary copyWithZone:zone];
        copy.likeNum = [self.likeNum copyWithZone:zone];
        copy.articleDate = [self.articleDate copyWithZone:zone];
        copy.virtualHits = [self.virtualHits copyWithZone:zone];
        copy.tName = [self.tName copyWithZone:zone];
    }
    
    return copy;
}


@end
