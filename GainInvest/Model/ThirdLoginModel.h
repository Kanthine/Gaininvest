//
//  ThirdLoginModel.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/27.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdLoginModel : NSObject<NSCoding, NSCopying>


@property (nonatomic, strong) NSString *iconurl;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSDate *expiration;
@property (nonatomic, strong) NSString *platfrom;

+ (ThirdLoginModel *)readThirdAccountInfo;
- (BOOL)storeThirdAccountInfo;//存储用户信息
+ (BOOL)logoutThirdAccount;//销毁
+ (BOOL)isExitThirdAccountInfo;//本地是否存在三方信息


@end
