//
//  AreaModel.h
//
//  Created by   on 17/2/27
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AreaModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *listorder;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *parentid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

- (AreaModel *)sortAscendingOrderWithModel:(AreaModel *)model;//升序
- (AreaModel *)sortDescendingOrderWithModel:(AreaModel *)model;//降序

@end
