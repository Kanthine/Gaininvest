//
//  AccountManagerVC.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/10.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountManagerVC : UIViewController

@end


/*
 用户账号情况预览：
 
 <1> 没有绑定手机号
    显示：头像，昵称，绑定手机号
 
 <2> 有绑定手机号
 （1）未开户
 显示：头像，昵称，当前账户，修改登录密码，设置交易密码，修改交易密码，绑定第三方
 
 （2）已开户
  显示：头像，昵称，当前账户，修改登录密码，修改交易密码，绑定第三方
 
 */
