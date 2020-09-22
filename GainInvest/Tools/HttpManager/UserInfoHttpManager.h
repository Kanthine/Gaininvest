//
//  UserInfoHttpManager.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/10.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoHttpManager : NSObject

/* 修改个人信息
 *
 * parameterDict 登录时需要参数：
 * user_id ：用户id
 * nickname 用户昵称
 * headimg  用户头像地址
 * sex      用户性别 0，保密；1，男；2，女
 * birthday 用户生日 2016-02-30
 * minename 个性签名
 *
 */
- (void)updatePersonalInfoParameterDict:(NSDictionary *)parameterDict  CompletionBlock:(void (^) (NSError *error))block;



/* 分享领代金券
 *
 * parameterDict 登录时需要参数：
 * mobile_phone ：用户手机
 *
 */
- (void)shareGetVoucherVCWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block;


/* 问题反馈
 *
 * parameterDict 登录时需要参数：
 * uid ：用户id
 * content ：内容
 * images ：图片组
 */
- (void)feedbackProblemWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block;

@end
