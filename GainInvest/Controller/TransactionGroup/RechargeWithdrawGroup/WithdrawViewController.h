//
//  WithdrawViewController.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/24.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionHttpManager.h"

@interface WithdrawViewController : UIViewController

@property (nonatomic ,strong) NSString *accountMoney;

@property (nonatomic ,strong) TransactionHttpManager *httpManager;

@end
// 用户必须登录
