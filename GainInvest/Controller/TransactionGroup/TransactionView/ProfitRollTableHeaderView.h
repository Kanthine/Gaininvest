//
//  ProfitRollTableHeaderView.h
//  GainInvest
//
//  Created by 苏沫离 on 17/2/23.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfitRollTableHeaderView : UIView


@property (nonatomic ,weak) UIViewController *viewController;

- (void)updateProfitRollTableHeaderView:(NSMutableArray<InorderModel *> *)listArray;

@end
