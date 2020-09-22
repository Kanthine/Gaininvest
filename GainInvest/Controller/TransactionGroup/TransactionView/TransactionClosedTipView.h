//
//  TransactionClosedTipView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/20.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionClosedTipView : UIView

@property (nonatomic ,copy) void(^closedTipConfirmButtonClick)();


- (void)show;

@end
