//
//  UserLocalData.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/22.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLocalData : NSObject

/* 退出登录后消除用户所有本地数据 */
+ (void)clearAllUserLocalData;

/* 设置用户的代金券数量 */
+ (void)setCouponCount:(NSUInteger)count;

/* 获取用户的代金券数量 */
+ (NSUInteger)getCouponCount;

/* 设置用户交易的token值 */
+ (void)setTradeToken:(NSString *)tokenString;

/* 判断用户交易token是否有效 */
+ (BOOL)isTradeEffectiveToken;

/* 设置用户是否异地登录 */
+ (void)setRemoteLogin:(BOOL)isRemote;

/* 判断用户是否异地登录 */
+ (BOOL)isRemoteLogin;

/*
 * IM 设置是否登录
 */
+ (void)setIM_Authorization:(BOOL)isLogin;

/*
 * IM 是否登录
 */
+ (BOOL)isIM_Authorization;

@end
