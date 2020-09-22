//
//  RechargeInfomationVC.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/1.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionHttpManager.h"

@interface RechargeInfomationVC : UIViewController

@property (nonatomic ,assign) NSInteger currentMoney;
@property (nonatomic ,strong) TransactionHttpManager *httpManager;

@end
