//
//  RechargeMethodVerifyView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/2.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeMethodVerifyView : UIView

@property (nonatomic ,strong) UILabel *timeLable;
@property (nonatomic ,copy) void(^ rechargeMethodVerifyCode)(NSString *verCode);
@property (nonatomic ,copy) void(^ rechargeMethodVerifyDismiss)();

- (void)show;

@end
