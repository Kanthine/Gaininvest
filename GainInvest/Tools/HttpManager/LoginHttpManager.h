//
//  LoginHttpManager.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/9.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginHttpManager : NSObject

/*
 * 设置交易密码：
 *
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 */
- (void)setTransactionPasswordWithParameters:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSDictionary *resultDict,NSError *error))block;

/*
 * 重置交易密码：
 *
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 */
- (void)resetTransactionPasswordWithParameters:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSDictionary *resultDict,NSError *error))block;


@end
