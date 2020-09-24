//
//  AccountInfo.m
//
//  Created by   on 17/2/10
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "AccountInfo.h"

NSString *const kAccountInfoHead = @"head";
NSString *const kAccountInfoDefaultHead = @"head_temp";
NSString *const kAccountInfoDeviceToken = @"deviceToken";
NSString *const kAccountInfoId = @"id";
NSString *const kAccountInfoLevel = @"level";
NSString *const kAccountInfoWorkstatus = @"workstatus";
NSString *const kAccountInfoRefToken = @"refToken";
NSString *const kAccountInfoPhoneStatus = @"phone_status";
NSString *const kAccountInfoVerify = @"verify";
NSString *const kAccountInfoAddress = @"address";
NSString *const kAccountInfoRegIp = @"reg_ip";
NSString *const kAccountInfoNickname = @"nickname";
NSString *const kAccountInfoLastloginIp = @"lastlogin_ip";
NSString *const kAccountInfoRealname = @"realname";
NSString *const kAccountInfoRegTime = @"reg_time";
NSString *const kAccountInfoIsleader = @"isleader";
NSString *const kAccountInfoTuijiancode = @"tuijiancode";
NSString *const kAccountInfoSex = @"sex";
NSString *const kAccountInfoIdcard = @"idcard";
NSString *const kAccountInfoSalt = @"salt";
NSString *const kAccountInfoEmail = @"email";
NSString *const kAccountInfoArea = @"area";
NSString *const kAccountInfoBirthday = @"birthday";
NSString *const kAccountInfoGroupidId = @"groupid_id";
NSString *const kAccountInfoLastloginTime = @"lastlogin_time";
NSString *const kAccountInfoRealnameStatus = @"realname_status";
NSString *const kAccountInfoUsername = @"username";
NSString *const kAccountInfoStatus = @"status";
NSString *const kAccountInfoEcSalt = @"ec_salt";
NSString *const kAccountInfoLeader = @"leader";
NSString *const kAccountInfoPreference = @"preference";
NSString *const kAccountInfoEmailStatus = @"email_status";
NSString *const kAccountInfoGroupId = @"group_id";
NSString *const kAccountInfoLoginNum = @"login_num";
NSString *const kAccountInfoUToken = @"u_token";
NSString *const kAccountInfoCompanyid = @"companyid";
NSString *const kAccountInfoPassword = @"password";
NSString *const kAccountInfoPhone = @"phone";
NSString *const kAccountInfoIsRecharge = @"is_recharge";
NSString *const kAccountInfoIsHaveJdInfo = @"is_have_card";
NSString *const kAccountInfoWeChat = @"weixin_openid";
NSString *const kAccountInfoQQ = @"qq_openid";
NSString *const kAccountInfoIsOpenAccount = @"is_trad_rg";


@interface AccountInfo ()

@property (nonatomic, strong) NSString *nickname;

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AccountInfo

@synthesize head = _head;
@synthesize defaultHead = _defaultHead;
@synthesize deviceToken = _deviceToken;
@synthesize userID = _userID;
@synthesize level = _level;
@synthesize workstatus = _workstatus;
@synthesize refToken = _refToken;
@synthesize phoneStatus = _phoneStatus;
@synthesize verify = _verify;
@synthesize address = _address;
@synthesize regIp = _regIp;
@synthesize nickname = _nickname;
@synthesize lastloginIp = _lastloginIp;
@synthesize realname = _realname;
@synthesize regTime = _regTime;
@synthesize isleader = _isleader;
@synthesize tuijiancode = _tuijiancode;
@synthesize sex = _sex;
@synthesize idcard = _idcard;
@synthesize salt = _salt;
@synthesize email = _email;
@synthesize area = _area;
@synthesize birthday = _birthday;
@synthesize groupidId = _groupidId;
@synthesize lastloginTime = _lastloginTime;
@synthesize realnameStatus = _realnameStatus;
@synthesize username = _username;
@synthesize status = _status;
@synthesize ecSalt = _ecSalt;
@synthesize leader = _leader;
@synthesize preference = _preference;
@synthesize emailStatus = _emailStatus;
@synthesize groupId = _groupId;
@synthesize loginNum = _loginNum;
@synthesize uToken = _uToken;
@synthesize companyid = _companyid;
@synthesize password = _password;
@synthesize phone = _phone;
@synthesize isRecharge = _isRecharge;
@synthesize isHaveJdInfo = _isHaveJdInfo;
@synthesize weChatUid = _weChatUid;
@synthesize qqUid = _qqUid;
@synthesize isOpenAccount = _isOpenAccount;

