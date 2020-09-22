//
//  ConfirmClosePositionView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/13.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmClosePositionView : UIView

@property (nonatomic ,copy) void(^ confirmClosePosition)();

- (void)show;

@end
