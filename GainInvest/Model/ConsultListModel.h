//
//  ConsultListModel.h
//
//  Created by   on 17/2/13
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//[self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage: [UIImage imageNamed:@"placeholderImage"]];
//self.mainLable.text = model.articleTitle;
//self.authorLable.text = model.analystName;
//self.timeLable.text = model.articleDate;

@interface ConsultListModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *analystName;//分析师 author
@property (nonatomic, strong) NSString *imageUrl;/// 封面
@property (nonatomic, strong) NSString *articleTitle;//标题
@property (nonatomic, strong) NSString *articleDate;//日期
@property (nonatomic, strong) NSString *webURL;//网页链接


@property (nonatomic, strong) NSString *articleTypeId;
@property (nonatomic, strong) NSString *typeName;

@property (nonatomic, strong) NSString *analystImage;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *byname;
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *oName;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *likeNum;
@property (nonatomic, strong) NSString *virtualHits;
@property (nonatomic, strong) NSString *tName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

