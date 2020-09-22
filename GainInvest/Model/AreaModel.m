//
//  AreaModel.m
//
//  Created by   on 17/2/27
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "AreaModel.h"


NSString *const kAreaModelStatus = @"status";
NSString *const kAreaModelId = @"id";
NSString *const kAreaModelListorder = @"listorder";
NSString *const kAreaModelName = @"name";
NSString *const kAreaModelParentid = @"parentid";


@interface AreaModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AreaModel

@synthesize status = _status;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize listorder = _listorder;
@synthesize name = _name;
@synthesize parentid = _parentid;


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
            self.status = [self objectOrNilForKey:kAreaModelStatus fromDictionary:dict];
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kAreaModelId fromDictionary:dict];
            self.listorder = [self objectOrNilForKey:kAreaModelListorder fromDictionary:dict];
            self.name = [self objectOrNilForKey:kAreaModelName fromDictionary:dict];
            self.parentid = [self objectOrNilForKey:kAreaModelParentid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.status forKey:kAreaModelStatus];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kAreaModelId];
    [mutableDict setValue:self.listorder forKey:kAreaModelListorder];
    [mutableDict setValue:self.name forKey:kAreaModelName];
    [mutableDict setValue:self.parentid forKey:kAreaModelParentid];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Sort Order

- (AreaModel *)sortAscendingOrderWithModel:(AreaModel *)model//升序
{
    if ([model.internalBaseClassIdentifier intValue] > [self.internalBaseClassIdentifier intValue])
    {
        return model;
    }
    return self;

}

- (AreaModel *)sortDescendingOrderWithModel:(AreaModel *)model//降序
{
    if ([model.internalBaseClassIdentifier intValue] > [self.internalBaseClassIdentifier intValue])
    {
        return self;
    }
    return model;
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

    self.status = [aDecoder decodeObjectForKey:kAreaModelStatus];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kAreaModelId];
    self.listorder = [aDecoder decodeObjectForKey:kAreaModelListorder];
    self.name = [aDecoder decodeObjectForKey:kAreaModelName];
    self.parentid = [aDecoder decodeObjectForKey:kAreaModelParentid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_status forKey:kAreaModelStatus];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kAreaModelId];
    [aCoder encodeObject:_listorder forKey:kAreaModelListorder];
    [aCoder encodeObject:_name forKey:kAreaModelName];
    [aCoder encodeObject:_parentid forKey:kAreaModelParentid];
}

- (id)copyWithZone:(NSZone *)zone
{
    AreaModel *copy = [[AreaModel alloc] init];
    
    if (copy) {

        copy.status = [self.status copyWithZone:zone];
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.listorder = [self.listorder copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.parentid = [self.parentid copyWithZone:zone];
    }
    
    return copy;
}


@end
