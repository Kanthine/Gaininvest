//
//  OpenPositionResultTipView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/30.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenPositionResultTipView : UIView

@property (nonatomic ,copy) void(^openPositionLookPositionClick)();
@property (nonatomic ,copy) void(^openPositionLookAgainBuyClick)();

- (instancetype)initWithError:(NSError *)error;

- (void)show;

@end
