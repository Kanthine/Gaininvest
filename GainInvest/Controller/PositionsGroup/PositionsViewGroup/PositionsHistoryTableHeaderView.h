//
//  PositionsHistoryTableHeaderView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/9.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionsHistoryTableHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *lookMyCouponButton;
@property (weak, nonatomic) IBOutlet UILabel *balanceLable;//账户余额
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;//充值
@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;//提现

@end
