//
//  ConsultListModel.h
//
//  Created by   on 17/2/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ConsultListModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *articleTypeId;
@property (nonatomic, strong) NSString *analystImage;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *byname;
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *analystName;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *oName;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *likeNum;
@property (nonatomic, strong) NSString *articleDate;
@property (nonatomic, strong) NSString *virtualHits;
@property (nonatomic, strong) NSString *tName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