- (instancetype)init{
    self = [super init];
    if (self) {
        self.username = DemoData.nickNameArray[arc4random() % k_DemoData_nickName_count];
        self.head = DemoData.headPathArray[arc4random() % k_DemoData_HeadPath_count];
    }
    return self;
}

static  AccountInfo*user = nil;
static dispatch_once_t rootOnceToken;
+ (AccountInfo *)standardAccountInfo{
    dispatch_once(&rootOnceToken, ^{
        user = [AccountInfo readAccountInfo];
        if (user == nil){
            user = [[AccountInfo alloc]init];
        }
    });
    return user;
}

+ (AccountInfo *)readAccountInfo{
    NSData *data = [[NSData alloc] initWithContentsOfFile:[AccountInfo getFilePath]];
    // 2,创建一个反序列化器,把要读的数据 传给它,让它读数据
    NSKeyedUnarchiver *unrachiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    // 3,从反序列化器中解码出数组
    AccountInfo *account = (AccountInfo *) [unrachiver decodeObject];
    // 4 结束解码
    [unrachiver finishDecoding];
    return account;
}

+ (NSString *)getFilePath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/accountInfo.plist"];//Appending 添加 Component 成分 Directory目录;
}

- (BOOL)storeAccountInfo{
    //    把原本不能够直接写入到文件中的对象(_array)--->>编码成NSData--->writeToFile
    
    // 1,创建一个空的data(类似于一个袋子),用来让序列化器把 编码之后的data存放起来
    NSMutableData *data = [[NSMutableData alloc] init];
    
    // 2,创建一个序列化器,并且给它一个空的data,用来存放编码之后的数据
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    // 3,把数组进行编码
    [archive encodeObject:[AccountInfo standardAccountInfo]];//encode 编码
    
    // 4,结束编码
    [archive finishEncoding];
    
    //    NSLog(@"data  %@",data);
    
    // 5,把data写入文件
    BOOL isSuccees = [data writeToFile:[AccountInfo getFilePath] atomically:YES];
    NSLog(@"用户信息存储 ------ %d",isSuccees);
    return isSuccees;
}

- (BOOL)logoutAccount
{
    NSFileManager *fmanager=[NSFileManager defaultManager];
    BOOL isSucceed = [fmanager removeItemAtPath:[AccountInfo getFilePath] error:nil];
    
    
    [UserLocalData clearAllUserLocalData];
    
    if ([ThirdLoginModel isExitThirdAccountInfo])
    {
        [ThirdLoginModel logoutThirdAccount];
    }
        
    
    
    if (isSucceed)
    {
        //释放单利
        user = nil;
        rootOnceToken = 0l;
        //清除本地 收货地址
    }
    return isSucceed;
}

+ (instancetype)modelObjectWithThirdModel:(ThirdLoginModel *)model//第三方登录，信息残缺
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    account.head = model.iconurl;
    account.nickname = model.nickname;
    [model storeThirdAccountInfo];
    
    return [AccountInfo standardAccountInfo];
}

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    AccountInfo *model = [AccountInfo standardAccountInfo];
    [model parserDataWithDictionary:dict];
    return [AccountInfo standardAccountInfo];
}

