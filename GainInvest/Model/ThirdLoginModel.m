//
//  ThirdLoginModel.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/27.
//  Copyright © 2017年 longlong. All rights reserved.
//


NSString *const kInorderModelIconurl = @"iconurl";
NSString *const kInorderModelNickname = @"nickname";
NSString *const kInorderModelUid = @"uid";
NSString *const kInorderModelOpenid = @"openid";
NSString *const kInorderModelAccessToken = @"accessToken";
NSString *const kInorderModelRefreshToken = @"refreshToken";
NSString *const kInorderModelExpiration = @"expiration";
NSString *const kInorderModelPlatfrom = @"platfrom";


#import "ThirdLoginModel.h"

@implementation ThirdLoginModel

@synthesize iconurl = _iconurl;
@synthesize nickname = _nickname;
@synthesize uid = _uid;
@synthesize openid = _openid;
@synthesize accessToken = _accessToken;
@synthesize refreshToken = _refreshToken;
@synthesize expiration = _expiration;
@synthesize platfrom = _platfrom;

+  (BOOL)isExitThirdAccountInfo//本地是否存在三方信息
{
    NSString *path = [ThirdLoginModel getFilePath];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (ThirdLoginModel *)readThirdAccountInfo
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:[ThirdLoginModel getFilePath]];
    
    // 2,创建一个反序列化器,把要读的数据 传给它,让它读数据
    NSKeyedUnarchiver *unrachiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    // 3,从反序列化器中解码出数组
    ThirdLoginModel *account = (ThirdLoginModel *) [unrachiver decodeObject];
    // 4 结束解码
    [unrachiver finishDecoding];
    
    return account;
    
}

- (BOOL)storeThirdAccountInfo
{
    //    把原本不能够直接写入到文件中的对象(_array)--->>编码成NSData--->writeToFile
    
    // 1,创建一个空的data(类似于一个袋子),用来让序列化器把 编码之后的data存放起来
    NSMutableData *data = [[NSMutableData alloc] init];
    
    // 2,创建一个序列化器,并且给它一个空的data,用来存放编码之后的数据
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    // 3,把数组进行编码
    [archive encodeObject:self];//encode 编码
    
    // 4,结束编码
    [archive finishEncoding];
    
    //    NSLog(@"data  %@",data);
    
    // 5,把data写入文件
    BOOL isSuccees = [data writeToFile:[ThirdLoginModel getFilePath] atomically:YES];
    
    
    return isSuccees;
}

+ (BOOL)logoutThirdAccount
{
    NSFileManager *fmanager=[NSFileManager defaultManager];
    BOOL isSucceed = [fmanager removeItemAtPath:[ThirdLoginModel getFilePath] error:nil];
    return isSucceed;
}


+ (NSString *)getFilePath
{
    
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thirdAccountInfo.plist"];//Appending 添加 Component 成分 Directory目录;
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.iconurl = [aDecoder decodeObjectForKey:kInorderModelIconurl];
    self.nickname = [aDecoder decodeObjectForKey:kInorderModelNickname];
    self.uid = [aDecoder decodeObjectForKey:kInorderModelUid];
    self.openid = [aDecoder decodeObjectForKey:kInorderModelOpenid];
    self.accessToken = [aDecoder decodeObjectForKey:kInorderModelAccessToken];
    self.refreshToken = [aDecoder decodeObjectForKey:kInorderModelRefreshToken];
    self.expiration = [aDecoder decodeObjectForKey:kInorderModelExpiration];
    self.platfrom = [aDecoder decodeObjectForKey:kInorderModelPlatfrom];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_iconurl forKey:kInorderModelIconurl];
    [aCoder encodeObject:_nickname forKey:kInorderModelNickname];
    [aCoder encodeObject:_uid forKey:kInorderModelUid];
    [aCoder encodeObject:_openid forKey:kInorderModelOpenid];
    
    [aCoder encodeObject:_accessToken forKey:kInorderModelAccessToken];
    [aCoder encodeObject:_refreshToken forKey:kInorderModelRefreshToken];
    [aCoder encodeObject:_expiration forKey:kInorderModelExpiration];
    [aCoder encodeObject:_platfrom forKey:kInorderModelPlatfrom];

}

- (id)copyWithZone:(NSZone *)zone
{
    ThirdLoginModel *copy = [[ThirdLoginModel alloc] init];
    
    if (copy)
    {
        
        copy.iconurl = [self.iconurl copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.openid = [self.openid copyWithZone:zone];
        
        copy.accessToken = [self.accessToken copyWithZone:zone];
        copy.refreshToken = [self.refreshToken copyWithZone:zone];
        copy.expiration = [self.expiration copyWithZone:zone];
        copy.platfrom = [self.platfrom copyWithZone:zone];
    }
    
    return copy;
}

@end
