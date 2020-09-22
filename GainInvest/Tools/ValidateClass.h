//
//  ValidateClass.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/8.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateClass : NSObject

/*
 * 验证手机号
 */
+ (BOOL) isMobile:(NSString *)mobileNumbel;

/*
 * 验证密码是否为 4-8位 且包含字母和数字
 */
+(BOOL)judgePassWordLegal:(NSString *)password;

/*
 * 验证银行卡号
 */
+ (BOOL)isBankCard:(NSString *)cardNumber;

/*
 * 验证身份证号
 */
+ (BOOL)isIdentityCard:(NSString *)IDCardNumber;

@end