- (void)parserDataWithDictionary:(NSDictionary *)dict
{
    if(self && [dict isKindOfClass:[NSDictionary class]])
    {
        self.head = [self objectOrNilForKey:kAccountInfoHead fromDictionary:dict];
        self.defaultHead = [self objectOrNilForKey:kAccountInfoDefaultHead fromDictionary:dict];
        self.deviceToken = [self objectOrNilForKey:kAccountInfoDeviceToken fromDictionary:dict];
        self.userID = [self objectOrNilForKey:kAccountInfoId fromDictionary:dict];
        self.level = [self objectOrNilForKey:kAccountInfoLevel fromDictionary:dict];
        self.workstatus = [self objectOrNilForKey:kAccountInfoWorkstatus fromDictionary:dict];
        self.refToken = [self objectOrNilForKey:kAccountInfoRefToken fromDictionary:dict];
        self.phoneStatus = [self objectOrNilForKey:kAccountInfoPhoneStatus fromDictionary:dict];
        self.verify = [self objectOrNilForKey:kAccountInfoVerify fromDictionary:dict];
        self.address = [self objectOrNilForKey:kAccountInfoAddress fromDictionary:dict];
        self.regIp = [self objectOrNilForKey:kAccountInfoRegIp fromDictionary:dict];
        self.nickname = [self objectOrNilForKey:kAccountInfoNickname fromDictionary:dict];
        self.lastloginIp = [self objectOrNilForKey:kAccountInfoLastloginIp fromDictionary:dict];
        self.realname = [self objectOrNilForKey:kAccountInfoRealname fromDictionary:dict];
        self.regTime = [self objectOrNilForKey:kAccountInfoRegTime fromDictionary:dict];
        self.isleader = [self objectOrNilForKey:kAccountInfoIsleader fromDictionary:dict];
        self.tuijiancode = [self objectOrNilForKey:kAccountInfoTuijiancode fromDictionary:dict];
        self.sex = [self objectOrNilForKey:kAccountInfoSex fromDictionary:dict];
        self.idcard = [self objectOrNilForKey:kAccountInfoIdcard fromDictionary:dict];
        self.salt = [self objectOrNilForKey:kAccountInfoSalt fromDictionary:dict];
        self.email = [self objectOrNilForKey:kAccountInfoEmail fromDictionary:dict];
        self.area = [self objectOrNilForKey:kAccountInfoArea fromDictionary:dict];
        self.birthday = [self objectOrNilForKey:kAccountInfoBirthday fromDictionary:dict];
        self.groupidId = [self objectOrNilForKey:kAccountInfoGroupidId fromDictionary:dict];
        self.lastloginTime = [self objectOrNilForKey:kAccountInfoLastloginTime fromDictionary:dict];
        self.realnameStatus = [self objectOrNilForKey:kAccountInfoRealnameStatus fromDictionary:dict];
        self.username = [self objectOrNilForKey:kAccountInfoUsername fromDictionary:dict];
        self.status = [self objectOrNilForKey:kAccountInfoStatus fromDictionary:dict];
        self.ecSalt = [self objectOrNilForKey:kAccountInfoEcSalt fromDictionary:dict];
        self.leader = [self objectOrNilForKey:kAccountInfoLeader fromDictionary:dict];
        self.preference = [self objectOrNilForKey:kAccountInfoPreference fromDictionary:dict];
        self.emailStatus = [self objectOrNilForKey:kAccountInfoEmailStatus fromDictionary:dict];
        self.groupId = [self objectOrNilForKey:kAccountInfoGroupId fromDictionary:dict];
        self.loginNum = [self objectOrNilForKey:kAccountInfoLoginNum fromDictionary:dict];
        self.uToken = [self objectOrNilForKey:kAccountInfoUToken fromDictionary:dict];
        self.companyid = [self objectOrNilForKey:kAccountInfoCompanyid fromDictionary:dict];
        self.password = [self objectOrNilForKey:kAccountInfoPassword fromDictionary:dict];
        self.phone = [self objectOrNilForKey:kAccountInfoPhone fromDictionary:dict];
        self.isRecharge = [self objectOrNilForKey:kAccountInfoIsRecharge fromDictionary:dict];
        self.isHaveJdInfo = [self objectOrNilForKey:kAccountInfoIsHaveJdInfo fromDictionary:dict];

        self.weChatUid = [self objectOrNilForKey:kAccountInfoWeChat fromDictionary:dict];
        self.qqUid = [self objectOrNilForKey:kAccountInfoQQ fromDictionary:dict];
        self.isOpenAccount = [self objectOrNilForKey:kAccountInfoIsOpenAccount fromDictionary:dict];
        
        
        
        if (self.head == nil || self.head.length < 2)
        {
            self.head = self.defaultHead;
        }

    }

}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.head = [self objectOrNilForKey:kAccountInfoHead fromDictionary:dict];
            self.deviceToken = [self objectOrNilForKey:kAccountInfoDeviceToken fromDictionary:dict];
            self.userID = [self objectOrNilForKey:kAccountInfoId fromDictionary:dict];
            self.level = [self objectOrNilForKey:kAccountInfoLevel fromDictionary:dict];
            self.workstatus = [self objectOrNilForKey:kAccountInfoWorkstatus fromDictionary:dict];
            self.refToken = [self objectOrNilForKey:kAccountInfoRefToken fromDictionary:dict];
            self.phoneStatus = [self objectOrNilForKey:kAccountInfoPhoneStatus fromDictionary:dict];
            self.verify = [self objectOrNilForKey:kAccountInfoVerify fromDictionary:dict];
            self.address = [self objectOrNilForKey:kAccountInfoAddress fromDictionary:dict];
            self.regIp = [self objectOrNilForKey:kAccountInfoRegIp fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kAccountInfoNickname fromDictionary:dict];
            self.lastloginIp = [self objectOrNilForKey:kAccountInfoLastloginIp fromDictionary:dict];
            self.realname = [self objectOrNilForKey:kAccountInfoRealname fromDictionary:dict];
            self.regTime = [self objectOrNilForKey:kAccountInfoRegTime fromDictionary:dict];
            self.isleader = [self objectOrNilForKey:kAccountInfoIsleader fromDictionary:dict];
            self.tuijiancode = [self objectOrNilForKey:kAccountInfoTuijiancode fromDictionary:dict];
            self.sex = [self objectOrNilForKey:kAccountInfoSex fromDictionary:dict];
            self.idcard = [self objectOrNilForKey:kAccountInfoIdcard fromDictionary:dict];
            self.salt = [self objectOrNilForKey:kAccountInfoSalt fromDictionary:dict];
            self.email = [self objectOrNilForKey:kAccountInfoEmail fromDictionary:dict];
            self.area = [self objectOrNilForKey:kAccountInfoArea fromDictionary:dict];
            self.birthday = [self objectOrNilForKey:kAccountInfoBirthday fromDictionary:dict];
            self.groupidId = [self objectOrNilForKey:kAccountInfoGroupidId fromDictionary:dict];
            self.lastloginTime = [self objectOrNilForKey:kAccountInfoLastloginTime fromDictionary:dict];
            self.realnameStatus = [self objectOrNilForKey:kAccountInfoRealnameStatus fromDictionary:dict];
            self.username = [self objectOrNilForKey:kAccountInfoUsername fromDictionary:dict];
            self.status = [self objectOrNilForKey:kAccountInfoStatus fromDictionary:dict];
            self.ecSalt = [self objectOrNilForKey:kAccountInfoEcSalt fromDictionary:dict];
            self.leader = [self objectOrNilForKey:kAccountInfoLeader fromDictionary:dict];
            self.preference = [self objectOrNilForKey:kAccountInfoPreference fromDictionary:dict];
            self.emailStatus = [self objectOrNilForKey:kAccountInfoEmailStatus fromDictionary:dict];
            self.groupId = [self objectOrNilForKey:kAccountInfoGroupId fromDictionary:dict];
            self.loginNum = [self objectOrNilForKey:kAccountInfoLoginNum fromDictionary:dict];
            self.uToken = [self objectOrNilForKey:kAccountInfoUToken fromDictionary:dict];
            self.companyid = [self objectOrNilForKey:kAccountInfoCompanyid fromDictionary:dict];
            self.password = [self objectOrNilForKey:kAccountInfoPassword fromDictionary:dict];
            self.phone = [self objectOrNilForKey:kAccountInfoPhone fromDictionary:dict];
        self.isRecharge = [self objectOrNilForKey:kAccountInfoIsRecharge fromDictionary:dict];
        self.isHaveJdInfo = [self objectOrNilForKey:kAccountInfoIsHaveJdInfo fromDictionary:dict];
        self.weChatUid = [self objectOrNilForKey:kAccountInfoWeChat fromDictionary:dict];
        self.qqUid = [self objectOrNilForKey:kAccountInfoQQ fromDictionary:dict];
        self.isOpenAccount = [self objectOrNilForKey:kAccountInfoIsOpenAccount fromDictionary:dict];
        self.defaultHead = [self objectOrNilForKey:kAccountInfoDefaultHead fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.head forKey:kAccountInfoHead];
    [mutableDict setValue:self.deviceToken forKey:kAccountInfoDeviceToken];
    [mutableDict setValue:self.userID forKey:kAccountInfoId];
    [mutableDict setValue:self.level forKey:kAccountInfoLevel];
    [mutableDict setValue:self.workstatus forKey:kAccountInfoWorkstatus];
    [mutableDict setValue:self.refToken forKey:kAccountInfoRefToken];
    [mutableDict setValue:self.phoneStatus forKey:kAccountInfoPhoneStatus];
    [mutableDict setValue:self.verify forKey:kAccountInfoVerify];
    [mutableDict setValue:self.address forKey:kAccountInfoAddress];
    [mutableDict setValue:self.regIp forKey:kAccountInfoRegIp];
    [mutableDict setValue:self.nickname forKey:kAccountInfoNickname];
    [mutableDict setValue:self.lastloginIp forKey:kAccountInfoLastloginIp];
    [mutableDict setValue:self.realname forKey:kAccountInfoRealname];
    [mutableDict setValue:self.regTime forKey:kAccountInfoRegTime];
    [mutableDict setValue:self.isleader forKey:kAccountInfoIsleader];
    [mutableDict setValue:self.tuijiancode forKey:kAccountInfoTuijiancode];
    [mutableDict setValue:self.sex forKey:kAccountInfoSex];
    [mutableDict setValue:self.idcard forKey:kAccountInfoIdcard];
    [mutableDict setValue:self.salt forKey:kAccountInfoSalt];
    [mutableDict setValue:self.email forKey:kAccountInfoEmail];
    [mutableDict setValue:self.area forKey:kAccountInfoArea];
    [mutableDict setValue:self.birthday forKey:kAccountInfoBirthday];
    [mutableDict setValue:self.groupidId forKey:kAccountInfoGroupidId];
    [mutableDict setValue:self.lastloginTime forKey:kAccountInfoLastloginTime];
    [mutableDict setValue:self.realnameStatus forKey:kAccountInfoRealnameStatus];
    [mutableDict setValue:self.username forKey:kAccountInfoUsername];
    [mutableDict setValue:self.status forKey:kAccountInfoStatus];
    [mutableDict setValue:self.ecSalt forKey:kAccountInfoEcSalt];
    [mutableDict setValue:self.leader forKey:kAccountInfoLeader];
    [mutableDict setValue:self.preference forKey:kAccountInfoPreference];
    [mutableDict setValue:self.emailStatus forKey:kAccountInfoEmailStatus];
    [mutableDict setValue:self.groupId forKey:kAccountInfoGroupId];
    [mutableDict setValue:self.loginNum forKey:kAccountInfoLoginNum];
    [mutableDict setValue:self.uToken forKey:kAccountInfoUToken];
    [mutableDict setValue:self.companyid forKey:kAccountInfoCompanyid];
    [mutableDict setValue:self.password forKey:kAccountInfoPassword];
    [mutableDict setValue:self.phone forKey:kAccountInfoPhone];
    [mutableDict setValue:self.isRecharge forKey:kAccountInfoIsRecharge];
    [mutableDict setValue:self.isHaveJdInfo forKey:kAccountInfoIsHaveJdInfo];
    [mutableDict setValue:self.weChatUid forKey:kAccountInfoWeChat];
    [mutableDict setValue:self.qqUid forKey:kAccountInfoQQ];
    [mutableDict setValue:self.isOpenAccount forKey:kAccountInfoIsOpenAccount];
    [mutableDict setValue:self.defaultHead forKey:kAccountInfoDefaultHead];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    
    if ([dict.allKeys containsObject:aKey])
    {
        id object = [dict objectForKey:aKey];
        return [object isEqual:[NSNull null]] ? @"" : object;
    }
    else
    {
        return @"";
    }
    
    

}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.head = [aDecoder decodeObjectForKey:kAccountInfoHead];
    self.deviceToken = [aDecoder decodeObjectForKey:kAccountInfoDeviceToken];
    self.userID = [aDecoder decodeObjectForKey:kAccountInfoId];
    self.level = [aDecoder decodeObjectForKey:kAccountInfoLevel];
    self.workstatus = [aDecoder decodeObjectForKey:kAccountInfoWorkstatus];
    self.refToken = [aDecoder decodeObjectForKey:kAccountInfoRefToken];
    self.phoneStatus = [aDecoder decodeObjectForKey:kAccountInfoPhoneStatus];
    self.verify = [aDecoder decodeObjectForKey:kAccountInfoVerify];
    self.address = [aDecoder decodeObjectForKey:kAccountInfoAddress];
    self.regIp = [aDecoder decodeObjectForKey:kAccountInfoRegIp];
    self.nickname = [aDecoder decodeObjectForKey:kAccountInfoNickname];
    self.lastloginIp = [aDecoder decodeObjectForKey:kAccountInfoLastloginIp];
    self.realname = [aDecoder decodeObjectForKey:kAccountInfoRealname];
    self.regTime = [aDecoder decodeObjectForKey:kAccountInfoRegTime];
    self.isleader = [aDecoder decodeObjectForKey:kAccountInfoIsleader];
    self.tuijiancode = [aDecoder decodeObjectForKey:kAccountInfoTuijiancode];
    self.sex = [aDecoder decodeObjectForKey:kAccountInfoSex];
    self.idcard = [aDecoder decodeObjectForKey:kAccountInfoIdcard];
    self.salt = [aDecoder decodeObjectForKey:kAccountInfoSalt];
    self.email = [aDecoder decodeObjectForKey:kAccountInfoEmail];
    self.area = [aDecoder decodeObjectForKey:kAccountInfoArea];
    self.birthday = [aDecoder decodeObjectForKey:kAccountInfoBirthday];
    self.groupidId = [aDecoder decodeObjectForKey:kAccountInfoGroupidId];
    self.lastloginTime = [aDecoder decodeObjectForKey:kAccountInfoLastloginTime];
    self.realnameStatus = [aDecoder decodeObjectForKey:kAccountInfoRealnameStatus];
    self.username = [aDecoder decodeObjectForKey:kAccountInfoUsername];
    self.status = [aDecoder decodeObjectForKey:kAccountInfoStatus];
    self.ecSalt = [aDecoder decodeObjectForKey:kAccountInfoEcSalt];
    self.leader = [aDecoder decodeObjectForKey:kAccountInfoLeader];
    self.preference = [aDecoder decodeObjectForKey:kAccountInfoPreference];
    self.emailStatus = [aDecoder decodeObjectForKey:kAccountInfoEmailStatus];
    self.groupId = [aDecoder decodeObjectForKey:kAccountInfoGroupId];
    self.loginNum = [aDecoder decodeObjectForKey:kAccountInfoLoginNum];
    self.uToken = [aDecoder decodeObjectForKey:kAccountInfoUToken];
    self.companyid = [aDecoder decodeObjectForKey:kAccountInfoCompanyid];
    self.password = [aDecoder decodeObjectForKey:kAccountInfoPassword];
    self.phone = [aDecoder decodeObjectForKey:kAccountInfoPhone];
    self.isRecharge = [aDecoder decodeObjectForKey:kAccountInfoIsRecharge];
    self.isHaveJdInfo = [aDecoder decodeObjectForKey:kAccountInfoIsHaveJdInfo];
    self.weChatUid = [aDecoder decodeObjectForKey:kAccountInfoWeChat];
    self.qqUid = [aDecoder decodeObjectForKey:kAccountInfoQQ];
    self.isOpenAccount = [aDecoder decodeObjectForKey:kAccountInfoIsOpenAccount];
    self.defaultHead = [aDecoder decodeObjectForKey:kAccountInfoDefaultHead];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_head forKey:kAccountInfoHead];
    [aCoder encodeObject:_deviceToken forKey:kAccountInfoDeviceToken];
    [aCoder encodeObject:_userID forKey:kAccountInfoId];
    [aCoder encodeObject:_level forKey:kAccountInfoLevel];
    [aCoder encodeObject:_workstatus forKey:kAccountInfoWorkstatus];
    [aCoder encodeObject:_refToken forKey:kAccountInfoRefToken];
    [aCoder encodeObject:_phoneStatus forKey:kAccountInfoPhoneStatus];
    [aCoder encodeObject:_verify forKey:kAccountInfoVerify];
    [aCoder encodeObject:_address forKey:kAccountInfoAddress];
    [aCoder encodeObject:_regIp forKey:kAccountInfoRegIp];
    [aCoder encodeObject:_nickname forKey:kAccountInfoNickname];
    [aCoder encodeObject:_lastloginIp forKey:kAccountInfoLastloginIp];
    [aCoder encodeObject:_realname forKey:kAccountInfoRealname];
    [aCoder encodeObject:_regTime forKey:kAccountInfoRegTime];
    [aCoder encodeObject:_isleader forKey:kAccountInfoIsleader];
    [aCoder encodeObject:_tuijiancode forKey:kAccountInfoTuijiancode];
    [aCoder encodeObject:_sex forKey:kAccountInfoSex];
    [aCoder encodeObject:_idcard forKey:kAccountInfoIdcard];
    [aCoder encodeObject:_salt forKey:kAccountInfoSalt];
    [aCoder encodeObject:_email forKey:kAccountInfoEmail];
    [aCoder encodeObject:_area forKey:kAccountInfoArea];
    [aCoder encodeObject:_birthday forKey:kAccountInfoBirthday];
    [aCoder encodeObject:_groupidId forKey:kAccountInfoGroupidId];
    [aCoder encodeObject:_lastloginTime forKey:kAccountInfoLastloginTime];
    [aCoder encodeObject:_realnameStatus forKey:kAccountInfoRealnameStatus];
    [aCoder encodeObject:_username forKey:kAccountInfoUsername];
    [aCoder encodeObject:_status forKey:kAccountInfoStatus];
    [aCoder encodeObject:_ecSalt forKey:kAccountInfoEcSalt];
    [aCoder encodeObject:_leader forKey:kAccountInfoLeader];
    [aCoder encodeObject:_preference forKey:kAccountInfoPreference];
    [aCoder encodeObject:_emailStatus forKey:kAccountInfoEmailStatus];
    [aCoder encodeObject:_groupId forKey:kAccountInfoGroupId];
    [aCoder encodeObject:_loginNum forKey:kAccountInfoLoginNum];
    [aCoder encodeObject:_uToken forKey:kAccountInfoUToken];
    [aCoder encodeObject:_companyid forKey:kAccountInfoCompanyid];
    [aCoder encodeObject:_password forKey:kAccountInfoPassword];
    [aCoder encodeObject:_phone forKey:kAccountInfoPhone];
    [aCoder encodeObject:_isRecharge forKey:kAccountInfoIsRecharge];
    [aCoder encodeObject:_isHaveJdInfo forKey:kAccountInfoIsHaveJdInfo];
    [aCoder encodeObject:_weChatUid forKey:kAccountInfoWeChat];
    [aCoder encodeObject:_qqUid forKey:kAccountInfoQQ];
    [aCoder encodeObject:_isOpenAccount forKey:kAccountInfoIsOpenAccount];
    [aCoder encodeObject:_defaultHead forKey:kAccountInfoDefaultHead];

}

