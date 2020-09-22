//
//  UserLocalData.m
//  GainInvest
//
//  Created by 苏沫离 on 17/3/22.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define UserDefaults [NSUserDefaults standardUserDefaults]
#define CouponCount @"CouponCount"
#define CouponNews @"CouponIsNews"

#define TradeToken @"TradeToken"
#define TradeTokenStartTime @"TradeEffectiveTime"

#define IMAuthorization @"IMAuthorization"

#define RemoteLogin @"RemoteLogin"

#import "UserLocalData.h"

@implementation UserLocalData

/* 退出登录后消除用户所有本地数据 */
+ (void)clearAllUserLocalData
{
    [UserDefaults removeObjectForKey:CouponCount];
    [UserDefaults removeObjectForKey:CouponNews];
    [UserDefaults removeObjectForKey:TradeToken];
    [UserDefaults removeObjectForKey:TradeTokenStartTime];
    [UserDefaults removeObjectForKey:RemoteLogin];
    [UserDefaults removeObjectForKey:IMAuthorization];
    [UserDefaults synchronize];
}

/* 设置用户的代金券数量 */
+ (void)setCouponCount:(NSUInteger)count
{
    [UserDefaults setObject:@(count) forKey:CouponCount];
    [UserDefaults synchronize];
}

/* 获取用户的代金券数量 */
+ (NSUInteger)getCouponCount
{
    return [[UserDefaults objectForKey:CouponCount] integerValue];
}

/* 设置用户交易的token值 */
+ (void)setTradeToken:(NSString *)tokenString
{
    [UserDefaults setObject:tokenString forKey:TradeToken];
    [UserDefaults setObject:[NSDate date] forKey:TradeTokenStartTime];
    [UserDefaults synchronize];
}

/* 判断用户交易token是否有效 */
+ (BOOL)isTradeEffectiveToken
{
    NSString *tokenString = [UserDefaults objectForKey:TradeToken];
    if (tokenString == nil || tokenString.length < 1)
    {
        return NO;
    }
    
    NSDate *startDate = [UserDefaults objectForKey:TradeTokenStartTime];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:startDate];
    if (timeBetween > 90 * 60)
    {
        //超过有效期
        return NO;
    }
    
    return YES;
}

/* 设置用户是否异地登录 */
+ (void)setRemoteLogin:(BOOL)isRemote
{
    [UserDefaults setObject:@(isRemote) forKey:RemoteLogin];
    [UserDefaults synchronize];
}

/* 判断用户是否异地登录 */
+ (BOOL)isRemoteLogin
{
    BOOL isRemote = [[UserDefaults objectForKey:RemoteLogin] boolValue];
    
    return isRemote;
}

/*
 * IM 是否登录
 */
+ (BOOL)isIM_Authorization
{
    BOOL isLogin = [[UserDefaults objectForKey:IMAuthorization] boolValue];    
    return isLogin;
}

/*
 * IM 设置是否登录
 */
+ (void)setIM_Authorization:(BOOL)isLogin
{
    [UserDefaults setObject:@(isLogin) forKey:IMAuthorization];
    [UserDefaults synchronize];
}


@end
