//
//  ActivateTradePwdView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/13.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger ,ActivateTradePwdState)
{
    ActivateTradePwdStateBindMobile = 0,
    ActivateTradePwdStateOpenAccount,
    ActivateTradePwdStateActivateTrade,
    ActivateTradePwdStateRemoteLogin//异地登录
};

@interface ActivateTradePwdView : UIView

@property (nonatomic ,assign) ActivateTradePwdState viewState;

@property (nonatomic ,copy) void(^activateTradePwdViewCancelButtonClick)();
@property (nonatomic ,copy) void(^activateTradePwdViewConfirmButtonClick)();



- (instancetype)initWithState:(ActivateTradePwdState)viewState;

- (void)show;

@end