- (id)copyWithZone:(NSZone *)zone
{
    AccountInfo *copy = [[AccountInfo alloc] init];
    
    if (copy) {

        copy.head = [self.head copyWithZone:zone];
        copy.deviceToken = [self.deviceToken copyWithZone:zone];
        copy.userID = [self.userID copyWithZone:zone];
        copy.level = [self.level copyWithZone:zone];
        copy.workstatus = [self.workstatus copyWithZone:zone];
        copy.refToken = [self.refToken copyWithZone:zone];
        copy.phoneStatus = [self.phoneStatus copyWithZone:zone];
        copy.verify = [self.verify copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.regIp = [self.regIp copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.lastloginIp = [self.lastloginIp copyWithZone:zone];
        copy.realname = [self.realname copyWithZone:zone];
        copy.regTime = [self.regTime copyWithZone:zone];
        copy.isleader = [self.isleader copyWithZone:zone];
        copy.tuijiancode = [self.tuijiancode copyWithZone:zone];
        copy.sex = [self.sex copyWithZone:zone];
        copy.idcard = [self.idcard copyWithZone:zone];
        copy.salt = [self.salt copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.area = [self.area copyWithZone:zone];
        copy.birthday = [self.birthday copyWithZone:zone];
        copy.groupidId = [self.groupidId copyWithZone:zone];
        copy.lastloginTime = [self.lastloginTime copyWithZone:zone];
        copy.realnameStatus = [self.realnameStatus copyWithZone:zone];
        copy.username = [self.username copyWithZone:zone];
        copy.status = [self.status copyWithZone:zone];
        copy.ecSalt = [self.ecSalt copyWithZone:zone];
        copy.leader = [self.leader copyWithZone:zone];
        copy.preference = [self.preference copyWithZone:zone];
        copy.emailStatus = [self.emailStatus copyWithZone:zone];
        copy.groupId = [self.groupId copyWithZone:zone];
        copy.loginNum = [self.loginNum copyWithZone:zone];
        copy.uToken = [self.uToken copyWithZone:zone];
        copy.companyid = [self.companyid copyWithZone:zone];
        copy.password = [self.password copyWithZone:zone];
        copy.phone = [self.phone copyWithZone:zone];
        copy.isRecharge = [self.isRecharge copyWithZone:zone];
        copy.isHaveJdInfo = [self.isHaveJdInfo copyWithZone:zone];
        copy.weChatUid = [self.weChatUid copyWithZone:zone];
        copy.qqUid = [self.qqUid copyWithZone:zone];
        copy.isOpenAccount = [self.isOpenAccount copyWithZone:zone];
        copy.defaultHead = [self.defaultHead copyWithZone:zone];

    }
    return copy;
}


#pragma mark - 



- (NSString *)uToken
{
    if (_uToken == nil)
    {
        _uToken = @"";
    }
    
    return _uToken;
}

@end
