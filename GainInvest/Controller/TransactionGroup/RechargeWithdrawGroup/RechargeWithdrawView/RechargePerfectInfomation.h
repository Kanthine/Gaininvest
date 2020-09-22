//
//  RechargePerfectInfomation.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/29.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RechargeInfomationVC;
@interface RechargePerfectInfomation : UIView

@property (nonatomic ,assign) NSInteger currentMoney;

@property (nonatomic ,copy) void (^rechargeInfoSubmitClick)(NSDictionary *infoDict);
@property (nonatomic ,weak) RechargeInfomationVC *currentViewController;

@end
