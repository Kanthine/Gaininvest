//
//  WithdrawBankCardInfoView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/3/15.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WithdrawViewController;
@interface WithdrawBankCardInfoView : UIView

@property (nonatomic ,strong) NSDictionary *infoDict;
@property (nonatomic ,strong) NSString *accountMoney;

@property (nonatomic ,weak) WithdrawViewController *currentViewController;

@property (weak, nonatomic) IBOutlet UIButton *updateBankCardInfoButton;


@end
