//
//  UpdateGainOrLossTipView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/13.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateGainOrLossTipView : UIView

@property (nonatomic ,strong) UILabel *timeLable;
@property (nonatomic ,copy) void(^ updateGainOrLossTipView)(int topLimit,int bottomLimit);

- (instancetype)initWithTopLimit:(CGFloat)topLimit BottomLimit:(CGFloat)bottomLimit;

- (void)show;

@end
