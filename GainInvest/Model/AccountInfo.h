//
//  AccountInfo.h
//
//  Created by   on 17/2/10
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JdInfoModel.h"

@interface AccountInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *balance;//余额
@property (nonatomic, strong) NSString *head;//用户头像
@property (nonatomic, strong) NSString *userID;//用户ID
@property (nonatomic, strong) NSString *username;//用户昵称
@property (nonatomic, strong) NSString *password;///密码
@property (nonatomic, strong) NSString *phone;///手机号
@property (nonatomic, strong) NSString *uToken;//登录成功后的 token

@property (nonatomic, strong) NSString *weChatUid;//微信登录
@property (nonatomic, strong) NSString *qqUid;//QQ登录


@property (nonatomic, strong) NSString *isRecharge;//是否为第一次充值
//第一次京东充值或者提现之后，服务器缓存用户银行卡信息
@property (nonatomic, strong) NSString *isHaveJdInfo;
@property (nonatomic, strong) JdInfoModel *JdInfo;

@property (nonatomic, strong) NSString *tradePWD;//交易密码
@property (nonatomic, assign) BOOL isOpenAccount;//恒大交易所是否开户


@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *workstatus;
@property (nonatomic, strong) NSString *refToken;
@property (nonatomic, strong) NSString *phoneStatus;
@property (nonatomic, strong) NSString *verify;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *regIp;
@property (nonatomic, strong) NSString *lastloginIp;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *regTime;
@property (nonatomic, strong) NSString *isleader;
@property (nonatomic, strong) NSString *tuijiancode;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *idcard;
@property (nonatomic, strong) NSString *salt;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *groupidId;
@property (nonatomic, strong) NSString *lastloginTime;
@property (nonatomic, strong) NSString *realnameStatus;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *ecSalt;
@property (nonatomic, strong) NSString *leader;
@property (nonatomic, strong) NSString *preference;
@property (nonatomic, strong) NSString *emailStatus;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *loginNum;
@property (nonatomic, strong) NSString *companyid;



+ (AccountInfo *)standardAccountInfo;
- (BOOL)storeAccountInfo;//存储用户信息
- (BOOL)logoutAccount;//销毁


+ (instancetype)modelObjectWithThirdModel:(ThirdLoginModel *)model;//第三方登录，信息残缺
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
