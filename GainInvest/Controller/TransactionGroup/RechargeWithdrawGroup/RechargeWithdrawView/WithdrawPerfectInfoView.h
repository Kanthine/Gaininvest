//
//  WithdrawPerfectInfoView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/29.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WithdrawViewController;

@interface WithdrawPerfectInfoView : UIView

@property (nonatomic ,strong) NSString *accountMoney;

@property (nonatomic ,weak) WithdrawViewController *currentViewController;


@end
