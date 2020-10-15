//
//  JdInfoModel.h
//
//  Created by   on 17/2/10
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//
//

#import <Foundation/Foundation.h>


//京东签约信息
@interface JdInfoModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *province;//开户省份
@property (nonatomic, strong) NSString *city;//开户城市
@property (nonatomic, strong) NSString *cardBank;//银行编码
@property (nonatomic, strong) NSString *cardIdno;//持卡人证件号
@property (nonatomic, strong) NSString *cardName;//持卡人姓名
@property (nonatomic, strong) NSString *tradeAmount;//交易金额
@property (nonatomic, strong) NSString *subBank;//银行分行
@property (nonatomic, strong) NSString *cardPhone;//持卡人手机号
@property (nonatomic, strong) NSString *cardNo;//银行卡号
@property (nonatomic, strong) NSString *mobilePhone;//手机号

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
