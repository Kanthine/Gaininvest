//
//  RechargeQualityItemView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/21.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeQualityItemView : UIView

@property (nonatomic ,strong) UIButton *itemButton;

- (instancetype)initWithFrame:(CGRect)frame Image:(NSString *)imageName Title:(NSString *)titieString;


@end
